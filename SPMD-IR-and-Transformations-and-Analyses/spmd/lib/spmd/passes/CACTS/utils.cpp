//===- utils.h - CACTS related utilities - Source -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This implements miscellaneous functionality  useful for the CACTS pass
// and related components that do not fit into one component. 
// Include several headers useful for multiple components.
//
//===----------------------------------------------------------------------===//

#include "utils.h"

namespace mlir::spmd {

int getIndex(Operation *opr) {
  if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(opr)) {
    if (IntegerAttr intAttr = constantOp->getAttrOfType<IntegerAttr>(StringRef("value"))) {
      return intAttr.getInt();
    }
    else {
      llvm_unreachable("\nNot implemented case of replacing memrefs by values\n");
    }
  }
  else {
    //accessed memrefs are statically not derivable => replacement not possible
    llvm_unreachable("\nNot implemented case of replacing memrefs by values\n");
  }
}

// one of vectors need to be traversed reversed
bool sameIndices(SmallVector<int> &memrefSubViewIndices, SmallVector<int> &loadIndices) {
  size_t size1 = memrefSubViewIndices.size();
  size_t size2 = loadIndices.size();
  if (size1 != size2) {
    return false;
  }
  if (size2 == 0) {
    return true;
  }
  int j = size2-1;
  for (size_t i=0; i<size1;i++) {
    if (memrefSubViewIndices[i] != loadIndices[j]){
      return false;
    }
    j--;
  }
  return true;
}


void replaceMemrefByValue(Value orginalArg, Value value) {
  Operation *definingOpr = orginalArg.getDefiningOp();
  bool indicesGiven = false;
  SmallVector<int> memrefSubViewIndices;
  Value memref;
  if (isa<memref::CastOp>(definingOpr)) {
    memref = definingOpr->getOperand(0);
  }
  else if (auto p2mOp = dyn_cast<polygeist::Pointer2MemrefOp>(definingOpr)) {
    if (auto m2pOp = dyn_cast<polygeist::Memref2PointerOp>(p2mOp.getOperand().getDefiningOp())){
      memref = m2pOp->getOperand(0);
    }
    else {
      llvm_unreachable("\nNot implemented case of replacing memrefs by values\n");
    }
    memref = definingOpr->getOperand(0);
  }
  else if (isa<polygeist::SubIndexOp>(definingOpr)) {
    indicesGiven = true;
    memrefSubViewIndices.push_back(getIndex(definingOpr->getOperand(1).getDefiningOp()));
    while (Operation *upperDefiningOpr = definingOpr->getOperand(0).getDefiningOp()) {
      if (isa<polygeist::SubIndexOp>(upperDefiningOpr) == false){
        definingOpr = upperDefiningOpr;
        break;
      }
      memrefSubViewIndices.push_back(getIndex(upperDefiningOpr->getOperand(1).getDefiningOp()));
      definingOpr = upperDefiningOpr;
    }
    if (isa<memref::LoadOp>(definingOpr) == false) {
      llvm_unreachable("\nNot implemented case of replacing memrefs by values\n");
    }
    memref = definingOpr->getResult(0);
  }
  else {
    llvm_unreachable("\nNot implemented case of replacing memrefs by values\n");
  }


  for (auto *user : memref.getUsers()) {
    // user->dump();
    // user->getLoc().dump();
    if (auto loadOp = dyn_cast<memref::LoadOp>(user)) {
      if (indicesGiven) {
        SmallVector<int> loadIndices;
        auto indexOperands = loadOp.getIndices();
        for (auto index : indexOperands) {
          loadIndices.push_back(getIndex(index.getDefiningOp()));
        }
        if (sameIndices(memrefSubViewIndices, loadIndices)) {
          Value result = loadOp.getResult();
          result.replaceAllUsesWith(value);
          // loadOp->erase();
        }
      }
      else {
        Value result = loadOp.getResult();
        result.replaceAllUsesWith(value);
        // loadOp->erase();
      }
    }
    // case for unitialized array. Ignore it, as it will be deleted anyways if the memref is not read anymore after this store
    // todo: we could ignore any storeOp except the undefOp storing as it this would be regarded as best practice
    else if (isa<memref::StoreOp>(user) && isa<LLVM::UndefOp>(user->getOperand(0).getDefiningOp())) { 
      // user->erase();
    }
    else if (isa<memref::CastOp>(user) || isa<polygeist::SubIndexOp>(user)) {
      for (auto user2 : user->getResult(0).getUsers()){
        if (auto callOp = dyn_cast<func::CallOp>(user2)) {
           // case of an indirect user that is a non mpi function call, we dont know what happens over there
          // if the function is statically available we should continue the replacement there, if its a statically 
          //unavailable function we should put the value back into a memref and use this for this user
          if (callOp.getCallee().starts_with(StringRef("MPI_")) || callOp.getCallee().starts_with(StringRef("shmem_")) || callOp.getCallee().starts_with(StringRef("nccl"))) {
            // will be handled during mpi to spmd transformation later in this procedure
          }
          else {
            llvm_unreachable("\nNot implemented case of replacing memrefs by values\n"); 
          }
        }
        else if (isa<polygeist::SubIndexOp>(user2)) {
          //do nothing
        }
        else {
          llvm_unreachable("\nNot implemented case of replacing memrefs by values\n"); 
        }
      }
    }
    //both before and after e.g. a getRankOp it is bad practice to store something else in memref, but it can be done in theory
    // thus we ignore it
    else if (isa<memref::StoreOp>(user)) {
      //do nothing
    }
    else {
      llvm_unreachable("\nNot implemented case of replacing memrefs by values\n");
    }
  }
}
} // namespace mlir::spmd