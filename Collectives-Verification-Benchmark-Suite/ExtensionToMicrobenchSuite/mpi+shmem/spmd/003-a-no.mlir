module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@sendData@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@myRank" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c42_i32 = arith.constant 42 : i32
    %c13_i32 = arith.constant 13 : i32
    %false = arith.constant false
    %c1_i64 = arith.constant 1 : i64
    %c4_i64 = arith.constant 4 : i64
    %true = arith.constant true
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %3 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %4 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %5 = memref.get_global @"main@static@sendData" : memref<1xi32>
    %6 = memref.get_global @"main@static@recvData" : memref<1xi32>
    %alloca = memref.alloca() : memref<1xi32>
    %7 = memref.get_global @"main@static@myRank" : memref<1xi32>
    memref.store %c42_i32, %alloca[%c0] : memref<1xi32>
    %8 = memref.get_global @"main@static@sendData@init" : memref<1xi1>
    %9 = memref.load %8[%c0] : memref<1xi1>
    scf.if %9 {
      memref.store %false, %8[%c0] : memref<1xi1>
      memref.store %c13_i32, %5[%c0] : memref<1xi32>
    }
    %10 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %11 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %cast = memref.cast %7 : memref<1xi32> to memref<?xi32>
    %rank, %error = "spmd.getRankInComm"(%4) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %rank_0, %error_1 = "spmd.getRankInComm"(%2) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %12 = arith.cmpi eq, %rank_0, %c0_i32 : i32
    %size, %error_2 = "spmd.getSizeOfComm"(%2) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %13 = arith.extsi %size : i32 to i64
    %14 = arith.muli %13, %c4_i64 : i64
    %memref, %error_3 = "spmd.malloc"(%2, %14) <{usedModel = 1 : i32}> : (!spmd.comm, i64) -> (memref<?xi8>, !spmd.error)
    %15 = "polygeist.memref2pointer"(%memref) : (memref<?xi8>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi32>
    %error_4 = "spmd.allgather"(%2, %cast, %c1_i64, %1, %16, %c1_i64, %1) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi32>, i64, !spmd.datatype, memref<?xi32>, i64, !spmd.datatype) -> !spmd.error
    %17 = scf.if %12 -> (i1) {
      scf.yield %true : i1
    } else {
      %20 = llvm.getelementptr %15[%rank] : (!llvm.ptr, i32) -> !llvm.ptr, i32
      %21 = llvm.load %20 : !llvm.ptr -> i32
      %22 = arith.cmpi eq, %21, %c0_i32 : i32
      scf.yield %22 : i1
    }
    scf.if %17 {
      %20 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %21 = "polygeist.pointer2memref"(%20) : (!llvm.ptr) -> memref<?xi8>
      %error_7 = "spmd.bcast"(%4, %21, %21, %c1_i64, %3, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %cast_8 = memref.cast %6 : memref<1xi32> to memref<?xi32>
      %cast_9 = memref.cast %5 : memref<1xi32> to memref<?xi32>
      %error_10 = "spmd.allreduce"(%2, %cast_9, %cast_8, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    } else {
      %20 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %21 = "polygeist.pointer2memref"(%20) : (!llvm.ptr) -> memref<?xi8>
      %error_7 = "spmd.bcast"(%4, %21, %21, %c1_i64, %3, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %cast_8 = memref.cast %6 : memref<1xi32> to memref<?xi32>
      %cast_9 = memref.cast %5 : memref<1xi32> to memref<?xi32>
      %error_10 = "spmd.allreduce"(%2, %cast_9, %cast_8, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    }
    %error_5 = "spmd.barrier"(%4) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    %error_6 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm) -> !spmd.error
    %18 = "spmd.finalize"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %19 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

