//===- ConvertApiCallsToRma.cpp - SPMD Pass: Add GPU memory related operations -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This implements the pass ConvertApiCallsToRma which converts rma related api 
// calls of different programming models to the so-called rma dialect.
//
//===----------------------------------------------------------------------===//

#include "spmd/SPMDPasses.h"

#include "CACTS/mpiTransformations.h"
#include "CACTS/shmemTransformations.h"
#include "CACTS/ncclTransformations.h"

#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

namespace mlir::spmd {
// Define Base Class and Default Constructor for main Class
#define GEN_PASS_DEF_CONVERTAPICALLSTOSPMD
#include "spmd/SPMDPasses.h.inc"

namespace {

//pattern to remove non-pure operations by applyPatternsAndFoldGreedily
struct MemrefErase : public OpRewritePattern<memref::StoreOp> {
  using OpRewritePattern<memref::StoreOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(memref::StoreOp storeOp,
                                PatternRewriter &rewriter) const final {
    OpBuilder builder(storeOp);
    Value memref = storeOp.getMemref();
    for (Operation *user : memref.getUsers()) {
      if (!isa<memref::StoreOp>(user)) {
        return failure();
      }
    }
    rewriter.eraseOp(storeOp);
    return success();
  }
};

//pattern to remove unused func ops that arent called in the main function after being inlined by polygeist
struct FuncErase : public OpRewritePattern<func::FuncOp> {
  using OpRewritePattern<func::FuncOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(func::FuncOp funcOp,
                                PatternRewriter &rewriter) const final {
    OpBuilder builder(funcOp);

    if (funcOp.getSymName().equals(StringRef("main"))) {
      return failure();
    }

    ModuleOp moduleOp = funcOp->getParentOfType<ModuleOp>();

   // look into all functions in module if any of them calls the funcOp possibly to be erased
    for (Operation &opr : moduleOp.getBodyRegion().getOps()) {
      if (func::FuncOp funcOp2 = dyn_cast<func::FuncOp>(&opr)) {
        
    //look, if symbol uses are given, that all of them are recursive calls
        if (funcOp2.getSymName().equals(funcOp.getSymName()) == false) {
          if (SymbolTable::symbolKnownUseEmpty(funcOp.getSymNameAttr(), funcOp2) == false) {
            return failure();  
          } 
        }
      }
    }

    rewriter.eraseOp(funcOp);
    return success();   
  }
};

struct ConvertApiCallsToSPMD : impl::ConvertApiCallsToSPMDBase<ConvertApiCallsToSPMD> {
  using ConvertApiCallsToSPMDBase::ConvertApiCallsToSPMDBase;
  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    Operation *mainOpr = moduleOp.lookupSymbol("main");  
    if (mainOpr == NULL) {
      LLVM_DEBUG(DBGS() << "Pass failed since no main func exists\n");
      signalPassFailure();
      return;
    }
    OpBuilder opBuilder(moduleOp);

    // if (usedModel=="mpi" || usedModel=="shmem" || usedModel=="nccl") {
    //   RewritePatternSet patterns(&getContext());
    //   GreedyRewriteConfig config;
    //   // todo inline all func calls if e.g. polygeist did not already
    //   patterns.insert<MemrefErase, FuncErase>(&getContext());
    //   (void)applyPatternsAndFoldGreedily(moduleOp, std::move(patterns), config);
    // }


    if (usedModel=="mpi") {
      LLVM_DEBUG(DBGS() << "mpi case" << "\n");
      mainOpr->walk([&](func::CallOp callOp) {
        convertApiCallMPI(callOp, /*modelGroup=*/0);
      });
      deleteApiCalleesMPI(moduleOp);
    }
    else if (usedModel=="shmem") {
      LLVM_DEBUG(DBGS() << "shmem case" << "\n");     
      mainOpr->walk([&](func::CallOp callOp) {
        convertApiCallSHMEM(callOp, /*modelGroup=*/0);
      });
      deleteApiCalleesSHMEM(moduleOp);
      if (Operation *memrefGlobal = moduleOp.lookupSymbol("SHMEM_TEAM_WORLD")) {
        memrefGlobal->erase();
      }
    }
    else if (usedModel=="nccl" || usedModel=="mpi+nccl") {
      LLVM_DEBUG(DBGS() << "nccl case" << "\n");   
      mainOpr->walk([&](func::CallOp callOp) {
        if (callOp.getCallee().starts_with(StringRef("MPI_"))) {
          convertApiCallMPI(callOp, /*modelGroup=*/0);
        }
        else {
          convertApiCallNCCL(callOp, /*modelGroup=*/1);
        }
      });
      deleteApiCalleesMPI(moduleOp);
      deleteApiCalleesNCCL(moduleOp);
    }
    else if (usedModel=="mpi+shmem") {
      LLVM_DEBUG(DBGS() << "mpi+shmem case" << "\n");   
      mainOpr->walk([&](func::CallOp callOp) {
        if (callOp.getCallee().starts_with(StringRef("MPI_"))) {
          convertApiCallMPI(callOp, /*modelGroup=*/0);
        }
        else {
          convertApiCallSHMEM(callOp, /*modelGroup=*/1);
        }
      });
      deleteApiCalleesMPI(moduleOp);
      deleteApiCalleesSHMEM(moduleOp);
    }
    else if (usedModel=="shmem+nccl") {
      LLVM_DEBUG(DBGS() << "shmem+nccl case" << "\n");   
      mainOpr->walk([&](func::CallOp callOp) {
        if (callOp.getCallee().starts_with(StringRef("shmem_"))) {
          convertApiCallSHMEM(callOp, /*modelGroup=*/0);
        }
        else {
          convertApiCallNCCL(callOp, /*modelGroup=*/1);
        }
      });
      deleteApiCalleesSHMEM(moduleOp);
      deleteApiCalleesNCCL(moduleOp);
    }
    else {
      LLVM_DEBUG(DBGS() << "Pass failed since pass option 'used-model' is set to an unsupported value. Please refer to spmd-opt --help\n");
      signalPassFailure();
      return;
    }
    if (usedModel=="mpi" || usedModel=="shmem" || usedModel=="nccl" || usedModel=="mpi+shmem") {
      RewritePatternSet patterns(&getContext());
      GreedyRewriteConfig config;
      //TODO: above conversion functions could be rewritten as patterns, useful for complex cases
      patterns.insert<MemrefErase, FuncErase>(&getContext());
      (void)applyPatternsAndFoldGreedily(moduleOp, std::move(patterns), config);
    }
    // moduleOp->dump();
  }
};

} // namespace
} // namespace mlir::spmd
