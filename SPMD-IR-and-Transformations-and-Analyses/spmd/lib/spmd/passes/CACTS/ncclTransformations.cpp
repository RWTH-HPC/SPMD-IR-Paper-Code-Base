//===- ncclTransformations.cpp - Convert nccl api calls to spmd dialect - Source -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This defines functions for converting nccl func call operations to the spmd dialect
//
//===----------------------------------------------------------------------===//

#include "ncclTransformations.h"

namespace mlir::spmd {
Value getNewStreamNCCL(Value streamArg, IRMapping& valueMapping, int modelGroup){
  Value newStream;
  if (memref::LoadOp memredLoadOp = dyn_cast<memref::LoadOp>(streamArg.getDefiningOp())) {
    Value memref = memredLoadOp->getOperand(0);
    if (valueMapping.contains(memref)) {
      newStream = valueMapping.lookup(memref);
    } 
    else {
      OpBuilder opBuilder(memredLoadOp);
      Operation *allocaOpr = memref.getDefiningOp();
      opBuilder.setInsertionPointAfter(allocaOpr);
      newStream = opBuilder.create<spmd::CastStreamOp>(allocaOpr->getLoc(), memref, modelGroup).getResult();
      valueMapping.map(memref, newStream);
    }
  }
  else {
    llvm_unreachable("\nNot implemented case of non-memrefLoadOp stream usage\n");
  }
  return newStream;
}

Value getNewReduceOpNCCL(Value reduceOpArg, IRMapping& valueMapping, int modelGroup){
  Value newReduceOp;
  if (valueMapping.contains(reduceOpArg)) {
    newReduceOp = valueMapping.lookup(reduceOpArg);
  } 
  else if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(reduceOpArg.getDefiningOp())) {
    const int NCCL_SUM = 0;
    OpBuilder opBuilder(constantOp);
    if(IntegerAttr integerAttr = dyn_cast<IntegerAttr>(constantOp.getValueAttr())) {
      if (integerAttr.getInt() == NCCL_SUM) {
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

Value getNewDatatypeNCCL(Value datatypeArg, IRMapping& valueMapping, int modelGroup){
  Value newDatatype;
  if (valueMapping.contains(datatypeArg)) {
    newDatatype = valueMapping.lookup(datatypeArg);
  } 
  else if (arith::ConstantOp constantOp = dyn_cast<arith::ConstantOp>(datatypeArg.getDefiningOp())) {
    const int NCCL_INT = 2;
    OpBuilder opBuilder(constantOp);
    if (IntegerAttr integerAttr = dyn_cast<IntegerAttr>(constantOp.getValueAttr())) {
      if (integerAttr.getInt() == NCCL_INT) {
        opBuilder.setInsertionPoint(constantOp.getOperation());
        newDatatype = opBuilder.create<spmd::ConstDatatypeOp>(constantOp->getLoc(), opBuilder.getI32Type(), modelGroup).getResult();
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

Value getNewCommNCCL(Value commArg, IRMapping& valueMapping, int modelGroup, Value sizeArg = Value(), bool implicitWorld = false, Operation* currentCallOpr = nullptr){
  Value newComm;
  Value actualComm;
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

  Operation *definingOpr = commArg.getDefiningOp();
  if (isa<memref::CastOp>(definingOpr) || isa<memref::LoadOp>(definingOpr)) {
    actualComm = definingOpr->getOperand(0);
  }
  else {
    llvm_unreachable("\nNot implemented case of unknown communicator operation type\n");
  }

  if (sizeArg) {
    Operation *definingSizeOpr = sizeArg.getDefiningOp();
    if (isa<spmd::GetSizeOfCommOp>(definingSizeOpr) && isa<spmd::CommWorldOp>(definingSizeOpr->getOperand(0).getDefiningOp())) {
      OpBuilder opBuilder(definingSizeOpr);
      opBuilder.setInsertionPoint(actualComm.getDefiningOp());
      newComm = opBuilder.create<spmd::CommWorldOp>(actualComm.getDefiningOp()->getLoc(), modelGroup).getResult();
      valueMapping.map(actualComm, newComm);
    }
    else {
      llvm_unreachable("\nNot implemented case of non-commWorld communicator of overarching modelGroup\n");
    }
  }
  else if (valueMapping.contains(actualComm)) {
    newComm = valueMapping.lookup(actualComm);
  } 
  else {
    llvm_unreachable("\nNot implemented case of non-commWorld communicator of overarching modelGroup\n");
  }
  return newComm;
}

void handleGroupReqs(Operation *callOpr, Value newReq, bool *firstExecutionForGroup, Value *ncclGroupReqMemref, int64_t *ncclGroupNumReqs) {
  OpBuilder opBuilder(newReq.getDefiningOp());
  auto loc = newReq.getLoc();

  if (*firstExecutionForGroup) {
    *firstExecutionForGroup = false;
    auto memrefType = MemRefType::get({ShapedType::kDynamic}, opBuilder.getType<spmd::ReqType>());
    opBuilder.setInsertionPointToStart(&(callOpr->getParentOfType<func::FuncOp>()->getRegion(0).getBlocks().front()));
    auto allocaOp = opBuilder.create<memref::AllocaOp>(loc, memrefType);
    *ncclGroupReqMemref = allocaOp.getResult();
  }
  opBuilder.setInsertionPoint(callOpr);
  auto index = opBuilder.create<arith::ConstantIndexOp>(loc, *ncclGroupNumReqs).getResult();
  opBuilder.create<memref::StoreOp>(loc, newReq, *ncclGroupReqMemref, index);
  (*ncclGroupNumReqs)++;
}

void convertApiCallNCCL(func::CallOp callOp, int modelGroup) {
  OpBuilder opBuilder(callOp);
  Location loc = callOp->getLoc();
  StringRef calleeStrRef = callOp.getCallee();
  
  static IRMapping valueMapping;
  static llvm::DenseMap<Value, bool> commValueToBoolMap;
  static bool ncclGroupStarted = false;
  static bool firstExecutionForGroup = true;
  static Value ncclGroupReqMemref;
  static int64_t ncclGroupNumReqs = 0;

  if (calleeStrRef.equals("ncclCommInitRank")) {   
    // if id is send by a collective to comm world, then rankArg represents equivalently rank of commworld of both modelGroups
    // Todo: for simplicity we just check if sizeArg stems from a commworld and assume that one process is managing one gpu
    Value commArg = callOp->getOperand(0);
    Value sizeArg = callOp->getOperand(1);
    // Value idArg = callOp->getOperand(2);
    // Value rankArg = callOp->getOperand(3);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup, sizeArg);

    commValueToBoolMap[newComm] = true;;

    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::InitOp>(loc, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclCommInitRankConfig")) {   
    // if id is send by a collective to comm world, then rankArg represents equivalently rank of commworld of both modelGroups
    // Todo: for simplicity we just check if sizeArg stems from a commworld and assume that one process is managing one gpu
    Value commArg = callOp->getOperand(0);
    Value sizeArg = callOp->getOperand(1);
    Value configArg = callOp->getOperand(2);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup, sizeArg);

    bool isBlocking = true;

    if (auto castOp = dyn_cast<memref::CastOp>(configArg.getDefiningOp())) {
      if (auto mem2Ptr = dyn_cast<polygeist::Memref2PointerOp>(castOp.getOperand().getDefiningOp())) {
        Value ptr = mem2Ptr.getResult();
        for (Operation *user : ptr.getUsers()){
          if (user == castOp) {
            break;
          }
          if (auto gepOp = dyn_cast<LLVM::GEPOp>(user)) {
            auto rawConstantIndicesAttr = gepOp->getAttrOfType<ArrayAttr>("rawConstantIndices");
            if (rawConstantIndicesAttr) {
              if (rawConstantIndicesAttr.size() == 2) {
                if (auto secondIndexAttr = rawConstantIndicesAttr[1].dyn_cast<IntegerAttr>()) {
                  int64_t secondIndex = secondIndexAttr.getInt();
                  if (secondIndex == 3) {
                    for (Operation *user2 : gepOp.getResult().getUsers()){
                      if (auto storeOpr = dyn_cast<LLVM::StoreOp>(user2)) {
                        if (auto constOp = dyn_cast<arith::ConstantOp>(storeOpr.getOperand(0).getDefiningOp())) {
                          if (auto intAttr = constOp.getValue().dyn_cast<IntegerAttr>()) {
                            if (intAttr.getValue().isZero()) {
                              isBlocking = false;
                            }
                            else {
                              isBlocking = true;
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    commValueToBoolMap[newComm] = isBlocking;

    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::InitOp>(loc, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclGroupStart")) {
    ncclGroupStarted = true;
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclGroupEnd")) {
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value count = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(ncclGroupNumReqs)).getResult();

    // Define the memref type that can store 1 element of spmd::StatusType
    auto memrefType = MemRefType::get({ncclGroupNumReqs}, opBuilder.getType<spmd::StatusType>());
    // Create the AllocaOp to allocate the memref
    Value newStatuses = opBuilder.create<memref::AllocaOp>(loc, memrefType).getResult();
    opBuilder.create<spmd::WaitAllOp>(loc, opBuilder.getType<spmd::ErrorType>(), count, ncclGroupReqMemref, newStatuses, modelGroup);

    Operation *allocaOpr = ncclGroupReqMemref.getDefiningOp();
    opBuilder.setInsertionPoint(allocaOpr);
    auto memrefType2 = MemRefType::get({ncclGroupNumReqs}, opBuilder.getType<spmd::ReqType>());
    auto newMemref = opBuilder.create<memref::AllocaOp>(loc, memrefType2).getResult();
    ncclGroupReqMemref.replaceAllUsesWith(newMemref);
    allocaOpr->erase();

    ncclGroupStarted = false;
    firstExecutionForGroup = true;
    ncclGroupNumReqs = 0;

    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclBroadcast")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value rootRankArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value streamArg = callOp->getOperand(6);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeNCCL(datatypeArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::BcastOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg,
          recvBufArg, countArg, newDatatype, rootRankArg, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::BcastOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg,
        countArg, newDatatype, rootRankArg, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclBcast")) {
    Value sendRecvBufArg = callOp->getOperand(0);
    Value countArg = callOp->getOperand(1);
    Value datatypeArg = callOp->getOperand(2);
    Value rootRankArg = callOp->getOperand(3);
    Value commArg = callOp->getOperand(4);
    Value streamArg = callOp->getOperand(5);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeNCCL(datatypeArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::BcastOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendRecvBufArg, sendRecvBufArg,
        countArg, newDatatype, rootRankArg, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::BcastOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendRecvBufArg, sendRecvBufArg,
        countArg, newDatatype, rootRankArg, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclReduce")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value rootRankArg = callOp->getOperand(5);
    Value commArg = callOp->getOperand(6);
    Value streamArg = callOp->getOperand(7);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeNCCL(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpNCCL(reduceOpArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::ReduceOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
        newDatatype, newReduceOp, rootRankArg, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::ReduceOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
        newDatatype, newReduceOp, rootRankArg, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclAllGather")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value commArg = callOp->getOperand(4);
    Value streamArg = callOp->getOperand(5);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeNCCL(datatypeArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::AllgatherOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg,  
        countArg, newDatatype, recvBufArg, countArg, newDatatype, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::AllgatherOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg,  
        countArg, newDatatype, recvBufArg, countArg, newDatatype, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclAllReduce")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value streamArg = callOp->getOperand(6);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeNCCL(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpNCCL(reduceOpArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::AllreduceOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
        newDatatype, newReduceOp, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::AllreduceOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
        newDatatype, newReduceOp, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclReduceScatter")) {
    Value sendBufArg = callOp->getOperand(0);
    Value recvBufArg = callOp->getOperand(1);
    Value countArg = callOp->getOperand(2);
    Value datatypeArg = callOp->getOperand(3);
    Value reduceOpArg = callOp->getOperand(4);
    Value commArg = callOp->getOperand(5);
    Value streamArg = callOp->getOperand(6);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newDatatype = getNewDatatypeNCCL(datatypeArg, valueMapping, modelGroup);
    Value newReduceOp = getNewReduceOpNCCL(reduceOpArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    opBuilder.setInsertionPoint(callOp.getOperation());
    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::ReduceScatterOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
        newDatatype, newReduceOp, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::ReduceScatterOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, recvBufArg, countArg,
        newDatatype, newReduceOp, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclSend")) {
    Value sendBufArg = callOp->getOperand(0);
    Value sendCountArg = callOp->getOperand(1);
    Value sendTypeArg = callOp->getOperand(2);
    Value destRankArg = callOp->getOperand(3);
    Value commArg = callOp->getOperand(4);
    Value streamArg = callOp->getOperand(5);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newSendType = getNewDatatypeNCCL(sendTypeArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    //TODO: Use a default tag instead of just 0, although it should be technically the same
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value zero = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(0)).getResult();

    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::SendOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, sendCountArg,
        newSendType, destRankArg, zero, newStream, /*isBlocking=*/false, /*isBuffered=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::SendOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, sendBufArg, sendCountArg,
        newSendType, destRankArg, zero, newStream, /*isBlocking=*/commValueToBoolMap[newComm], /*isBuffered=*/false, modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclRecv")) {
    Value recvBufArg = callOp->getOperand(0);
    Value recvCountArg = callOp->getOperand(1);
    Value recvTypeArg = callOp->getOperand(2);
    Value srcRankArg = callOp->getOperand(3);
    Value commArg = callOp->getOperand(4);
    Value streamArg = callOp->getOperand(5);

    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    Value newRecvType = getNewDatatypeNCCL(recvTypeArg, valueMapping, modelGroup);
    Value newStream = getNewStreamNCCL(streamArg, valueMapping, modelGroup);

    //TODO: Use a default tag instead of just 0, although it should be technically the same
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value zero = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(0)).getResult();

    if (ncclGroupStarted){
      Value newReq = opBuilder.create<spmd::RecvOp>(loc, opBuilder.getType<spmd::ReqType>(), opBuilder.getType<spmd::ErrorType>(), newComm, recvBufArg, recvCountArg,
        newRecvType, srcRankArg, zero, newStream, /*isBlocking=*/false, modelGroup).getResult(0);
      handleGroupReqs(callOp.getOperation(), newReq, &firstExecutionForGroup, &ncclGroupReqMemref, &ncclGroupNumReqs);
    }
    else {
      opBuilder.create<spmd::RecvOp>(loc, Type(), opBuilder.getType<spmd::ErrorType>(), newComm, recvBufArg, recvCountArg,
        newRecvType, srcRankArg, zero, newStream, /*isBlocking=*/commValueToBoolMap[newComm], modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclCommSplit")) {
    Value parentCommArg = callOp->getOperand(0);
    Value colorArg = callOp->getOperand(1);
    Value keyArg = callOp->getOperand(2);
    Value newCommArg = callOp->getOperand(3);
    Value configArg = callOp->getOperand(4);

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
      llvm_unreachable("\nNot implemented case of comm split replacement\n");
    }

    Value newParentComm = getNewCommNCCL(parentCommArg, valueMapping, modelGroup);
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newNewComm = opBuilder.create<spmd::CommSplitOp>(loc, newParentComm, colorArg, keyArg, Value(), modelGroup).getResult(0);
    commValueToBoolMap[newNewComm] = commValueToBoolMap[newParentComm];
    valueMapping.map(newCommArg, newNewComm);
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclCommDestroy")) {
    Value commArg = callOp->getOperand(0);
    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    opBuilder.setInsertionPoint(callOp.getOperation());
    if (isa<spmd::CommWorldOp>(newComm.getDefiningOp())){
      // do nothing, as commworld do not need to be destroyed in the spmd dialect
    }
    else {
      opBuilder.setInsertionPoint(callOp.getOperation());
      opBuilder.create<spmd::CommDestroyOp>(loc, newComm, modelGroup);
    }
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclCommUserRank")) {
    Value commArg = callOp->getOperand(0);
    Value rankArg = callOp->getOperand(1);
    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newRank = opBuilder.create<spmd::GetRankInCommOp>(loc, newComm, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(rankArg, newRank);
  }
  else if (calleeStrRef.equals("ncclCommCuDevice")) {
    Value commArg = callOp->getOperand(0);
    Value deviceArg = callOp->getOperand(1);
    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newDevice = opBuilder.create<spmd::GetDeviceInCommOp>(loc, newComm, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(deviceArg, newDevice);
  }
  else if (calleeStrRef.equals("ncclCommCount")) {
    Value commArg = callOp->getOperand(0);
    Value countArg = callOp->getOperand(1);
    Value newComm = getNewCommNCCL(commArg, valueMapping, modelGroup);
    
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newCount = opBuilder.create<spmd::GetSizeOfCommOp>(loc, newComm, modelGroup).getResult(0);
    callOp->erase();
    replaceMemrefByValue(countArg, newCount);
  }
  else if (calleeStrRef.equals("ncclMemAlloc")) {
    Value ptrArg = callOp->getOperand(0);
    Value sizeArg = callOp->getOperand(1);
    Value newComm = getNewCommNCCL(Value(), valueMapping, modelGroup, Value(), true, callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    Value newPtr = opBuilder.create<spmd::MallocOp>(loc, ptrArg.getType(), opBuilder.getType<spmd::ErrorType>(), newComm, sizeArg, modelGroup).getResult(0);
    ptrArg.replaceAllUsesWith(newPtr);
    callOp->erase();
    // replaceMemrefByValue(ptrArg, newPtr);
  }
  else if (calleeStrRef.equals("ncclMemFree")) {
    Value ptrArg = callOp->getOperand(0);
    Value newComm = getNewCommNCCL(Value(), valueMapping, modelGroup, Value(), true, callOp.getOperation());
    opBuilder.setInsertionPoint(callOp.getOperation());
    opBuilder.create<spmd::FreeOp>(loc, opBuilder.getType<spmd::ErrorType>(), newComm, ptrArg, modelGroup);
    callOp->erase();
  }
  else if (calleeStrRef.equals("ncclCommGetAsyncError")) {
    // Value commArg = callOp->getOperand(0);
    // Value asyncErrorArg = callOp->getOperand(1);
 
    // Value idx;
    // Value reqArgMemref = getMemref(reqArg, &idx);
    // Value newReqMemref = getNewReqMPI(reqArgMemref, valueMapping, modelGroup);
    // Value idx2;
    // Value statusMemref = getMemref(statusArg, &idx2);
    // Value newStatuses = getNewStatusesMPI(statusMemref, valueMapping, true);

    // opBuilder.setInsertionPoint(callOp.getOperation());
    // Value countOne = opBuilder.create<arith::ConstantOp>(loc, opBuilder.getI32IntegerAttr(1)).getResult();
    // Value newFlag = opBuilder.create<spmd::TestAllOp>(loc, opBuilder.getI1Type(), opBuilder.getType<spmd::ErrorType>(),
    //     countOne, newReqMemref, newStatuses, modelGroup).getResult(0);
    // Value castedFlag = opBuilder.create<arith::ExtUIOp>(loc, opBuilder.getI32Type(), newFlag).getResult();
    // callOp->erase();
    // replaceMemrefByValue(asyncErrorArg, castedFlag);
  }
}

void deleteApiCalleesNCCL(ModuleOp moduleOp) {
  SmallVector<StringRef> mpiCallees {"ncclCommInitRank", "ncclCommInitRankConfig", "ncclCommDestroy", "ncclBcast", "ncclBroadcast",
      "ncclReduce", "ncclCommUserRank", "ncclAllGather", "ncclAllReduce", "ncclReduceScatter", "ncclCommSplit", "ncclCommDestroy",
      "ncclGroupStart", "ncclGroupEnd", "ncclSend", "ncclRecv" , "ncclCommCount", "ncclMemAlloc", "ncclMemFree", "ncclCommCuDevice",
      "ncclCommGetAsyncError"};
  for (StringRef str : mpiCallees) {
    if (Operation *opr = moduleOp.lookupSymbol(str)) {
      opr->erase();
    }
  }
}

} // namespace mlir::spmd