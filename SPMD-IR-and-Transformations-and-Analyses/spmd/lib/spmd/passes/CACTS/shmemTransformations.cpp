//===- shmemTransformations.cpp - Convert shmem api calls to spmd dialect - Source -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This defines functions for converting shmem func call operations to the spmd dialect
//
//===----------------------------------------------------------------------===//

#include "shmemTransformations.h"

namespace mlir::spmd {
Value getNewReduceOpSHMEM(Value reduceOpArg, IRMapping& valueMapping, int modelGroup, 
    bool reduceOpGiven = false, std::string reduceOp = "", Operation *currentCallOpr = nullptr){
  Value newReduceOp;
  static bool sumCreated = false;
  static Value sumReduceOp;
  if (reduceOpGiven) {
    if (reduceOp == "sum") {
      if (sumCreated) {
        return sumReduceOp;
      }
      else {
        OpBuilder opBuilder(currentCallOpr);
        func::FuncOp funcOp = currentCallOpr->getParentOfType<func::FuncOp>();
        opBuilder.setInsertionPointToStart(&(funcOp.getBody().front()));
        newReduceOp = opBuilder.create<spmd::ConstReduceOpOp>(funcOp->getLoc(), StringRef("SUM"), modelGroup).getResult();
        sumCreated = true;
        sumReduceOp = newReduceOp;
      }
    }
    else {
       llvm_unreachable("\nNot implemented case of explicit reduceOp\n");
    }
  }
  else if (valueMapping.contains(reduceOpArg)) {
    newReduceOp = valueMapping.lookup(reduceOpArg);
  } 
  else {
    llvm_unreachable("\nNot implemented case of explicit reduceOp\n");
  }
  return newReduceOp;
}

Value getNewDatatypeSHMEM(Value datatypeArg, IRMapping& valueMapping, int modelGroup, 
    bool datatypeGiven = false, std::string datatype = "", Operation *currentCallOpr = nullptr){
  Value newDatatype;
  static bool intCreated = false;
  static Value intDatatype;
  static bool byteCreated = false;
  static Value byteDatatype;
  if (datatypeGiven) {
    if (datatype == "int") {
      if (intCreated) {
        return intDatatype;
      }
      else {
        OpBuilder opBuilder(currentCallOpr);
        func::FuncOp funcOp = currentCallOpr->getParentOfType<func::FuncOp>();
        opBuilder.setInsertionPointToStart(&(funcOp.getBody().front()));
        newDatatype = opBuilder.create<spmd::ConstDatatypeOp>(funcOp->getLoc(), opBuilder.getI32Type(), modelGroup).getResult();
        intCreated = true;
        intDatatype = newDatatype;
      }
    }
    else if (datatype == "byte") {
      if (byteCreated) {
        return byteDatatype;
      }
      else {
        OpBuilder opBuilder(currentCallOpr);
        func::FuncOp funcOp = currentCallOpr->getParentOfType<func::FuncOp>();
        opBuilder.setInsertionPointToStart(&(funcOp.getBody().front()));
        newDatatype = opBuilder.create<spmd::ConstDatatypeOp>(funcOp->getLoc(), opBuilder.getI8Type(), modelGroup).getResult();
        byteCreated = true;
        byteDatatype = newDatatype;
      }
    }
    else {
       llvm_unreachable("\nNot implemented case of explicit datatype\n");
    }
  }
  else if (valueMapping.contains(datatypeArg)) {
    newDatatype = valueMapping.lookup(datatypeArg);
  } 
  else {
    llvm_unreachable("\nNot implemented case of datatype replacement\n");
  }
  return newDatatype;
}

Value getNewCommSHMEM(Value commArg, IRMapping& valueMapping, int modelGroup,
    bool implicitWorld = false, Operation *currentCallOpr = nullptr){
  Value newComm;
  static bool worldCommCreated = false;
  static Value worldComm;
  if (implicitWorld) {
    if (worldCommCreated) {
      return worldComm;
    }
    else {
      OpBuilder opBuilder(currentCallOpr);
      func::FuncOp funcOp = currentCallOpr->getParentOfType<func::FuncOp>();
      opBuilder.setInsertionPointToStart(&(funcOp.getBody().front()));
      newComm = opBuilder.create<spmd::CommWorldOp>(funcOp->getLoc(), modelGroup).getResult();
      worldCommCreated = true;
      worldComm = newComm;
    }
  }
  else if (memref::LoadOp loadOp = dyn_cast<memref::LoadOp>(commArg.getDefiningOp())) {
    commArg = loadOp->getOperand(0);
    if (valueMapping.contains(commArg)) {
      newComm = valueMapping.lookup(commArg);
    } 
    else if (memref::GetGlobalOp getGlobalOp = dyn_cast<memref::GetGlobalOp>(loadOp.getMemref().getDefiningOp())) {
      OpBuilder opBuilder(getGlobalOp);
      if (getGlobalOp.getName().equals(StringRef("SHMEM_TEAM_WORLD"))) {
        if (worldCommCreated) {
          newComm = worldComm;
          valueMapping.map(commArg, newComm);
        }
        else {
          func::FuncOp funcOp = getGlobalOp->getParentOfType<func::FuncOp>();
          opBuilder.setInsertionPointToStart(&(funcOp.getBody().front()));
          newComm = opBuilder.create<spmd::CommWorldOp>(funcOp->getLoc(), modelGroup).getResult();
          valueMapping.map(commArg, newComm);
          worldCommCreated = true;
          worldComm = newComm;
        }
      }
      else {
        llvm_unreachable("\nNot implemented case of comm replacement - const comm unknown\n");
      }
    }
    else {
      llvm_unreachable("\nNot implemented case of comm replacement\n");
    }
  }
  else {
    llvm_unreachable("\nNot implemented case of non-constant communicator like commWorld\n");
  }
  return newComm;
}

// Function to replace all uses of 'oldValue' that follow 'targetUser' with 'newValue'.
void replaceUsesFollowingUser(mlir::Value oldValue, mlir::Operation *targetUser, mlir::Value newValue) {
  // Ensure the target user is indeed a user of the old value.
  bool targetUserFound = false;

  // Iterate over all uses of the old value.
  for (auto &use : oldValue.getUses()) {
    // Check if we have found the target user.
    if (use.getOwner() == targetUser) {
      targetUserFound = true;
    }

    // If the target user has been found, replace subsequent uses.
    if (targetUserFound) {
      // Perform the replacement.
      use.set(newValue);
    }
  }
}

// valueMapping stores already converted and erased Ops values, to reuse them in future conversion of other Ops
void convertApiCallSHMEM(func::CallOp callOp, int modelGroup) {
  OpBuilder opBuilder(callOp);
  Location loc = callOp->getLoc();
  StringRef calleeStrRef= callOp.getCallee();

  static IRMapping valueMapping;

  if (calleeStrRef.equals(StringRef("shmem_init"))) {
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::InitOp>(loc, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_finalize"))) {
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::FinalizeOp>(loc, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_my_pe"))) {
    Value oldRank = callOp.getResult(0);
    Value newComm = getNewCommSHMEM(Value(), valueMapping, modelGroup, true, callOp.getOperation());

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newRank = opBuilder.create<spmd::GetRankInCommOp>(loc, newComm, modelGroup).getResult(0);
    oldRank.replaceAllUsesWith(newRank);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_team_my_pe"))) {
    Value oldRank = callOp.getResult(0);
    Value commArg = callOp->getOperand(0);
    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newRank = opBuilder.create<spmd::GetRankInCommOp>(loc, newComm, modelGroup).getResult(0);
    oldRank.replaceAllUsesWith(newRank);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_n_pes"))) {
    Value oldSize = callOp.getResult(0);
    Value newComm = getNewCommSHMEM(Value(), valueMapping, modelGroup, true, callOp.getOperation());

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newSize = opBuilder.create<spmd::GetSizeOfCommOp>(loc, newComm, modelGroup).getResult(0);
    oldSize.replaceAllUsesWith(newSize);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_team_n_pes"))) {
    Value oldSize = callOp.getResult(0);
    Value commArg = callOp->getOperand(0);
    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newSize = opBuilder.create<spmd::GetSizeOfCommOp>(loc, newComm, modelGroup).getResult(0);
    oldSize.replaceAllUsesWith(newSize);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_team_sync"))) {
    Value commArg = callOp->getOperand(0);
    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    // ArrayRef<Type> types(spmd::ErrorType::get(callOp.getContext()));
    opBuilder.create<spmd::BarrierOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_sync_all"))) {
    Value newComm = getNewCommSHMEM(Value(), valueMapping, modelGroup, true, callOp.getOperation());
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    // ArrayRef<Type> types(spmd::ErrorType::get(callOp.getContext()));
    opBuilder.create<spmd::BarrierOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_int_broadcast"))) {
    Value commArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value sendBufArg = callOp->getOperand(2);
    Value countArg = callOp->getOperand(3);
    Value rootRankArg = callOp->getOperand(4);

    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeSHMEM(Value(), valueMapping, modelGroup, true, "int", callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::BcastOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
       newDatatype, rootRankArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_broadcastmem"))) {
    Value commArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value sendBufArg = callOp->getOperand(2);
    Value countArg = callOp->getOperand(3);
    Value rootRankArg = callOp->getOperand(4);

    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeSHMEM(Value(), valueMapping, modelGroup, true, "byte", callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::BcastOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
       newDatatype, rootRankArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_int_sum_reduce"))) {
    Value commArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value sendBufArg = callOp->getOperand(2);
    Value countArg = callOp->getOperand(3);

    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeSHMEM(Value(), valueMapping, modelGroup, true, "int", callOp.getOperation());
    Value newReduceOp = getNewReduceOpSHMEM(Value(), valueMapping, modelGroup, true, "sum", callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::AllreduceOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       countArg, newDatatype, newReduceOp, Value(),  /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_int_alltoall"))) {
    Value commArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value sendBufArg = callOp->getOperand(2);
    Value countArg = callOp->getOperand(3);

    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeSHMEM(Value(), valueMapping, modelGroup, true, "int", callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::AlltoallOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, countArg, newDatatype,
       recvBufArg, countArg, newDatatype, Value(),  /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_int_collect")) || calleeStrRef.equals(StringRef("shmem_int_fcollect"))) {
    Value commArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value sendBufArg = callOp->getOperand(2);
    Value countArg = callOp->getOperand(3);

    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeSHMEM(Value(), valueMapping, modelGroup, true, "int", callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::AllgatherOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, countArg, newDatatype,
       recvBufArg, countArg, newDatatype, Value(),  /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_malloc"))) {
    Value sizeArg = callOp->getOperand(0);
    Value ptr = callOp->getResult(0);
    Value newComm = getNewCommSHMEM(Value(), valueMapping, modelGroup, true, callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newPtr = opBuilder.create<spmd::MallocOp>(loc, ptr.getType(), opBuilder.getType<spmd::ErrorType>(), newComm, sizeArg, modelGroup).getResult(0);
    ptr.replaceAllUsesWith(newPtr);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_realloc"))) {
    Value ptrArg = callOp->getOperand(0);
    Value sizeArg = callOp->getOperand(1);
    Value newComm = getNewCommSHMEM(Value(), valueMapping, modelGroup, true, callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    auto newOp = opBuilder.create<spmd::ReallocOp>(loc, ptrArg.getType(), opBuilder.getType<spmd::ErrorType>(), newComm, ptrArg, sizeArg, modelGroup);
    Value ptr = newOp->getResult(0);
    replaceUsesFollowingUser(ptrArg, newOp.getOperation(), ptr);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_free"))) {
    Value ptrArg = callOp->getOperand(0);
    Value newComm = getNewCommSHMEM(Value(), valueMapping, modelGroup, true, callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::FreeOp>(loc, opBuilder.getType<spmd::ErrorType>(), newComm, ptrArg, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_team_split_strided"))) {
    Value parentCommArg = callOp->getOperand(0);
    Value startArg = callOp->getOperand(1);
    Value strideArg = callOp->getOperand(2);
    Value sizeArg = callOp->getOperand(3);
    Value configArg = callOp->getOperand(4);
    // Value configMaskArg = callOp->getOperand(5);
    Value newCommArg = callOp->getOperand(6);

    if (isa<polygeist::Pointer2MemrefOp>(configArg.getDefiningOp()) && 
        isa<LLVM::ZeroOp>(configArg.getDefiningOp()->getOperand(0).getDefiningOp())) {
      configArg = Value();
    }
    else {
      llvm_unreachable("\nNot implemented case of configArg replacement\n");
    }

    if (memref::CastOp castOp = dyn_cast<memref::CastOp>(newCommArg.getDefiningOp())) {
      newCommArg = castOp->getOperand(0);
    }
    else {
      llvm_unreachable("\nNot implemented case of non-constant communicator like commWorld\n");
    }

    Value newParentComm = getNewCommSHMEM(parentCommArg, valueMapping, modelGroup);
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newNewComm = opBuilder.create<spmd::CommSplitStridedOp>(loc, newParentComm, startArg, strideArg,
        sizeArg, configArg, modelGroup).getResult(0);
    valueMapping.map(newCommArg, newNewComm);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("shmem_team_destroy"))) {
    Value commArg = callOp->getOperand(0);
    Value newComm = getNewCommSHMEM(commArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::CommDestroyOp>(loc, newComm, modelGroup);
    callOp->erase();
  }
}

void deleteApiCalleesSHMEM(ModuleOp moduleOp) {
  SmallVector<StringRef> mpiCallees {"shmem_init", "shmem_finalize", "shmem_team_n_pes", "shmem_n_pes", "shmem_my_pe",
      "shmem_team_my_pe", "shmem_team_sync", "shmem_sync_all", "shmem_int_broadcast", "shmem_broadcastmem", "shmem_int_sum_reduce", "shmem_team_destroy",
      "shmem_int_alltoall", "shmem_int_collect", "shmem_int_fcollect", "shmem_team_split_strided", "shmem_alloc", "shmem_realloc", "shmem_free"};
  for (StringRef str : mpiCallees) {
    if (Operation *opr = moduleOp.lookupSymbol(str)) {
      opr->erase();
    }
  }
}
} // namespace mlir::spmd