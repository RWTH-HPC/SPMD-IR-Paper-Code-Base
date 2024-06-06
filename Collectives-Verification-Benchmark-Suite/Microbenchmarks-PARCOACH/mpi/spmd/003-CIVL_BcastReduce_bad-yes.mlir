module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str2("int main(int, char **)\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("/home/sw339864/promotion/mlir-research/collective-verification-benchmark-suite/microbenchmarks-PC-2019/mpi/003-CIVL_BcastReduce_bad-yes.c\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("num == 3 * nprocs\00") {addr_space = 0 : i32}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i64 = arith.constant 1 : i64
    %c0_i32 = arith.constant 0 : i32
    %c3_i32 = arith.constant 3 : i32
    %c2_i32 = arith.constant 2 : i32
    %c0 = arith.constant 0 : index
    %c27_i32 = arith.constant 27 : i32
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %alloca = memref.alloca() : memref<1xi32>
    %3 = llvm.mlir.undef : i32
    memref.store %3, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %3, %alloca_0[%c0] : memref<1xi32>
    %4 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %rank, %error_1 = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %5 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %5 {
      memref.store %c3_i32, %alloca_0[%c0] : memref<1xi32>
    }
    %6 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %error_2 = "spmd.bcast"(%2, %7, %7, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %8 = arith.remsi %rank, %c2_i32 : i32
    %9 = arith.cmpi eq, %8, %c0_i32 : i32
    scf.if %9 {
      %17 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %18 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xi8>
      %error_3 = "spmd.reduce"(%2, %7, %18, %c1_i64, %1, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
    } else {
      %error_3 = "spmd.bcast"(%2, %7, %7, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    }
    %10 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %10 {
      %17 = memref.load %alloca[%c0] : memref<1xi32>
      memref.store %17, %alloca_0[%c0] : memref<1xi32>
    }
    %11 = arith.remsi %rank, %c2_i32 : i32
    %12 = arith.cmpi eq, %11, %c0_i32 : i32
    scf.if %12 {
      %error_3 = "spmd.bcast"(%2, %7, %7, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    } else {
      %17 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %18 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xi8>
      %error_3 = "spmd.reduce"(%2, %7, %18, %c1_i64, %1, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
    }
    %13 = memref.load %alloca_0[%c0] : memref<1xi32>
    %14 = arith.muli %size, %c3_i32 : i32
    %15 = arith.cmpi eq, %13, %14 : i32
    scf.if %15 {
    } else {
      %17 = llvm.mlir.addressof @str0 : !llvm.ptr
      %18 = llvm.mlir.addressof @str1 : !llvm.ptr
      %19 = llvm.mlir.addressof @str2 : !llvm.ptr
      %20 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xi8>
      %21 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xi8>
      %22 = "polygeist.pointer2memref"(%19) : (!llvm.ptr) -> memref<?xi8>
      func.call @__assert_fail(%20, %21, %c27_i32, %22) : (memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) -> ()
    }
    %16 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @__assert_fail(memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) attributes {llvm.linkage = #llvm.linkage<external>}
}

