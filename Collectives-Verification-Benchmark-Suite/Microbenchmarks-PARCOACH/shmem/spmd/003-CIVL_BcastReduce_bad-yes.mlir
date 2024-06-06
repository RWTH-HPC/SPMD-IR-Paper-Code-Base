module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str2("int main(int, char **)\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("/home/sw339864/promotion/mlir-research/collective-verification-benchmark-suite/microbenchmarks-PC-2019/shmem/003-CIVL_BcastReduce_bad-yes.c\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("num == 3 * nprocs\00") {addr_space = 0 : i32}
  memref.global "private" @"main@static@recv" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@num" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c3_i32 = arith.constant 3 : i32
    %c1_i64 = arith.constant 1 : i64
    %c2_i32 = arith.constant 2 : i32
    %c27_i32 = arith.constant 27 : i32
    %c0 = arith.constant 0 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %3 = memref.get_global @"main@static@recv" : memref<1xi32>
    %4 = memref.get_global @"main@static@num" : memref<1xi32>
    %5 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %rank, %error_0 = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %6 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %6 {
      memref.store %c3_i32, %4[%c0] : memref<1xi32>
    }
    %cast = memref.cast %4 : memref<1xi32> to memref<?xi32>
    %error_1 = "spmd.bcast"(%2, %cast, %cast, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
    %7 = arith.remsi %rank, %c2_i32 : i32
    %8 = arith.cmpi eq, %7, %c0_i32 : i32
    scf.if %8 {
      %cast_2 = memref.cast %3 : memref<1xi32> to memref<?xi32>
      %error_3 = "spmd.allreduce"(%2, %cast, %cast_2, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    } else {
      %error_2 = "spmd.bcast"(%2, %cast, %cast, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
    }
    scf.if %6 {
      %13 = memref.load %3[%c0] : memref<1xi32>
      memref.store %13, %4[%c0] : memref<1xi32>
    }
    scf.if %8 {
      %error_2 = "spmd.bcast"(%2, %cast, %cast, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
    } else {
      %cast_2 = memref.cast %3 : memref<1xi32> to memref<?xi32>
      %error_3 = "spmd.allreduce"(%2, %cast, %cast_2, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    }
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = arith.muli %size, %c3_i32 : i32
    %11 = arith.cmpi eq, %9, %10 : i32
    scf.if %11 {
    } else {
      %13 = llvm.mlir.addressof @str0 : !llvm.ptr
      %14 = llvm.mlir.addressof @str1 : !llvm.ptr
      %15 = llvm.mlir.addressof @str2 : !llvm.ptr
      %16 = "polygeist.pointer2memref"(%13) : (!llvm.ptr) -> memref<?xi8>
      %17 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %18 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
      func.call @__assert_fail(%16, %17, %c27_i32, %18) : (memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) -> ()
    }
    %12 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @__assert_fail(memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) attributes {llvm.linkage = #llvm.linkage<external>}
}

