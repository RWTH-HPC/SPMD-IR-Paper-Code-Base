module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global "private" @"main@static@data" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@sendData@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c13_i32 = arith.constant 13 : i32
    %false = arith.constant false
    %c0_i32 = arith.constant 0 : i32
    %c42_i32 = arith.constant 42 : i32
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %3 = memref.get_global @"main@static@data" : memref<1xi32>
    %4 = memref.get_global @"main@static@recvData" : memref<1xi32>
    %5 = memref.get_global @"main@static@sendData" : memref<1xi32>
    %6 = memref.get_global @"main@static@sendData@init" : memref<1xi1>
    %7 = memref.load %6[%c0] : memref<1xi1>
    scf.if %7 {
      memref.store %false, %6[%c0] : memref<1xi1>
      memref.store %c13_i32, %5[%c0] : memref<1xi32>
    }
    %8 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %9 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %9 {
      memref.store %c42_i32, %3[%c0] : memref<1xi32>
      %cast = memref.cast %4 : memref<1xi32> to memref<?xi32>
      %cast_1 = memref.cast %5 : memref<1xi32> to memref<?xi32>
      %error_2 = "spmd.allreduce"(%2, %cast_1, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
      %cast_3 = memref.cast %3 : memref<1xi32> to memref<?xi32>
      %error_4 = "spmd.bcast"(%2, %cast_3, %cast_3, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
    } else {
      %cast = memref.cast %3 : memref<1xi32> to memref<?xi32>
      %error_1 = "spmd.bcast"(%2, %cast, %cast, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
      %cast_2 = memref.cast %4 : memref<1xi32> to memref<?xi32>
      %cast_3 = memref.cast %5 : memref<1xi32> to memref<?xi32>
      %error_4 = "spmd.allreduce"(%2, %cast_3, %cast_2, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    }
    %error_0 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    %10 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

