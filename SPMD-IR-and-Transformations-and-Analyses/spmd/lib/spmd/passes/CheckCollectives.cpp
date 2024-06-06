//===- CheckCollectives.cpp - SPMD Pass: Add GPU memory related operations -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This implements the pass Checkcollectives which analyses the IR 
//  and decides whether a collective commmunication error is given.
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

#define DEBUG_TYPE "check-collectives"

#define PATTERN "main"
#define DBGS() ::llvm::dbgs() << "[" DEBUG_TYPE ":" << PATTERN << "] "

namespace mlir::spmd {
// Define Base Class and Default Constructor for main Class
#define GEN_PASS_DEF_CHECKCOLLECTIVES
#include "spmd/SPMDPasses.h.inc"

namespace {

bool isMV(Operation *opr) {
  if (BoolAttr attr = opr->getAttrOfType<BoolAttr>("spmd.isMultiValued")){
    return attr.getValue();
  }
  llvm_unreachable("\nShould not happen, all operations questioned should have a defined MVness\n");
} 

struct ErrorInfo {
  // SmallVector<int> involvedRanks;
  SmallVector<Operation*> conflictOprs;
  SmallVector<Operation*> causingOprs; //in particular ifOps

  ErrorInfo(SmallVector<Operation*> &oprs1, SmallVector<Operation*> &oprs2) 
      : conflictOprs{oprs1}, causingOprs{oprs2} {}
};
  
struct CollectivesOrder {
  SmallVector<SmallVector<Operation*>> bcastsWithOrder;
  SmallVector<SmallVector<Operation*>> IbcastsWithOrder;
  SmallVector<SmallVector<Operation*>> reducesWithOrder;
  SmallVector<SmallVector<Operation*>> IreducesWithOrder;
  SmallVector<SmallVector<Operation*>> scansWithOrder;
  SmallVector<SmallVector<Operation*>> IscansWithOrder;
  SmallVector<SmallVector<Operation*>> exscansWithOrder;
  SmallVector<SmallVector<Operation*>> IexscansWithOrder;
  SmallVector<SmallVector<Operation*>> allreducesWithOrder;
  SmallVector<SmallVector<Operation*>> IallreducesWithOrder;
  SmallVector<SmallVector<Operation*>> barriersWithOrder;
  SmallVector<SmallVector<Operation*>> scattersWithOrder;
  SmallVector<SmallVector<Operation*>> IscattersWithOrder;
  SmallVector<SmallVector<Operation*>> IbarriersWithOrder;
  SmallVector<SmallVector<Operation*>> gathersWithOrder;
  SmallVector<SmallVector<Operation*>> IgathersWithOrder;
  SmallVector<SmallVector<Operation*>> allgathersWithOrder;
  SmallVector<SmallVector<Operation*>> IallgathersWithOrder;
  SmallVector<SmallVector<Operation*>> alltoallsWithOrder;
  SmallVector<SmallVector<Operation*>> IalltoallsWithOrder;
  SmallVector<SmallVector<Operation*>> reduceScattersWithOrder;
  SmallVector<SmallVector<Operation*>> IreduceScattersWithOrder;
};

// struct OperationHashFunction {
//   size_t operator()(const Operation& opr) const {
//     return mlir::hash_value(opr);
//   }
// };

void increaseContainerSizesIfNeeded(CollectivesOrder &collectivesOrder, size_t executionOrderCounter) {
  if (executionOrderCounter == collectivesOrder.bcastsWithOrder.size()) {
    collectivesOrder.bcastsWithOrder.emplace_back();
    collectivesOrder.IbcastsWithOrder.emplace_back();
    collectivesOrder.reducesWithOrder.emplace_back();
    collectivesOrder.IreducesWithOrder.emplace_back();
    collectivesOrder.scansWithOrder.emplace_back(); 
    collectivesOrder.IscansWithOrder.emplace_back(); 
    collectivesOrder.exscansWithOrder.emplace_back(); 
    collectivesOrder.IexscansWithOrder.emplace_back(); 
    collectivesOrder.allreducesWithOrder.emplace_back();
    collectivesOrder.IallreducesWithOrder.emplace_back();
    collectivesOrder.barriersWithOrder.emplace_back();
    collectivesOrder.scattersWithOrder.emplace_back();
    collectivesOrder.IscattersWithOrder.emplace_back();
    collectivesOrder.IbarriersWithOrder.emplace_back();
    collectivesOrder.gathersWithOrder.emplace_back();
    collectivesOrder.IgathersWithOrder.emplace_back();
    collectivesOrder.allgathersWithOrder.emplace_back();
    collectivesOrder.IallgathersWithOrder.emplace_back();
    collectivesOrder.alltoallsWithOrder.emplace_back();
    collectivesOrder.IalltoallsWithOrder.emplace_back();
    collectivesOrder.reduceScattersWithOrder.emplace_back();
    collectivesOrder.IreduceScattersWithOrder.emplace_back();
  }
}

bool isBlocking(Operation *opr) {
  return opr->getAttrOfType<BoolAttr>(StringRef("isBlocking")).getValue() == true;
}

bool isNonBlocking(Operation *opr) {
  return opr->getAttrOfType<BoolAttr>(StringRef("isBlocking")).getValue() == false;
}

bool isSearchedComm(Operation *opr, Value &comm) {
  return opr->getOperand(0) == comm;
}

void iterateForCollectives(Region &toBeIteratedRegion, CollectivesOrder &collectivesOrder,
    size_t executionOrderCounter, Value &comm) {
  for (Operation &oprRef : toBeIteratedRegion.getOps()) {
    Operation *opr = &oprRef;
    if (isa<spmd::BcastOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.bcastsWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    if (isa<spmd::BcastOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IbcastsWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ReduceOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.reducesWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ReduceOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IreducesWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ScanOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.scansWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ScanOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IscansWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ExscanOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.exscansWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ExscanOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IexscansWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::AllreduceOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.allreducesWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::AllreduceOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IallreducesWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::BarrierOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.barriersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ScatterOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.scattersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ScatterOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IscattersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::BarrierOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IbarriersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    if (isa<spmd::GatherOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.gathersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    if (isa<spmd::GatherOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IgathersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    if (isa<spmd::AllgatherOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.allgathersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    if (isa<spmd::AllgatherOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IallgathersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::AlltoallOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.alltoallsWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::AlltoallOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IalltoallsWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ReduceScatterOp>(opr) && isSearchedComm(opr, comm) && isBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.reduceScattersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (isa<spmd::ReduceScatterOp>(opr) && isSearchedComm(opr, comm) && isNonBlocking(opr)) {
      increaseContainerSizesIfNeeded(collectivesOrder, executionOrderCounter);
      collectivesOrder.IreduceScattersWithOrder[executionOrderCounter].push_back(opr);
      executionOrderCounter++;
      continue;
    }
    else if (scf::IfOp ifOp = dyn_cast<scf::IfOp>(opr)){
      iterateForCollectives(ifOp.getThenRegion(), collectivesOrder, executionOrderCounter, comm);
      if (ifOp.getNumRegions() > 1) {
        iterateForCollectives(ifOp.getElseRegion(), collectivesOrder, executionOrderCounter, comm);
      }
    }
    else if (scf::ForOp forOp = dyn_cast<scf::ForOp>(opr)){
      iterateForCollectives(forOp->getRegion(0), collectivesOrder, executionOrderCounter, comm);
    }
  }
}

SmallVector<Operation*> getEnclosingOps(Operation *opr) {
  SmallVector<Operation*> pdf;
  Operation* parentOpr = opr;
  while((parentOpr = parentOpr->getParentOp())) {
    if (isa<RegionBranchOpInterface>(parentOpr)) {
      pdf.push_back(parentOpr);
    }
  }
  std::reverse(pdf.begin(), pdf.end());
  return pdf;
}

template <typename OpTy> 
uint64_t checkIfContainsOneOfCollectives(Region &toBeIteratedRegion, 
    SmallVector<Operation*> filteredFusedPDFs, SmallVector<Operation*> collectives) {
  int64_t result = 0;
  toBeIteratedRegion.walk([&](OpTy op) {
    if (std::find(collectives.begin(), collectives.end(), op.getOperation()) != collectives.end()) {
      
      LLVM_DEBUG(DBGS() << op->template getAttrOfType<IntegerAttr>("numberOfExecution").template cast<IntegerAttr>().getInt());
      result = std::max(result, op->template getAttrOfType<IntegerAttr>("numberOfExecution").template cast<IntegerAttr>().getInt());
    }
  });
  return result;
}

template <typename OpTy> 
bool isPDFP(Operation *ifOpr, SmallVector<Operation*> filteredFusedPDFs, SmallVector<Operation*> collectives) {
  uint64_t thenBranch = checkIfContainsOneOfCollectives<OpTy>(ifOpr->getRegion(0), filteredFusedPDFs, collectives);
  uint64_t elseBranch = 0;
  if (ifOpr->getNumRegions() > 1) {
    elseBranch = checkIfContainsOneOfCollectives<OpTy>(ifOpr->getRegion(1), filteredFusedPDFs, collectives);
  }
  // XOR
  if (thenBranch != elseBranch){
    return true;
  }
  // both branches include one of collective, both not containing can not happen,
  // otherwise they would be not in the preliminary PDFList
  else {
    // if (hasDifferentEnclosingLoops(collectives)) {
    //   return true;
    // }
    // else {
      return false;
    // }
  }
}

//check if one of both lists start same as the other
bool checkIfStartsSame(SmallVector<Operation*> &originalSubList, SmallVector<Operation*> &subList) {
  size_t subListSize = subList.size();
  size_t originalSubListSize = originalSubList.size();
  size_t smallerSize = std::min(subListSize, originalSubListSize);
  for (size_t j=0; j<smallerSize; j++) {
    if (subList[j] != originalSubList[j]) {
      return false;
    }
  }
  return true;
}

//check if fusedIfOpsLists includes a list starting same as originalSubList
// if there is one, then the index of the respective sublist will be stored in foundIdx
bool checkIfIncluded(size_t *foundIdx, SmallVector<Operation*> &originalSubList,
      SmallVector<SmallVector<Operation*>> &fusedIfOpsLists) {
  for (size_t i=0; i<fusedIfOpsLists.size(); i++) { 
    auto &subList = fusedIfOpsLists[i];
    if (checkIfStartsSame(originalSubList, subList)) {
      *foundIdx = i;
      return true;
    }  
  }
  return false;
}

bool calculateNumIterations(scf::ForOp forOp, int64_t *numIterations) {
    // Check if lower bound, upper bound, and step are constant
    auto lowerBoundOp = forOp.getLowerBound().getDefiningOp<arith::ConstantOp>();
    auto upperBoundOp = forOp.getUpperBound().getDefiningOp<arith::ConstantOp>();
    auto stepOp = forOp.getStep().getDefiningOp<arith::ConstantOp>();

    if (!lowerBoundOp || !upperBoundOp || !stepOp) {
        return false; // Indicating that the number of iterations cannot be determined statically
    }

    // Extract constant values
    int64_t lowerBound = lowerBoundOp.getValue().cast<IntegerAttr>().getInt();
    int64_t upperBound = upperBoundOp.getValue().cast<IntegerAttr>().getInt();
    int64_t step = stepOp.getValue().cast<IntegerAttr>().getInt();

    // Calculate the number of iterations
    if (step == 0) {
        llvm::errs() << "Step value is zero, which is invalid.\n";
        return false; // Indicating an error
    }

    *numIterations = (upperBound - lowerBound + step - 1) / step; // Ceiling of division
    return true;
}

template <typename OpTy> 
SmallVector<Operation*> getPDFP(SmallVector<Operation*> collectives, uint64_t numRanks) {

  //Statically available executing ranks and numRanks Extension
  //if the number of ranks for execution is given, check if each rank is executing the operation, provided that the executing ranks are statically known
  if (numRanks != 0){
    SmallVector<bool> executedBy(numRanks, false);
    for (Operation* opr : collectives) {
      if (auto attr = opr->getDiscardableAttr(StringRef("spmd.executionKind"))){
        if (StringAttr stringAttr = dyn_cast<StringAttr>(attr)){
          if (stringAttr.getValue() == "Static"){
            if (auto attr2 = opr->getDiscardableAttr(StringRef("spmd.executedBy"))) {
              if (auto arrayAttr = dyn_cast<DenseI32ArrayAttr>(attr2)) {
                for (uint32_t executor : arrayAttr.asArrayRef()) {
                  if (executor < numRanks){
                    executedBy[executor] = true;
                  }
                }
              }
            }
          }
        }
      }
    }
    if (std::find(executedBy.begin(), executedBy.end(), false) == executedBy.end()) {
      return SmallVector<Operation*>();
    }
  }

  SmallVector<SmallVector<Operation*>> enclosingOpsPerCollective;
  for (Operation* opr : collectives) {
    enclosingOpsPerCollective.push_back(getEnclosingOps(opr));
  }

  // Loop Execution Count Extensions
  for (size_t i = 0; i < collectives.size(); i++) {
    if (enclosingOpsPerCollective[i].empty()) {
      continue;
    }
    Operation* opr = collectives[i];
    OpBuilder builder(opr);
    //set default number of execution
    int64_t numIterations = 1;
    size_t numEnclosingOps = enclosingOpsPerCollective[i].size();
    for (size_t j = 0; j<numEnclosingOps;j++) {
      //only regard loops that are directly including the collective without an ifOp in-between
      if (isa<scf::IfOp>(enclosingOpsPerCollective[i][numEnclosingOps-j-1])){
        break;
      }
      else if (auto forOp = dyn_cast<scf::ForOp>(enclosingOpsPerCollective[i][numEnclosingOps-j-1])) {
        int64_t loopCount;
        if (calculateNumIterations(forOp, &loopCount)) {
          numIterations *= loopCount;
          enclosingOpsPerCollective[i].pop_back();
        }
      }
    }
    opr->setDiscardableAttr(StringRef("numberOfExecution"), builder.getI64IntegerAttr(numIterations)); 
  }

  //calculate those scf chains that enclose the collectives but do not include duplicates
  // TODO: this should be in theory inpossible, since if there is a collective at [A,B] there can no be at [A,B,C]
  // if given [A,B] and [A,B,C], [A,B,D] keep [A,B,C] and [A,B,D]
  SmallVector<SmallVector <Operation*>> fusedOpsLists;
  for (auto &originalSubList : enclosingOpsPerCollective) {
    // if no ifOpr etc, enlosing the colletive, is present, then skip it
    // todo: this should be not possible
    if (originalSubList.empty()) {
      continue;
    }
    size_t foundIdx;
    bool found = checkIfIncluded(&foundIdx, originalSubList, fusedOpsLists);

    if (found == false) {
      fusedOpsLists.push_back(originalSubList);
    }
    else {
      if (originalSubList.size() > fusedOpsLists[foundIdx].size()) {
        fusedOpsLists[foundIdx] = originalSubList;
      }
    }
  } 

  //only include those enclosing ops that are MV, meaning skip first branchOps that are SV
  SmallVector<SmallVector <Operation*>> filteredFusedOpsLists;
  for (auto &subList : fusedOpsLists) {
    size_t subListSize = subList.size();
    for (size_t j=0; j<subListSize; j++) { 
      Operation *opr = subList[j];
      if (isMV(opr)) {
        filteredFusedOpsLists.emplace_back(subList.begin()+j, subList.end());
        break;
      }
    }
  }

  SmallVector<Operation*> PDFP;
  SmallVector<Operation*> checkedIfOprs;
  for (auto &subList : filteredFusedOpsLists) {
    // SmallVector<Operation*> tmpList; 
    for (Operation *opr : subList) {
      if (isa<scf::IfOp>(opr)) {
        // since filteredFusedOpsLists can still have [A,B,C] and [A,B,D], to avoid extra work only check one ifOp (here A) once
        if (std::find(checkedIfOprs.begin(), checkedIfOprs.end(), opr) == checkedIfOprs.end()) { //not found
          if (isPDFP<OpTy>(opr, subList, collectives)) {
            PDFP.push_back(opr);
            break;
          }
          checkedIfOprs.push_back(opr);
        }
      }
      else {
        // conditionals like forOps or whileOps are regarded if a static analysis was not possible
        if (std::find(PDFP.begin(), PDFP.end(), opr) == PDFP.end()) { //not found 
          PDFP.push_back(opr);
          checkedIfOprs.push_back(opr);
          break;
        }
      }
    }
    //only take the last branchLikeOp with an unmatched execution
    // if (tmpList.empty() == false) {
    //   PDFP.push_back(tmpList.back());
    // }
  }

  return PDFP;
}

void checkErrors(CollectivesOrder &collectivesOrder, SmallVector<ErrorInfo> &errorInfos, uint64_t numRanks) {
  for (SmallVector<Operation*> &bcastOps : collectivesOrder.bcastsWithOrder) {
    if (bcastOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::BcastOp>(bcastOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(bcastOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IbcastOps : collectivesOrder.IbcastsWithOrder) {
    if (IbcastOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::BcastOp>(IbcastOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IbcastOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &reduceOps : collectivesOrder.reducesWithOrder) {
    if (reduceOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ReduceOp>(reduceOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(reduceOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IreduceOps : collectivesOrder.IreducesWithOrder) {
    if (IreduceOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ReduceOp>(IreduceOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IreduceOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &scanOps : collectivesOrder.scansWithOrder) {
    if (scanOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ScanOp>(scanOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(scanOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IscanOps : collectivesOrder.IscansWithOrder) {
    if (IscanOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ScanOp>(IscanOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IscanOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &exscanOps : collectivesOrder.exscansWithOrder) {
    if (exscanOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ExscanOp>(exscanOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(exscanOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IexscanOps : collectivesOrder.IexscansWithOrder) {
    if (IexscanOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ExscanOp>(IexscanOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IexscanOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &allreduceOps : collectivesOrder.allreducesWithOrder) {
    if (allreduceOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::AllreduceOp>(allreduceOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(allreduceOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IallreduceOps : collectivesOrder.IallreducesWithOrder) {
    if (IallreduceOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::AllreduceOp>(IallreduceOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IallreduceOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &barrierOps : collectivesOrder.barriersWithOrder) {
    if (barrierOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::BarrierOp>(barrierOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(barrierOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IbarrierOps : collectivesOrder.IbarriersWithOrder) {
    if (IbarrierOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::BarrierOp>(IbarrierOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IbarrierOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &scatterOps : collectivesOrder.scattersWithOrder) {
    if (scatterOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ScatterOp>(scatterOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(scatterOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IscatterOps : collectivesOrder.IscattersWithOrder) {
    if (IscatterOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ScatterOp>(IscatterOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IscatterOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &gatherOps : collectivesOrder.gathersWithOrder) {
    if (gatherOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::GatherOp>(gatherOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(gatherOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IgatherOps : collectivesOrder.IgathersWithOrder) {
    if (IgatherOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::GatherOp>(IgatherOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IgatherOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &allgatherOps : collectivesOrder.allgathersWithOrder) {
    if (allgatherOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::AllgatherOp>(allgatherOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(allgatherOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IallgatherOps : collectivesOrder.IallgathersWithOrder) {
    if (IallgatherOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::AllgatherOp>(IallgatherOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IallgatherOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &alltoallOps : collectivesOrder.alltoallsWithOrder) {
    if (alltoallOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::AlltoallOp>(alltoallOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(alltoallOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IalltoallOps : collectivesOrder.IalltoallsWithOrder) {
    if (IalltoallOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::AlltoallOp>(IalltoallOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IalltoallOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &reduceScatterOps : collectivesOrder.reduceScattersWithOrder) {
    if (reduceScatterOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ReduceScatterOp>(reduceScatterOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(reduceScatterOps, PDFP);
    }
  }
  for (SmallVector<Operation*> &IreduceScatterOps : collectivesOrder.IreduceScattersWithOrder) {
    if (IreduceScatterOps.empty()) {
      continue;
    }
    SmallVector<Operation*> PDFP = getPDFP<spmd::ReduceScatterOp>(IreduceScatterOps, numRanks);
    if (PDFP.size() > 0) {
      errorInfos.emplace_back(IreduceScatterOps, PDFP);
    }
  }
}

SmallVector<Value> getComms(Operation *mainOpr){
  SmallVector<Value> comms;
  mainOpr->walk([&](Operation *opr) {
    if (isa<spmd::CommWorldOp>(opr) || isa<spmd::CommSplitOp>(opr) || isa<spmd::CommSplitStridedOp>(opr)) {
      comms.push_back(opr->getResult(0));
    }
  });
  return comms;
}

// assume that all comm worlds are of same size and proper rank management is done by user
void unifyCommWorlds(SmallVector<Value> &comms) {
  Value firstCommWorld;
  bool firstCommWorldFound = false;
  for (Value comm : comms) {
    if (isa<spmd::CommWorldOp>(comm.getDefiningOp())) {
      if (firstCommWorldFound == false) {
        firstCommWorldFound = true;
        firstCommWorld = comm;
      }
      else {
        comm.replaceAllUsesWith(firstCommWorld);
      }
    }
  }
}

struct CheckCollectives : impl::CheckCollectivesBase<CheckCollectives> {
  using CheckCollectivesBase::CheckCollectivesBase;
  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    Operation *mainOpr = moduleOp.lookupSymbol("main");  
    if (mainOpr == NULL) {
      LLVM_DEBUG(DBGS() << "Pass failed since no main func exists\n");
      signalPassFailure();
      return;
    }
    OpBuilder opBuilder(moduleOp);

    SmallVector<ErrorInfo> errorInfos;
    SmallVector<Value> comms = getComms(mainOpr);
    unifyCommWorlds(comms);
    for (Value &comm : comms) {
      CollectivesOrder collectivesOrder;
      size_t executionOrderCounter = 0;
      iterateForCollectives(mainOpr->getRegion(0), collectivesOrder, executionOrderCounter, comm);
      checkErrors(collectivesOrder, errorInfos, numRanks);
    }


    // mainOpr->walk([&](spmd::BcastOp bcastOp) {
    //   bcasts.push_back(bcastOp);
    //   if (iscallOp->getAttrOfType<BoolAttr>(StringRef("isColl"))) {
    //     argErrorGiven = checkForArgErrorColl(callOp, argErrorInfo);
    //     return;
    //   }
    // });

    // mainOpr->walk<WalkOrder::PreOrder>([&](Operation *opr) {
    //   checkMultiValuedness(opr);
    // });
    printf("\n\n--------------------------------------------------------------------------------------------------------------\n");
    printf("Static Verification of Collective Communication:");
    if (errorInfos.size() > 0) {
      printf("\n--------------------------------------------------------------------------------------------------------------\n\n");
      for (auto errorInfo : errorInfos) {
        for (size_t i = 0; i < errorInfo.conflictOprs.size(); i++) {
          errorInfo.conflictOprs[i]->emitWarning(errorInfo.conflictOprs[i]->getName().stripDialect().str() +  
              " operation/call may not called by all processes in communicator/team (Call Ordering Error)");
          if ((i+1) < errorInfo.conflictOprs.size()) {
            printf("\n\nand\n\n");
          }
        }
        printf("\n----------------\n");
        printf("\nProbably due to the conditionals:");
        printf("\n--------\n");
        for (size_t i = 0; i < errorInfo.causingOprs.size(); i++) {
          errorInfo.causingOprs[i]->getLoc().print(llvm::outs());
          if ((i+1) < errorInfo.causingOprs.size()) {
            printf("\n\nand\n\n");
          }
        }
        printf("\n--------------------------------------------------------------------------------------------------------------\n\n");
      }
      printf("\n\n");
    } else {
      printf("\n\n--------------------------------------------------------------------------------------------------------------\n");
      printf("No Colletive Communication Error Found\n");
      printf("--------------------------------------------------------------------------------------------------------------\n");
      printf("\n\n");
    }
  }
};

} // namespace
} // namespace mlir::spmd
