//===- MultiValueAnalysis.cpp - SPMD Pass: Add GPU memory related operations -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This implements the pass multi-value-analysis which analyses the IR 
//  and add attributes specifying multi-valuedness and executor behavior.
//
//===----------------------------------------------------------------------===//


#include "mlir/Pass/Pass.h"
#include "spmd/SPMDPasses.h"
#include "spmd/SPMDOps.h"
#include "spmd/SPMDAttributes.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/Support/Debug.h"

#include "spmd/Analysis/UniformityAnalysis.h"

#define DEBUG_TYPE "multi-value-analysis"

#define PATTERN "main"
#define DBGS() ::llvm::dbgs() << "[" DEBUG_TYPE ":" << PATTERN << "] "

using namespace mlir;
using namespace mlir::dataflow;
using namespace mlir::spmd;

namespace mlir::spmd {
// Define Base Class and Default Constructor for main Class
#define GEN_PASS_DEF_MULTIVALUEANALYSIS
#include "spmd/SPMDPasses.h.inc"
  
namespace {


enum class ExecKind { All, AllBut, Static, Dynamic, One, AllButOne };

void setSV(Operation *opr) {
  Builder builder(opr);
  opr->setDiscardableAttr(StringRef("spmd.isMultiValued"), builder.getBoolAttr(false));
}

void setMV(Operation *opr) {
  Builder builder(opr);
  opr->setDiscardableAttr(StringRef("spmd.isMultiValued"), builder.getBoolAttr(true));
}

void setExecKind(Operation *opr, ExecKind execKind) {
  Builder builder(opr);
  std::string execKindStr;
  assert(execKind == ExecKind::All || execKind == ExecKind::AllBut || execKind == ExecKind::Static || execKind == ExecKind::Dynamic || execKind == ExecKind::One);
  switch(execKind) {
    case ExecKind::All:
      execKindStr = "All";
      break;
    case ExecKind::AllBut:
      execKindStr = "AllBut";
      break;
    case ExecKind::Static:
      execKindStr = "Static";
      break;
    case ExecKind::Dynamic:
      execKindStr = "Dynamic";
      break;
    case ExecKind::One:
      execKindStr = "One";
      break;
    case ExecKind::AllButOne:
      execKindStr = "One";
      break;
  }
  opr->setDiscardableAttr(StringRef("spmd.executionKind"), builder.getStringAttr(execKindStr));
}


const Uniformity &getUniformity(DataFlowSolverWrapper &solver, Value val){
  const auto *lattice = solver.lookupState<UniformityLattice>(val);
  assert(lattice && "expected uniformity information");
  assert(!lattice->getValue().isUninitialized() && "lattice element should be initialized");
  return lattice->getValue();
}

// Function to check if an operation is `arith.cmpi ne`
bool isArithCmpINeOp(Operation *op) {
  // Check if the operation is an arith.cmpi operation
  if (auto cmpOp = dyn_cast<arith::CmpIOp>(op)) {
    // Check if the predicate is ne (not equal)
    if (cmpOp.getPredicate() == arith::CmpIPredicate::ne) {
      return true;
    }
  }
  return false;
}

void getCmpOps(SmallVector<Operation*> &cmpOps, Operation *opr, bool *reversedCase, Operation *user = nullptr) {
  static bool isFirstExec = false;
  if (auto ifOp = dyn_cast<scf::IfOp>(opr)){
    getCmpOps(cmpOps, ifOp.getCondition().getDefiningOp(), reversedCase);
    if (ifOp->getNumResults() > 0 && isa<arith::ConstantOp>(ifOp.thenYield()->getOperand(0).getDefiningOp())) {
      if (auto boolAttr = ifOp.thenYield()->getOperand(0).getDefiningOp()->getAttrOfType<BoolAttr>(StringRef("value"))) {
        if (isFirstExec){
          *reversedCase = false;
        }
        getCmpOps(cmpOps, ifOp.elseYield()->getOperand(0).getDefiningOp(), reversedCase);
      }
    }
    else if (ifOp->getNumResults() > 0 && isa<arith::ConstantOp>(ifOp.elseYield()->getOperand(0).getDefiningOp())) {
      if (ifOp.elseYield()->getOperand(0).getDefiningOp()->getAttrOfType<BoolAttr>(StringRef("value"))) {
        if (isFirstExec){
          *reversedCase = true;
        }
        getCmpOps(cmpOps, ifOp.thenYield()->getOperand(0).getDefiningOp(), reversedCase);
      }
    }
  }
  else if (isa<arith::CmpIOp>(opr)) {
    cmpOps.push_back(opr);
  }
  else if (isa<arith::OrIOp>(opr)) {
    getCmpOps(cmpOps, opr->getOperand(0).getDefiningOp(), reversedCase, opr);
    getCmpOps(cmpOps, opr->getOperand(1).getDefiningOp(), reversedCase, opr);
  }
  else if (auto arithAndiOp = dyn_cast<arith::AndIOp>(opr)) {
    if (!user) {
      llvm_unreachable("\nNot implemented case\n");
    }
    if (isa<arith::OrIOp>(user)) {
      Operation *defOpr0 = arithAndiOp->getOperand(0).getDefiningOp();
      Operation *defOpr1 = arithAndiOp->getOperand(1).getDefiningOp();
      if(isArithCmpINeOp(defOpr0)) {
        getCmpOps(cmpOps, defOpr1, reversedCase, opr);
      }
      else if (isArithCmpINeOp(defOpr1)) {
        getCmpOps(cmpOps, defOpr0, reversedCase, opr);
      }
      else {
        llvm_unreachable("\nNot implemented case if compare operation kind\n");
      }
    }
    else {
      llvm_unreachable("\nNot implemented case if compare operation kind\n");
    }
  }
  else {
    llvm_unreachable("\nNot implemented case if compare operation kind\n");
  }
}

bool getExecutor(DataFlowSolverWrapper &solver, Value &value, int32_t *executor) {
  if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(value.getDefiningOp())) {
    if (IntegerAttr intAttr = constantOp->getAttrOfType<IntegerAttr>(StringRef("value"))) {
      *executor = intAttr.getInt();
      return true;
    }
    else{
      llvm_unreachable("\nNot implemented case of constant op\n");
    }
  }
  else if (getUniformity(solver, value).isUniform()) {
    *executor = -1;
    return true;
  }
  else {
    return true;
  }
}

SmallVector<int32_t> getExecutors(DataFlowSolverWrapper &solver, RegionBranchOpInterface branchOp, bool *reversedCase) {
  SmallVector<int32_t> executors {};
  SmallVector<Operation*> cmpOps;
  getCmpOps(cmpOps, branchOp, reversedCase);

  for (Operation *cmpOp : cmpOps) {
    if (isa<arith::CmpIOp>(cmpOp)) {
      Value lhs = cmpOp->getOperand(0);
      Value rhs = cmpOp->getOperand(1);
      int32_t executor;
      if (isa<spmd::GetRankInCommOp>(lhs.getDefiningOp())) {
        if (getExecutor(solver, rhs, &executor)){
          executors.push_back(executor);
        }
      }
      else if (isa<spmd::GetRankInCommOp>(rhs.getDefiningOp())) {
        if (getExecutor(solver, lhs, &executor)){
          executors.push_back(executor);
        }
      }
    }
    else {
       llvm_unreachable("\nNot implemented case of cmpOp\n");
    }
  }
  //if the vector contains a -1, meaning one part of the executors are dynamically unkown 
  //and only marked as "one", return empty exectuors for going into the dynamic case
  // provided the size is greater than 1, otherwise it would be a true "One" case
  if (executors.size() > 1 && std::find(executors.begin(), executors.end(), -1) != executors.end()) {
    executors.clear();
  }
  return executors;
}

struct MultiValueAnalysis : impl::MultiValueAnalysisBase<MultiValueAnalysis> {
  using MultiValueAnalysisBase::MultiValueAnalysisBase;
  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    // todo: with the sycl analysis we dont need the main anymore and can operate on the level of moduleOp
    // Operation *mainOpr = moduleOp.lookupSymbol("main");  
    // if (mainOpr == NULL) {
    //   LLVM_DEBUG(DBGS() << "Pass failed since no main func exists\n");
    //   signalPassFailure();
    //   return;
    // }
    OpBuilder builder(moduleOp);

    // mainOpr->walk<WalkOrder::PreOrder>([&](Operation *opr) {
    //   checkMultiValuedness(opr);
    // });

    AliasAnalysis &aliasAnalysis = getAnalysis<AliasAnalysis>();
    // aliasAnalysis.addAnalysisImplementation(sycl::AliasAnalysis(relaxedAliasing));

    DataFlowSolverWrapper solver(aliasAnalysis);
    solver.loadWithRequiredAnalysis<UniformityAnalysis>();

    if (failed(solver.initializeAndRun(moduleOp))) {
      LLVM_DEBUG(llvm::dbgs()
                << DEBUG_TYPE ": Unable to run required dataflow analysis\n");
      return;
    }

    // moduleOp->walk<WalkOrder::PreOrder>([&](Operation *opr) {
    //   if (isa<ModuleOp>(opr)){
    //     return;
    //   }
    //   opr->dump();
    //   int counter = 0;
    //   LLVM_DEBUG(DBGS() << "Is Divergent?:" << isDivergent(opr, solver) << "\n");
    //   LLVM_DEBUG(DBGS() << "Results:" << "\n");
    //   for (Value val : opr->getResults()) {
    //      LLVM_DEBUG(DBGS() << "Result Num: "<< counter << " " << getUniformity(solver, val));
    //      counter++;
    //   }
    //   counter=0;
    //   LLVM_DEBUG(DBGS() << "\n" << "Operands:" << "\n");
    //   for (Value val : opr->getOperands()) {
    //     val.dump();
    //      LLVM_DEBUG(DBGS() << "Operand Num: "<< counter << " " << getUniformity(solver, val));
    //      counter++;
    //   }
    //   LLVM_DEBUG(DBGS() << "\n");
    // });

    moduleOp->walk<WalkOrder::PreOrder>([&](Operation *opr) {
      setExecKind(opr, ExecKind::All);
    });


    moduleOp->walk<WalkOrder::PreOrder>([&](Operation *opr) {
      // checkMultiValuedness(opr);
      // bool isSV = true;
      // for (Value val : opr->getResults()) {
      //   if (getUniformity(solver, val).isNonUniform()) {
      //     setMV(opr);
      //     isSV = false;
      //     break;
      //   }
      // }
      // for (Value val : opr->getOperands()) {
      //   if (getUniformity(solver, val).isNonUniform()) {
      //     setMV(opr);
      //     isSV = false;
      //     break;
      //   }
      // }
      // if (isSV) {
      //   setSV(opr);
      // }
      

      if (auto branchOp = dyn_cast<RegionBranchOpInterface>(opr)) {
        std::optional<IfCondition> cond = IfCondition::getCondition(branchOp);
        bool isMV;
        if (cond) {
          isMV = cond->perform([&](ValueRange values) {
            return llvm::any_of(values,
                                [&](Value val) { return getUniformity(solver, val).isNonUniform(); });
          });
          if (isMV){
            bool reversedCase = false;
            SmallVector<int32_t> executors = getExecutors(solver, branchOp, &reversedCase);
            if (executors.empty()) {
              if (isa<scf::IfOp>(opr)) {
                opr->getRegion(0).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                  setExecKind(nestedOpr, ExecKind::Dynamic);
                });
                if(opr->getNumRegions() == 2) {
                  opr->getRegion(1).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                    setExecKind(nestedOpr, ExecKind::Dynamic);
                  });
                }
              }
            }
            else if (executors.size() == 1 && executors[0] == -1) {
              if (isa<scf::IfOp>(opr)) {
                opr->getRegion(0).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                  setExecKind(nestedOpr, ExecKind::One);
                });
                if(opr->getNumRegions() == 2) {
                  opr->getRegion(1).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                    setExecKind(nestedOpr, ExecKind::AllButOne);
                  });
                }
              }
            }
            else {
              if (isa<scf::IfOp>(opr)) {
                if (reversedCase) {
                  opr->getRegion(0).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                    setExecKind(nestedOpr, ExecKind::AllBut);
                    nestedOpr->setDiscardableAttr(StringRef("spmd.executedNotBy"), builder.getDenseI32ArrayAttr(ArrayRef<int32_t>(executors)));
                  });
                  if(opr->getNumRegions() == 2) {
                    opr->getRegion(1).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                      setExecKind(nestedOpr, ExecKind::Static);
                      nestedOpr->setDiscardableAttr(StringRef("spmd.executedBy"), builder.getDenseI32ArrayAttr(ArrayRef<int32_t>(executors)));
                    });
                  }
                }
                else {
                  opr->getRegion(0).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                    setExecKind(nestedOpr, ExecKind::Static);
                    nestedOpr->setDiscardableAttr(StringRef("spmd.executedBy"), builder.getDenseI32ArrayAttr(ArrayRef<int32_t>(executors)));
                  });
                  if(opr->getNumRegions() == 2) {
                    opr->getRegion(1).walk<WalkOrder::PreOrder>([&](Operation *nestedOpr) {
                      setExecKind(nestedOpr, ExecKind::AllBut);
                      nestedOpr->setDiscardableAttr(StringRef("spmd.executedNotBy"), builder.getDenseI32ArrayAttr(ArrayRef<int32_t>(executors)));
                    });
                  }
                }
              }
            }
          }
        }
        else {
          isMV = llvm::any_of(branchOp->getOperands(),
                              [&](Value val) { return getUniformity(solver, val).isNonUniform(); });
        }
        if (isMV) {
          setMV(branchOp.getOperation());
        }
        else {
          setSV(branchOp.getOperation());
        }
      }
    });
  }
};

} // namespace
} // namespace mlir::spmd
