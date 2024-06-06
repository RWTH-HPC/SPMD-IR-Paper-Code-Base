module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i64 = arith.constant 1 : i64
    %c13_i32 = arith.constant 13 : i32
    %c2_i32 = arith.constant 2 : i32
    %c4_i32 = arith.constant 4 : i32
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %3 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<1xi32>
    memref.store %3, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %c13_i32, %alloca_0[%c0] : memref<1xi32>
    %4 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %5 = arith.remsi %rank, %c2_i32 : i32
    %newComm, %error_1 = "spmd.commSplit"(%2, %5, %rank) <{usedModel = 0 : i32}> : (!spmd.comm, i32, i32) -> (!spmd.comm, !spmd.error)
    %6 = arith.remsi %rank, %c4_i32 : i32
    %7 = arith.cmpi ne, %6, %c0_i32 : i32
    scf.if %7 {
      %error_2 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
      %9 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xi8>
      %11 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xi8>
      %error_3 = "spmd.reduce"(%newComm, %10, %12, %c1_i64, %1, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
    } else {
      %9 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xi8>
      %11 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xi8>
      %error_2 = "spmd.reduce"(%newComm, %10, %12, %c1_i64, %1, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
      %error_3 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    }
    %8 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

