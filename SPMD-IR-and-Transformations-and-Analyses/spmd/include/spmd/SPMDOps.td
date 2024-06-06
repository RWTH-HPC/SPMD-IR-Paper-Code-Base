//===- SPMDOps.td - SPMD dialect ops ----------------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SPMD_OPS
#define SPMD_OPS

include "SPMDDialect.td"
include "spmd/SPMDTypes.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/ViewLikeInterface.td" //
include "mlir/Interfaces/ControlFlowInterfaces.td"
// include "mlir/IR/SymbolInterfaces.td" //
include "mlir/Dialect/LLVMIR/LLVMOpBase.td"
// include "mlir/Dialect/LLVMIR/LLVMOpsInterfaces.td"

include "mlir/IR/OpBase.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/IR/Traits.td"

// Op results are not the same for each thread.
def ResultsNonUniform : NativeOpTrait<"ResultsNonUniform">{
  let cppNamespace = "::mlir::spmd";
}

def Collective : NativeOpTrait<"Collective">{
  let cppNamespace = "::mlir::spmd";
}

def P2P : NativeOpTrait<"P2P">{
  let cppNamespace = "::mlir::spmd";
}

def ProcessManagement : NativeOpTrait<"ProcessManagement">{
  let cppNamespace = "::mlir::spmd";
}

def CommManagement : NativeOpTrait<"CommManagement">{
  let cppNamespace = "::mlir::spmd";
}

def DataManagement : NativeOpTrait<"DataManagement">{
  let cppNamespace = "::mlir::spmd";
}

def NonBlockingSync : NativeOpTrait<"NonBlockingSync">{
  let cppNamespace = "::mlir::spmd";
}


def SPMD_InitOp : SPMD_Op<"init", [ProcessManagement]> {
  let arguments = (ins I32Attr : $usedModel);
  let results = (outs SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_FinalizeOp : SPMD_Op<"finalize", [ProcessManagement]> {
  let arguments = (ins I32Attr : $usedModel);
  let results = (outs SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_GetRankInCommOp : SPMD_Op<"getRankInComm", [ProcessManagement, ResultsNonUniform, Pure]> {
  let arguments = (ins SPMD_CommType : $comm,
                       I32Attr : $usedModel);
  let results = (outs I32 : $rank,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_GetDeviceInCommOp : SPMD_Op<"getDeviceInComm", [ProcessManagement, ResultsNonUniform, Pure]> {
  let arguments = (ins SPMD_CommType : $comm,
                       I32Attr : $usedModel);
  let results = (outs I32 : $device,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_GetSizeOfCommOp : SPMD_Op<"getSizeOfComm", [ProcessManagement, Pure]> {
  let arguments = (ins SPMD_CommType : $comm,
                       I32Attr : $usedModel);
  let results = (outs I32:$size, SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_CommWorldOp : SPMD_Op<"commWorld", [CommManagement, /*ConstantLike,*/ Pure]> {
  let arguments = (ins I32Attr : $usedModel);
  let results = (outs SPMD_CommType: $commWorld);
  // let regions = ();
  let summary = "";
  let description = [{}];
}


def SPMD_CommSplitStridedOp : SPMD_Op<"commSplitStrided", [CommManagement, Pure]> {
  let arguments = (ins SPMD_CommType : $parentComm,
                       I32 : $start,
                       I32 : $stride,
                       I32 : $size,
                       Optional<SPMD_CommConfigType> : $commConfig,
                      //  Optional<I64> : $commConfigMask, this argument is not practical as shmem has only one field in the config..
                      //  so this mask could be avoided by just passing NULL for the config or the real config when it wants to be used
                       I32Attr : $usedModel);
  let results = (outs SPMD_CommType : $newComm,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_CommDestroyOp : SPMD_Op<"commDestroy", [CommManagement, Pure]> {
  let arguments = (ins SPMD_CommType : $comm,
                       I32Attr : $usedModel);
  let results = (outs SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_CommSplitOp : SPMD_Op<"commSplit", [CommManagement, Pure]> {
  let arguments = (ins SPMD_CommType : $parentComm,
                       I32 : $color,
                       I32 : $key,
                       Optional<SPMD_CommConfigType> : $commConfig,
                       I32Attr : $usedModel);
  let results = (outs SPMD_CommType : $newComm,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_WaitAllOp : SPMD_Op<"waitAll", [NonBlockingSync]> {
  let arguments = (ins I32 : $count,
                       Arg<MemRefOf<[SPMD_ReqType]>, "", [MemRead, MemWrite]> : $reqs,
                       Res<MemRefOf<[SPMD_StatusType]>, "", [MemWrite]> : $statuses,
                       I32Attr : $usedModel);
  let results = (outs SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_WaitSomeOp : SPMD_Op<"waitSome", [NonBlockingSync]> {
  let arguments = (ins I32 : $inCount,
                       Arg<MemRefOf<[SPMD_ReqType]>, "", [MemRead, MemWrite]> : $reqs,
                       Arg<MemRefOf<[I32]>, "", [MemWrite]> : $indices,
                       Arg<MemRefOf<[SPMD_StatusType]>, "", [MemWrite]> : $statuses,
                       I32Attr : $usedModel);
  let results = (outs I32 : $outCount,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_WaitAnyOp : SPMD_Op<"waitAny", [NonBlockingSync]> {
  let arguments = (ins I32 : $count,
                       Arg<MemRefOf<[SPMD_ReqType]>, "", [MemRead, MemWrite]> : $reqs,
                       I32Attr : $usedModel);
  let results = (outs I32 : $index,
                      SPMD_StatusType : $status,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_TestAllOp : SPMD_Op<"testAll", [NonBlockingSync]> {
  let arguments = (ins I32 : $count,
                       Arg<MemRefOf<[SPMD_ReqType]>, "", [MemRead, MemWrite]> : $reqs,
                       Res<MemRefOf<[SPMD_StatusType]>, "", [MemWrite]> : $statuses,
                       I32Attr : $usedModel);
  let results = (outs I1 : $flag,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_TestSomeOp : SPMD_Op<"testSome", [NonBlockingSync]> {
  let arguments = (ins I32 : $inCount,
                       Arg<MemRefOf<[SPMD_ReqType]>, "", [MemRead, MemWrite]> : $reqs,
                       Arg<MemRefOf<[I32]>, "", [MemWrite]> : $indices,
                       Res<MemRefOf<[SPMD_StatusType]>, "", [MemWrite]> : $statuses,
                       I32Attr : $usedModel);
  let results = (outs I32 : $outCount,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_TestAnyOp : SPMD_Op<"testAny", [NonBlockingSync]> {
  let arguments = (ins I32 : $count,
                       Arg<MemRefOf<[SPMD_ReqType]>, "", [MemRead, MemWrite]> : $reqs,
                       I32Attr : $usedModel);
  let results = (outs I32 : $index,
                      I1 : $flag,
                      SPMD_StatusType : $status,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ConstDatatypeOp : SPMD_Op<"constDatatype", [/*ConstantLike,*/ Pure]> {
  let arguments = (ins TypeAttr : $typeAttr,
                       I32Attr : $usedModel);
  let results = (outs SPMD_DatatypeType: $constDatatype);
  // let regions = ();
  let summary = "";
  let description = [{}];
}

def SPMD_ConstReduceOpOp : SPMD_Op<"constReduceOp", [/*ConstantLike,*/ Pure]> {
  let arguments = (ins StrAttr : $stringAttr,
                       I32Attr : $usedModel);
  let results = (outs SPMD_ReduceOpType: $constReduceOp);
  // let regions = ();
  let summary = "";
  let description = [{}];
}

def SPMD_CastStreamOp : SPMD_Op<"castStream", [Pure/*, ViewLikeOpInterface*/]> {
  let arguments = (ins AnyMemRef : $oldStream,
                       I32Attr : $usedModel);
  let results = (outs SPMD_StreamType: $newStream);
  // let regions = ();
  let summary = "";
  let description = [{}];
}

def SPMD_MallocOp : SPMD_Op<"malloc", [DataManagement]> {
  let arguments = (ins SPMD_CommType : $comm,
                       I64 : $size,
                       I32Attr : $usedModel);
  let results = (outs Res<AnyMemRef, "", [MemAlloc]> : $memref,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ReallocOp : SPMD_Op<"realloc", [DataManagement]> {
  let arguments = (ins SPMD_CommType : $comm,
                       Arg<AnyMemRef, "", [MemFree]>:$ptr,
                       I64 : $size,
                       I32Attr : $usedModel);
  let results = (outs Res<AnyMemRef, "", [MemAlloc]> : $memref,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_FreeOp : SPMD_Op<"free", [DataManagement]> {
  let arguments = (ins SPMD_CommType : $comm,
                       Arg<AnyMemRef, "", [MemFree]>:$ptr,
                       I32Attr : $usedModel);
  let results = (outs SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

//memory effects specified in SPMDOPS.cpp
def SPMD_SendOp : SPMD_Op<"send", [P2P, DeclareOpInterfaceMethods<MemoryEffectsOpInterface>]> {
  let arguments = (ins SPMD_CommType : $comm,
                       AnyMemRef : $sendBuf, //memRead 
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       I32 : $destRank,
                       I32 : $tag,
                       Optional<SPMD_StreamType> : $stream,  // MemWrite, MemRead
                       BoolAttr : $isBlocking,
                       BoolAttr : $isBuffered,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

//memory effects specified in SPMDOPS.cpp
def SPMD_RecvOp : SPMD_Op<"recv", [P2P, DeclareOpInterfaceMethods<MemoryEffectsOpInterface>]> {
  let arguments = (ins SPMD_CommType : $comm,
                       AnyMemRef : $recvBuf, //memRead 
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       I32 : $srcRank,
                       I32 : $tag,
                       Optional<SPMD_StreamType>:$stream, // MemWrite, MemRead
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      // SPMD_StatusType: status,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}


def SPMD_BarrierOp : SPMD_Op<"barrier", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_BcastOp : SPMD_Op<"bcast", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       I32 : $rootRank,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ReduceOp : SPMD_Op<"reduce", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       SPMD_ReduceOpType : $reduceOp,
                       I32 : $rootRank,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_AllreduceOp : SPMD_Op<"allreduce", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       SPMD_ReduceOpType : $reduceOp,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ReduceScatterOp : SPMD_Op<"reduceScatter", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]> : $sendBuf,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]> : $recvBuf,
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       SPMD_ReduceOpType : $reduceOp,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ScanOp : SPMD_Op<"scan", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       SPMD_ReduceOpType : $reduceOp,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ExscanOp : SPMD_Op<"exscan", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $dataCount,
                       SPMD_DatatypeType : $datatype,
                       SPMD_ReduceOpType : $reduceOp,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_ScatterOp : SPMD_Op<"scatter", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                      Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                       I64 : $sendCount,
                       SPMD_DatatypeType : $sendType,
                      Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $recvCount,
                       SPMD_DatatypeType : $recvType,
                       I32 : $rootRank,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_GatherOp : SPMD_Op<"gather", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                       Arg<AnyMemRef, "send buffer",
                             [MemRead]>:$sendBuf,
                       I64 : $sendCount,
                       SPMD_DatatypeType : $sendType,
                       Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $recvCount,
                       SPMD_DatatypeType : $recvType,
                       I32 : $rootRank,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_AllgatherOp : SPMD_Op<"allgather", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                       Arg<AnyMemRef, "send buffer",
                            [MemRead]>:$sendBuf,
                       I64 : $sendCount,
                       SPMD_DatatypeType : $sendType,
                       Arg<AnyMemRef, "recv buffer",
                             [MemWrite]>:$recvBuf,
                       I64 : $recvCount,
                       SPMD_DatatypeType : $recvType,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}

def SPMD_AlltoallOp : SPMD_Op<"alltoall", [Collective]> {
  let arguments = (ins SPMD_CommType : $comm,
                       Arg<AnyMemRef, "send buffer",
                            [MemRead]>:$sendBuf,
                       I64 : $sendCount,
                       SPMD_DatatypeType : $sendType,
                       Arg<AnyMemRef, "recv buffer",
                            [MemWrite]>:$recvBuf,
                       I64 : $recvCount,
                       SPMD_DatatypeType : $recvType,
                       Arg<Optional<SPMD_StreamType>, "stream",
                             [MemWrite, MemRead]>:$stream,
                       BoolAttr : $isBlocking,
                       I32Attr : $usedModel);
  let results = (outs Optional<SPMD_ReqType> : $req,
                      SPMD_ErrorType : $error);
  let summary = "";
  let description = [{}];
}




#endif // SPMD_OPS
