module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i64 = arith.constant 1 : i64
    %c8_i32 = arith.constant 8 : i32
    %c42_i32 = arith.constant 42 : i32
    %c13_i32 = arith.constant 13 : i32
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c21_i32 = arith.constant 21 : i32
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %1 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> : () -> !spmd.reduceOp
    %2 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %alloca = memref.alloca() : memref<1xi32>
    %3 = llvm.mlir.undef : i32
    memref.store %3, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    %alloca_2 = memref.alloca() : memref<1xi32>
    memref.store %c8_i32, %alloca_2[%c0] : memref<1xi32>
    memref.store %c42_i32, %alloca_1[%c0] : memref<1xi32>
    memref.store %c13_i32, %alloca_0[%c0] : memref<1xi32>
    %4 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %5 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xi32>) -> !llvm.ptr
    %6 = "polygeist.pointer2memref"(%5) : (!llvm.ptr) -> memref<?xi8>
    %7 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xi32>) -> !llvm.ptr
    %8 = "polygeist.pointer2memref"(%7) : (!llvm.ptr) -> memref<?xi8>
    %error = "spmd.allreduce"(%0, %6, %8, %c1_i64, %2, %1) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    %9 = memref.load %alloca_2[%c0] : memref<1xi32>
    %10 = arith.cmpi eq, %9, %c21_i32 : i32
    scf.if %10 {
      %error_4 = "spmd.bcast"(%0, %6, %6, %c1_i64, %2, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %12 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %error_5 = "spmd.reduce"(%0, %13, %15, %c1_i64, %2, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
    } else {
      %error_4 = "spmd.bcast"(%0, %6, %6, %c1_i64, %2, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %12 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %error_5 = "spmd.reduce"(%0, %13, %15, %c1_i64, %2, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
    }
    %error_3 = "spmd.barrier"(%0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    %11 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

