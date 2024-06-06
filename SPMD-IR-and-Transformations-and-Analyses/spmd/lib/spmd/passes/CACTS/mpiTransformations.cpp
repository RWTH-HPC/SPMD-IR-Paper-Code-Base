//===- mpiTransformations.cpp - Convert mpi api calls to spmd dialect - Source -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This defines functions for converting mpi func call operations to the spmd dialect
//
//===----------------------------------------------------------------------===//

#include "mpiTransformations.h"

namespace mlir::spmd {
Value getNewReduceOpMPI(Value reduceOpArg, IRMapping& valueMapping, int modelGroup){
  Value newReduceOp;
  if (valueMapping.contains(reduceOpArg)) {
    newReduceOp = valueMapping.lookup(reduceOpArg);
  } 
  else if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(reduceOpArg.getDefiningOp())) {
    const int MPI_SUM = 1476395011;
    OpBuilder opBuilder(constantOp);
    if(IntegerAttr integerAttr = dyn_cast<IntegerAttr>(constantOp.getValueAttr())) {
      if (integerAttr.getInt() == MPI_SUM) {
        opBuilder.setInsertionPoint(constantOp.getOperation());
        newReduceOp = opBuilder.create<spmd::ConstReduceOpOp>(constantOp->getLoc(), StringRef("SUM"), modelGroup).getResult();
        valueMapping.map(reduceOpArg, newReduceOp);
      }
      else {
        llvm_unreachable("\nNot implemented case of reduceOp replacement - const reduceOp unknown\n");
      }
    }
    else {
      llvm_unreachable("\nNot implemented case of reduceOp replacement\n");
    }
  }
  else {
    llvm_unreachable("\nNot implemented case of non-constant communicator like commWorld\n");
  }
  return newReduceOp;
}

Value getNewDatatypeMPI(Value datatypeArg, IRMapping& valueMapping, int modelGroup){
  Value newDatatype;
  if (valueMapping.contains(datatypeArg)) {
    newDatatype = valueMapping.lookup(datatypeArg);
  } 
  else if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(datatypeArg.getDefiningOp())) {
    const int MPI_INT = 1275069445;
    const int MPI_BYTE = 1275068685;
    OpBuilder opBuilder(constantOp);
    if (IntegerAttr integerAttr = dyn_cast<IntegerAttr>(constantOp.getValueAttr())) {
      if (integerAttr.getInt() == MPI_INT) {
        opBuilder.setInsertionPoint(constantOp.getOperation());
        newDatatype = opBuilder.create<spmd::ConstDatatypeOp>(constantOp->getLoc(), opBuilder.getI32Type(), modelGroup).getResult();
        valueMapping.map(datatypeArg, newDatatype);
      }
      else if (integerAttr.getInt() == MPI_BYTE) {
        opBuilder.setInsertionPoint(constantOp.getOperation());
        newDatatype = opBuilder.create<spmd::ConstDatatypeOp>(constantOp->getLoc(), opBuilder.getI8Type(), modelGroup).getResult();
        valueMapping.map(datatypeArg, newDatatype);
      }
      else {
        llvm_unreachable("\nNot implemented case of datatype replacement - const datatype unknown\n");
      }
    }
    else {
      llvm_unreachable("\nNot implemented case of datatype replacement\n");
    }
  }
  else {
    llvm_unreachable("\nNot implemented case of non-constant communicator like commWorld\n");
  }
  return newDatatype;
}

Value getNewCommMPI(Value commArg, IRMapping& valueMapping, int modelGroup, bool implicitWorld = false, Operation* currentCallOpr = nullptr){
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
      return worldComm;
    }
  }

  //needed for convenience, e.g. the call to this function in case of mpi_reduce etc. otherwise this needs to be done there before calling this func.  
  if (memref::LoadOp loadOp = dyn_cast<memref::LoadOp>(commArg.getDefiningOp())) {
    commArg = loadOp.getMemref();
  }

  if (valueMapping.contains(commArg)) {
    newComm = valueMapping.lookup(commArg);
  } 
  else if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(commArg.getDefiningOp())) {
    const int MPI_COMM_WORLD = 1140850688;
    OpBuilder opBuilder(constantOp);
    if (IntegerAttr integerAttr = dyn_cast<IntegerAttr>(constantOp.getValueAttr())) {
      if (integerAttr.getInt() == MPI_COMM_WORLD) {
        opBuilder.setInsertionPoint(constantOp.getOperation());
        newComm = opBuilder.create<spmd::CommWorldOp>(constantOp->getLoc(), modelGroup).getResult();
        valueMapping.map(commArg, newComm);
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

Value getNewStatusesMPI(Value statusMemref, IRMapping& valueMapping, bool isSingle, Value reqMemref = Value()) {
  Value newStatuses;
  OpBuilder opBuilder(statusMemref.getDefiningOp());
  auto loc = statusMemref.getLoc();
  if (valueMapping.contains(statusMemref)) {
    newStatuses = valueMapping.lookup(statusMemref);
  } 
  if (isSingle){
    // Define the memref type that can store 1 element of spmd::StatusType
    auto memrefType = MemRefType::get({1}, opBuilder.getType<spmd::StatusType>());
    // Create the AllocaOp to allocate the memref
    newStatuses = opBuilder.create<memref::AllocaOp>(loc, memrefType).getResult();

    valueMapping.map(statusMemref, newStatuses);
  }
  else {
    // Define the memref type that can store arbitrarily many element sof spmd::StatusType
    auto memrefType = MemRefType::get({reqMemref.getType().cast<MemRefType>().getShape()[0]}, opBuilder.getType<spmd::StatusType>());
    // Create the AllocaOp to allocate the memref
    newStatuses = opBuilder.create<memref::AllocaOp>(loc, memrefType).getResult();

    valueMapping.map(statusMemref, newStatuses);
  }
  return newStatuses;
}

Value getNewReqMPI(Value reqArgMemref, IRMapping &valueMapping, int modelGroup){
  Value newReq;

  if (valueMapping.contains(reqArgMemref)) {
    newReq = valueMapping.lookup(reqArgMemref);
  } 
  else {
    llvm_unreachable("\nNot implemented case of getting req\n");
  }

  return newReq;
}

Value getMemref(Value &arg, Value *idx) {
  Value argMemref;
  if (auto castOp = dyn_cast<memref::CastOp>(arg.getDefiningOp())) {
    argMemref = castOp->getOperand(0);
  }
  else if (auto subIdxOp = dyn_cast<polygeist::SubIndexOp>(arg.getDefiningOp())) {
    argMemref = subIdxOp->getOperand(0);
    *idx = subIdxOp->getOperand(1);
  }
  else {
    llvm_unreachable("\nNot implemented case of getMemref\n");
  }
  return argMemref;
}

void setNewReqMemref(IRMapping &valueMapping, Value idx, Value reqArgMemref, Value newReq, Operation *newOpr) {
  Value newReqMemref;
  Operation *oldMemrefOpr = reqArgMemref.getDefiningOp();
  OpBuilder opBuilder(oldMemrefOpr);
  if (valueMapping.contains(reqArgMemref)) {
    newReqMemref = valueMapping.lookup(reqArgMemref);
  } 
  else {
    auto loc = oldMemrefOpr->getLoc();
    opBuilder.setInsertionPoint(oldMemrefOpr);
    // Define the memref type that can store 1 element of spmd::ReqType
    auto memrefType = MemRefType::get({reqArgMemref.getType().cast<MemRefType>().getShape()[0]}, opBuilder.getType<spmd::ReqType>());
    // Create the AllocaOp to allocate the memref
    auto allocaOp = opBuilder.create<memref::AllocaOp>(loc, memrefType);
    newReqMemref = allocaOp.getResult();
    valueMapping.map(reqArgMemref, newReqMemref);
  }
  opBuilder.setInsertionPointAfter(newOpr);
  auto loc2 = newOpr->getLoc();
  // Store the new Req value into the allocated memref
  if (!idx){
    idx = opBuilder.create<arith::ConstantIndexOp>(loc2, 0).getResult();
    opBuilder.setInsertionPointAfterValue(idx);
  }
  opBuilder.create<memref::StoreOp>(loc2, newReq, newReqMemref, idx);
}

Value GetNewReqMemref(IRMapping &valueMapping, Value reqArgMemref, Value newReq, Operation *newOpr) {
  Value newReqMemref;
  if (valueMapping.contains(reqArgMemref)) {
    newReqMemref = valueMapping.lookup(reqArgMemref);
  } 
  else {
    llvm_unreachable("\nNot implemented case\n");
  }
  return newReqMemref;
}

void createWaitAll(Value reqArgMemref, Value req1, Value req2, mlir::Location loc, int modelGroup) {
  OpBuilder opBuilder(reqArgMemref.getDefiningOp());
  auto reqArgMemrefLoc = reqArgMemref.getLoc(); 
  opBuilder.setInsertionPoint(reqArgMemref.getDefiningOp());
  // Define the memref type that can store 2 elements of spmd::ReqType
  auto memrefType = MemRefType::get({2}, opBuilder.getType<spmd::ReqType>());

  // Create the AllocaOp to allocate the memref
  auto allocaOp = opBuilder.create<memref::AllocaOp>(reqArgMemrefLoc, memrefType);
  Value newReqMemref = allocaOp.getResult();

  auto zeroIndex = opBuilder.create<arith::ConstantIndexOp>(loc, 0).getResult();
  auto oneIndex = opBuilder.create<arith::ConstantIndexOp>(loc, 1).getResult();

  opBuilder.setInsertionPointAfterValue(req2);
  opBuilder.create<memref::StoreOp>(loc, req2, allocaOp, oneIndex);
  opBuilder.create<memref::StoreOp>(loc, req1, allocaOp, zeroIndex);


  for (Operation *user : reqArgMemref.getUsers()) {
    if (auto castOp = dyn_cast<memref::CastOp>(user)){
      for(Operation *user2 : castOp.getResult().getUsers()) {
        if (auto callOp2 = dyn_cast<func::CallOp>(user2)) {
          StringRef calleeStrRef2 = callOp2.getCallee();
          if (calleeStrRef2.equals(StringRef("MPI_Wait"))) {
            // Value statusArg = callOp->getOperand(1);
            opBuilder.setInsertionPoint(callOp2.getOperation());

            // Todo: here now 2 instead of 1 status is generated, this needs to be handled if the status is used in the program
            // Define the memref type that can store 2 elements of spmd::StatusType
            auto memrefType = MemRefType::get({2}, opBuilder.getType<spmd::StatusType>());
            // Create the AllocaOp to allocate the memref
            Value newStatuses = opBuilder.create<memref::AllocaOp>(loc, memrefType).getResult();
            Value countTwo = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(2)).getResult();
            opBuilder.create<spmd::WaitAllOp>(callOp2->getLoc(), opBuilder.getType<spmd::ErrorType>(), countTwo, newReqMemref, newStatuses, modelGroup);
            callOp2->erase();
            // replaceMemrefByValue(statusArg, newStatus);
          }
        }
      } 
    }
  }   
}

// valueMapping stores already converted and erased Ops values, to reuse them in future conversion of other Ops
void convertApiCallMPI(func::CallOp callOp, int modelGroup) {
  OpBuilder opBuilder(callOp);
  Location loc = callOp->getLoc();
  StringRef calleeStrRef = callOp.getCallee();

  static DenseMap<Value, llvm::SmallVector<Value>> reqsMapping;
  static IRMapping valueMapping;

  if (calleeStrRef.equals("MPI_Init")) {
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::InitOp>(loc, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Finalize")) {
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::FinalizeOp>(loc, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Comm_rank")) {
    Value commArg = callOp->getOperand(0);
    Value rankArg = callOp->getOperand(1);
    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newRank = opBuilder.create<spmd::GetRankInCommOp>(loc, newComm, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(rankArg, newRank);
  }
  else if (calleeStrRef.equals("MPI_Comm_size")) {
    Value commArg = callOp->getOperand(0);
    Value sizeArg = callOp->getOperand(1);
    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newSize = opBuilder.create<spmd::GetSizeOfCommOp>(loc, newComm, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(sizeArg, newSize);
  }
  else if (calleeStrRef.equals("MPI_Barrier")) {
    Value commArg = callOp->getOperand(0);
    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::BarrierOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Ibarrier")) {
    Value commArg = callOp->getOperand(0);
    Value reqArg = callOp->getOperand(1);
    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    auto newOp = opBuilder.create<spmd::BarrierOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(),
        newComm, /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Bcast")) {
    Value sendRecvBufArg = callOp->getOperand(0);
    Value countArg = callOp->getOperand(1);
    Value datatypeArg = callOp->getOperand(2);
    Value rootRankArg = callOp->getOperand(3);

    Value commArg = callOp->getOperand(4);
    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    opBuilder.create<spmd::BcastOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendRecvBufArg, sendRecvBufArg, castedCount, newDatatype, rootRankArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Ibcast")) {
    Value sendRecvBufArg = callOp->getOperand(0);
    Value countArg = callOp->getOperand(1);
    Value datatypeArg = callOp->getOperand(2);
    Value rootRankArg = callOp->getOperand(3);
    Value commArg = callOp->getOperand(4);
    Value reqArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    auto newOp = opBuilder.create<spmd::BcastOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendRecvBufArg,
      sendRecvBufArg, castedCount, newDatatype, rootRankArg, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Gather")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value rootRankArg = callOp->getOperand(6);
    Value commArg = callOp->getOperand(7);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    opBuilder.create<spmd::GatherOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, rootRankArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Igather")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value rootRankArg = callOp->getOperand(6);
    Value commArg = callOp->getOperand(7);
    Value reqArg = callOp->getOperand(8);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    auto newOp = opBuilder.create<spmd::GatherOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, rootRankArg, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Allgather")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    opBuilder.create<spmd::AllgatherOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Iallgather")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);
    Value reqArg = callOp->getOperand(7);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    auto newOp = opBuilder.create<spmd::AllgatherOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Alltoall")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    opBuilder.create<spmd::AlltoallOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Ialltoall")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);
    Value reqArg = callOp->getOperand(7);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    auto newOp = opBuilder.create<spmd::AlltoallOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Reduce")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value rootRankArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    opBuilder.create<spmd::ReduceOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, rootRankArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Ireduce")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value rootRankArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);
    Value reqArg = callOp->getOperand(7);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    auto newOp = opBuilder.create<spmd::ReduceOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, rootRankArg, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Allreduce")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    opBuilder.create<spmd::AllreduceOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Iallreduce")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value reqArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    auto newOp = opBuilder.create<spmd::AllreduceOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Scan")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    opBuilder.create<spmd::ScanOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Iscan")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value reqArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    auto newOp = opBuilder.create<spmd::ScanOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Exscan")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    opBuilder.create<spmd::ExscanOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Iexscan")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value reqArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    auto newOp = opBuilder.create<spmd::ExscanOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Scatter")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value rootRankArg = callOp->getOperand(6);
    Value commArg = callOp->getOperand(7);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    opBuilder.create<spmd::ScatterOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, rootRankArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Iscatter")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value recvBufArg = callOp->getOperand(3);
    Value recvCountArg = callOp->getOperand(4);
    Value recvTypeArg = callOp->getOperand(5);
    Value rootRankArg = callOp->getOperand(6);
    Value commArg = callOp->getOperand(7);
    Value reqArg = callOp->getOperand(8);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    auto newOp = opBuilder.create<spmd::ScatterOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, recvBufArg, castedRecvCount, newRecvType, rootRankArg, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Reduce_scatter_block")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    opBuilder.create<spmd::ReduceScatterOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Ireduce_scatter_block")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value reqArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeMPI(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpMPI(reduceOpArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    auto newOp = opBuilder.create<spmd::ReduceScatterOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
       castedCount, newDatatype, newReduceOp, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }

  else if (calleeStrRef.equals("MPI_Sendrecv")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value sendTagArg = callOp->getOperand(4);
    Value recvBufArg = callOp->getOperand(5);
    Value recvCountArg = callOp->getOperand(6);
    Value recvTypeArg = callOp->getOperand(7);
    Value srcRankArg = callOp->getOperand(8);
    Value recvTagArg = callOp->getOperand(9);
    Value commArg = callOp->getOperand(10);
    // Value statusArg = callOp->getOperand(11);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    Value req1 = opBuilder.create<spmd::SendOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, destRankArg, sendTagArg, Value(), /*isBlocking=*/false, /*isBuffered=*/false, modelGroup).getResult(0);
    Value req2 = opBuilder.create<spmd::RecvOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, recvBufArg, castedRecvCount,
       newRecvType, srcRankArg, recvTagArg, Value(), /*isBlocking=*/false, modelGroup).getResult(0);
    // Define the memref type that can store 2 elements of spmd::ReqType
    auto memrefType = MemRefType::get({2}, opBuilder.getType<spmd::ReqType>());
    // Create the AllocaOp to allocate the memref
    auto reqArgMemref = opBuilder.create<memref::AllocaOp>(loc, memrefType).getResult();
    auto zeroIndex = opBuilder.create<arith::ConstantIndexOp>(loc, 0).getResult();
    auto oneIndex = opBuilder.create<arith::ConstantIndexOp>(loc, 1).getResult();
    // Store the values into the allocated memref
    opBuilder.create<memref::StoreOp>(loc, req1, reqArgMemref, zeroIndex);
    opBuilder.create<memref::StoreOp>(loc, req2, reqArgMemref, oneIndex);
    // Todo: here now 2 instead of 1 status is generated, this needs to be handled if the status is used in the program
    // Define the memref type that can store 2 elements of spmd::StatusType
    auto memrefType2 = MemRefType::get({2}, opBuilder.getType<spmd::StatusType>());
    // Create the AllocaOp to allocate the memref
    Value newStatuses = opBuilder.create<memref::AllocaOp>(loc, memrefType2).getResult();
    Value countTwo = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(2)).getResult();
    opBuilder.create<spmd::WaitAllOp>(loc, opBuilder.getType<spmd::ErrorType>(), countTwo, reqArgMemref, newStatuses, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Isendrecv")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value sendTagArg = callOp->getOperand(4);
    Value recvBufArg = callOp->getOperand(5);
    Value recvCountArg = callOp->getOperand(6);
    Value recvTypeArg = callOp->getOperand(7);
    Value srcRankArg = callOp->getOperand(8);
    Value recvTagArg = callOp->getOperand(9);
    Value commArg = callOp->getOperand(10);
    Value reqArg = callOp->getOperand(11);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    Value req1 = opBuilder.create<spmd::SendOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, destRankArg, sendTagArg, Value(), /*isBlocking=*/false, /*isBuffered=*/false, modelGroup).getResult(0);
    Value req2 = opBuilder.create<spmd::RecvOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, recvBufArg, castedRecvCount,
       newRecvType, srcRankArg, recvTagArg, Value(), /*isBlocking=*/false, modelGroup).getResult(0);
    createWaitAll(reqArgMemref, req1, req2, loc, modelGroup);

    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Sendrecv_replace")) {
    Value bufArg = callOp->getOperand(0);
    Value countArg = callOp->getOperand(1);
    Value typeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value sendTagArg = callOp->getOperand(4);
    Value srcRankArg = callOp->getOperand(5);
    Value recvTagArg = callOp->getOperand(6);
    Value commArg = callOp->getOperand(7);
    // Value statusArg = callOp->getOperand(8);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newType = getNewDatatypeMPI(typeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    Value req1 = opBuilder.create<spmd::SendOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, bufArg, castedCount,
       newType, destRankArg, sendTagArg, Value(), /*isBlocking=*/false, /*isBuffered=*/false, modelGroup).getResult(0);
    Value req2 = opBuilder.create<spmd::RecvOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, bufArg, castedCount,
       newType, srcRankArg, recvTagArg, Value(), /*isBlocking=*/false, modelGroup).getResult(0);
    // Define the memref type that can store 2 elements of spmd::ReqType
    auto memrefType = MemRefType::get({2}, opBuilder.getType<spmd::ReqType>());
    // Create the AllocaOp to allocate the memref
    auto reqArgMemref = opBuilder.create<memref::AllocaOp>(loc, memrefType).getResult();
    auto zeroIndex = opBuilder.create<arith::ConstantIndexOp>(loc, 0).getResult();
    auto oneIndex = opBuilder.create<arith::ConstantIndexOp>(loc, 1).getResult();
    // Store the values into the allocated memref
    opBuilder.create<memref::StoreOp>(loc, req1, reqArgMemref, zeroIndex);
    opBuilder.create<memref::StoreOp>(loc, req2, reqArgMemref, oneIndex);
    // Todo: here now 2 instead of 1 status is generated, this needs to be handled if the status is used in the program
    // Define the memref type that can store 2 elements of spmd::StatusType
    auto memrefType2 = MemRefType::get({2}, opBuilder.getType<spmd::StatusType>());
    // Create the AllocaOp to allocate the memref
    Value newStatuses = opBuilder.create<memref::AllocaOp>(loc, memrefType2).getResult();
    Value countTwo = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(2)).getResult();
    opBuilder.create<spmd::WaitAllOp>(loc, opBuilder.getType<spmd::ErrorType>(), countTwo, reqArgMemref, newStatuses, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Isendrecv_replace")) {
    Value bufArg = callOp->getOperand(0);
    Value countArg = callOp->getOperand(1);
    Value typeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value sendTagArg = callOp->getOperand(4);
    Value srcRankArg = callOp->getOperand(5);
    Value recvTagArg = callOp->getOperand(6);
    Value commArg = callOp->getOperand(7);
    Value reqArg = callOp->getOperand(8);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newType = getNewDatatypeMPI(typeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), countArg).getResult();
    Value req1 = opBuilder.create<spmd::SendOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, bufArg, castedCount,
       newType, destRankArg, sendTagArg, Value(), /*isBlocking=*/false, /*isBuffered=*/false, modelGroup).getResult(0);
    Value req2 = opBuilder.create<spmd::RecvOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, bufArg, castedCount,
       newType, srcRankArg, recvTagArg, Value(), /*isBlocking=*/false, modelGroup).getResult(0);

    createWaitAll(reqArgMemref, req1, req2, loc, modelGroup);

    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Send") || calleeStrRef.equals("MPI_Ssend") || calleeStrRef.equals("MPI_Bsend")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value tagArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);

    bool isBuffered = false;
    if (calleeStrRef.equals("MPI_Bsend")) {
      isBuffered = true;
    }
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    opBuilder.create<spmd::SendOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, destRankArg, tagArg, Value(), /*isBlocking=*/true, isBuffered, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Isend") || calleeStrRef.equals("MPI_Issend") || calleeStrRef.equals("MPI_Ibsend")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value tagArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value reqArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeMPI(sendTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    bool isBuffered = false;
    if (calleeStrRef.equals("MPI_Ibsend")) {
      isBuffered = true;
    }

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedSendCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), sendCountArg).getResult();
    auto newOp = opBuilder.create<spmd::SendOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, castedSendCount,
       newSendType, destRankArg, tagArg, Value(), /*isBlocking=*/false, isBuffered, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Recv")) {
    Value recvBufArg = callOp->getOperand(0);
    Value recvCountArg = callOp->getOperand(1);
    Value recvTypeArg = callOp->getOperand(2);
    Value srcRankArg = callOp->getOperand(3);
    Value tagArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    opBuilder.create<spmd::RecvOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, recvBufArg, castedRecvCount,
       newRecvType, srcRankArg, tagArg, Value(), /*isBlocking=*/true, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Irecv")) {
    Value recvBufArg = callOp->getOperand(0);
    Value recvCountArg = callOp->getOperand(1);
    Value recvTypeArg = callOp->getOperand(2);
    Value srcRankArg = callOp->getOperand(3);
    Value tagArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value reqArg = callOp->getOperand(6);

    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeMPI(recvTypeArg, valueMapping, modelGroup);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value castedRecvCount = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI64Type(), recvCountArg).getResult();
    auto newOp = opBuilder.create<spmd::RecvOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, recvBufArg, castedRecvCount,
       newRecvType, srcRankArg, tagArg, Value(), /*isBlocking=*/false, modelGroup);
    Value newReq = newOp.getResult(0);
    setNewReqMemref(valueMapping, idx, reqArgMemref, newReq, newOp.getOperation());
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Wait")) {
    Value reqArg = callOp->getOperand(0);
    Value statusArg = callOp->getOperand(1);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);
    Value newReqMemref = getNewReqMPI(reqArgMemref, valueMapping, modelGroup);

    Value idx2;
    Value statusMemref = getMemref(statusArg, &idx2);
    Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, true);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value countOne = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(1)).getResult();
    opBuilder.create<spmd::WaitAllOp>(loc, opBuilder.getType<spmd::ErrorType>(), countOne, newReqMemref, newStatuses, modelGroup);
    callOp->erase();
    // replaceMemrefByValue(statusArg, newStatus);
  }
  else if (calleeStrRef.equals("MPI_Waitall")) {
    Value countArg = callOp->getOperand(0);
    Value reqsArg = callOp->getOperand(1);
    Value statusesArg = callOp->getOperand(2);

    Value idx;
    Value reqsArgMemref = getMemref(reqsArg, &idx);
    Value newReqsMemref = getNewReqMPI(reqsArgMemref, valueMapping, modelGroup);
    Value idx2;
    Value statusMemref = getMemref(statusesArg, &idx2);
    Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, false, newReqsMemref);

    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::WaitAllOp>(loc, opBuilder.getType<spmd::ErrorType>(), countArg, newReqsMemref, newStatuses, modelGroup);
    callOp->erase();
    // replaceMemrefByValue(statusArg, newStatus);
  }
  else if (calleeStrRef.equals("MPI_Waitsome")) {
    Value inCountArg = callOp->getOperand(0);
    Value reqsArg = callOp->getOperand(1);
    Value outCountArg = callOp->getOperand(2);
    Value indicesArg = callOp->getOperand(3);
    Value statusesArg = callOp->getOperand(4);

    Value idx;
    Value reqsArgMemref = getMemref(reqsArg, &idx);
    Value newReqsMemref = getNewReqMPI(reqsArgMemref, valueMapping, modelGroup);
    Value idx2;
    Value statusMemref = getMemref(statusesArg, &idx2);
    Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, false, newReqsMemref);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value outCount = opBuilder.create<spmd::WaitSomeOp>(loc, opBuilder.getI32Type(), opBuilder.getType<spmd::ErrorType>(),
        inCountArg, newReqsMemref, indicesArg, newStatuses, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(outCountArg, outCount);
  }
  else if (calleeStrRef.equals("MPI_Waitany")) {
    Value countArg = callOp->getOperand(0);
    Value reqsArg = callOp->getOperand(1);
    Value idxArg = callOp->getOperand(2);
    Value statusArg = callOp->getOperand(3);

    Value idx;
    Value reqsArgMemref = getMemref(reqsArg, &idx);
    Value newReqsMemref = getNewReqMPI(reqsArgMemref, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    auto newOp = opBuilder.create<spmd::WaitAnyOp>(loc, opBuilder.getI32Type(), opBuilder.getType<spmd::StatusType>(),
        opBuilder.getType<spmd::ErrorType>(), countArg, newReqsMemref, modelGroup);
    Value index = newOp.getResult(0);
    Value status = newOp.getResult(1);
    callOp->erase();
    replaceMemrefByValue(idxArg, index);
    replaceMemrefByValue(statusArg, status);
  }
  else if (calleeStrRef.equals("MPI_Comm_split")) {
    Value parentCommArg = callOp->getOperand(0);
    Value colorArg = callOp->getOperand(1);
    Value keyArg = callOp->getOperand(2);
    Value newCommArg = callOp->getOperand(3);

    if (memref::CastOp castOp = dyn_cast<memref::CastOp>(newCommArg.getDefiningOp())) {
      newCommArg = castOp->getOperand(0);
    }
    else {
      llvm_unreachable("\nNot implemented case of comm split replacement\n");
    }
    
    if (isa<arith::ConstantOp>(colorArg.getDefiningOp()) && isa<spmd::GetRankInCommOp>(keyArg.getDefiningOp()) && isa<spmd::CommWorldOp>(keyArg.getDefiningOp()->getOperand(0).getDefiningOp())){
      opBuilder.setInsertionPoint(callOp.getOperation());
      Value commWorld = opBuilder.create<spmd::CommWorldOp>(callOp->getLoc(), modelGroup).getResult();
      valueMapping.map(newCommArg, commWorld);
    }
    else {
      Value newParentComm = getNewCommMPI(parentCommArg, valueMapping, modelGroup);
      opBuilder.setInsertionPoint(callOp.getOperation());
      Value newNewComm = opBuilder.create<spmd::CommSplitOp>(loc, newParentComm, colorArg, keyArg, Value(), modelGroup).getResult(0);
      valueMapping.map(newCommArg, newNewComm);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Comm_free")) {
    Value commArg = callOp->getOperand(0);

    if (memref::CastOp castOp = dyn_cast<memref::CastOp>(commArg.getDefiningOp())) {
      commArg = castOp->getOperand(0);
    }
    else {
      llvm_unreachable("\nNot implemented case of comm split replacement\n");
    }
    Value newComm = getNewCommMPI(commArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::CommDestroyOp>(loc, newComm, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals(StringRef("MPI_Alloc_mem"))) {
    Value sizeArg = callOp->getOperand(0);
    // Value infoArg = callOp->getOperand(1);
    Value ptrArg = callOp->getOperand(2);
    Value newComm = getNewCommMPI(Value(), valueMapping, modelGroup, true, callOp.getOperation());

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newPtr = opBuilder.create<spmd::MallocOp>(loc, ptrArg.getType(), opBuilder.getType<spmd::ErrorType>(), newComm, sizeArg, modelGroup).getResult(0);
    ptrArg.replaceAllUsesWith(newPtr);
    callOp->erase();
    // replaceMemrefByValue(ptrArg, newPtr);
  }
  else if (calleeStrRef.equals(StringRef("MPI_Free_mem"))) {
    Value ptrArg = callOp->getOperand(0);
    Value newComm = getNewCommMPI(Value(), valueMapping, modelGroup, true, callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::FreeOp>(loc, opBuilder.getType<spmd::ErrorType>(), newComm, ptrArg, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("MPI_Test")) {
    Value reqArg = callOp->getOperand(0);
    Value flagArg = callOp->getOperand(1);
    Value statusArg = callOp->getOperand(2);
    Value idx;
    Value reqArgMemref = getMemref(reqArg, &idx);
    Value newReqMemref = getNewReqMPI(reqArgMemref, valueMapping, modelGroup);
    Value idx2;
    Value statusMemref = getMemref(statusArg, &idx2);
    Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, true);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value countOne = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(1)).getResult();
    Value newFlag = opBuilder.create<spmd::TestAllOp>(loc, opBuilder.getI1Type(), opBuilder.getType<spmd::ErrorType>(),
        countOne, newReqMemref, newStatuses, modelGroup).getResult(0);
    Value castedFlag = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI32Type(), newFlag).getResult();
    callOp->erase();
    replaceMemrefByValue(flagArg, castedFlag);
  }
  else if (calleeStrRef.equals("MPI_Testall")) {
    Value countArg = callOp->getOperand(0);
    Value reqsArg = callOp->getOperand(1);
    Value flagArg = callOp->getOperand(2);
    Value statusesArg = callOp->getOperand(3);

    Value idx;
    Value reqsArgMemref = getMemref(reqsArg, &idx);
    Value newReqsMemref = getNewReqMPI(reqsArgMemref, valueMapping, modelGroup);
    Value idx2;
    Value statusMemref = getMemref(statusesArg, &idx2);
    Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, false, newReqsMemref);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newFlag = opBuilder.create<spmd::TestAllOp>(loc,  opBuilder.getI1Type(), opBuilder.getType<spmd::ErrorType>(),
        countArg, newReqsMemref, newStatuses, modelGroup).getResult(0);
    Value castedFlag = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI32Type(), newFlag).getResult();
    callOp->erase();
    replaceMemrefByValue(flagArg, castedFlag);
  }
  else if (calleeStrRef.equals("MPI_Testsome")) {
    Value inCountArg = callOp->getOperand(0);
    Value reqsArg = callOp->getOperand(1);
    Value outCountArg = callOp->getOperand(2);
    Value indicesArg = callOp->getOperand(3);
    Value statusesArg = callOp->getOperand(4);

    Value idx;
    Value reqsArgMemref = getMemref(reqsArg, &idx);
    Value newReqsMemref = getNewReqMPI(reqsArgMemref, valueMapping, modelGroup);
    Value idx2;
    Value statusMemref = getMemref(statusesArg, &idx2);
    Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, false, newReqsMemref);

    opBuilder.setInsertionPoint(callOp.getOperation());
    Value outCount = opBuilder.create<spmd::TestSomeOp>(loc, opBuilder.getI32Type(), opBuilder.getType<spmd::ErrorType>(),
        inCountArg, newReqsMemref, indicesArg, newStatuses, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(outCountArg, outCount);
  }
  else if (calleeStrRef.equals("MPI_Testany")) {
    Value countArg = callOp->getOperand(0);
    Value reqsArg = callOp->getOperand(1);
    Value idxArg = callOp->getOperand(2);
    Value flagArg = callOp->getOperand(3);
    Value statusArg = callOp->getOperand(4);

    Value idx;
    Value reqsArgMemref = getMemref(reqsArg, &idx);
    Value newReqsMemref = getNewReqMPI(reqsArgMemref, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    auto newOp = opBuilder.create<spmd::TestAnyOp>(loc, opBuilder.getI32Type(), opBuilder.getI1Type(), opBuilder.getType<spmd::StatusType>(),
        opBuilder.getType<spmd::ErrorType>(), countArg, newReqsMemref, modelGroup);
    Value index = newOp.getResult(0);
    Value flag = newOp.getResult(1);
    Value status = newOp.getResult(2);
    Value castedFlag = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI32Type(), flag).getResult();
    callOp->erase();
    replaceMemrefByValue(idxArg, index);
    replaceMemrefByValue(flagArg, castedFlag);
    replaceMemrefByValue(statusArg, status);
  }
  else if (calleeStrRef.equals("MPI_Request_free")) {
    callOp->erase();
  } 
}


void deleteApiCalleesMPI(ModuleOp moduleOp) {
  SmallVector<StringRef> mpiCallees {"MPI_Init", "MPI_Finalize", "MPI_Comm_size", "MPI_Comm_rank", "MPI_Wait", "MPI_Comm_split", "MPI_Comm_free",
      "MPI_Barrier", "MPI_Ibarrier", "MPI_Bcast", "MPI_Ibcast", "MPI_Reduce", "MPI_Ireduce", "MPI_Reduce_scatter_block", "MPI_Ireduce_scatter_block", "MPI_Allreduce", "MPI_Iallreduce", "MPI_Scatter", "MPI_Iscatter", 
      "MPI_Gather", "MPI_Igather", "MPI_Allgather", "MPI_Iallgather", "MPI_Alltoall", "MPI_Ialltoall", "MPI_Sendrecv", "MPI_Isendrecv", "MPI_Sendrecv_replace",
      "MPI_Isendrecv_replace", "MPI_Send", "MPI_Ssend", "MPI_Bsend", "MPI_Issend", "MPI_Ibsend", "MPI_Isend", "MPI_Recv", "MPI_Irecv",
      "MPI_Scan", "MPI_Iscan", "MPI_Exscan", "MPI_Iexscan", "MPI_Waitall", "MPI_Waitsome", "MPI_Waitany", "MPI_Alloc_mem", "MPI_Free_mem",
      "MPI_Test", "MPI_Testall", "MPI_Testany", "MPI_Testsome", "MPI_Request_free"};
  for (StringRef str : mpiCallees) {
    if (Operation *opr = moduleOp.lookupSymbol(str)) {
      opr->erase();
    }
  }
}
} // namespace mlir::spmd