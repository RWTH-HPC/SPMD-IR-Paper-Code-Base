module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c2_i32 = arith.constant 2 : i32
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %1 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %alloca = memref.alloca() : memref<1x!spmd.status>
    %alloca_0 = memref.alloca() : memref<1x!spmd.req>
    %2 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%1) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %size, %error_1 = "spmd.getSizeOfComm"(%1) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %3 = arith.index_cast %size : i32 to index
    %alloca_2 = memref.alloca(%3) : memref<?xi32>
    %alloca_3 = memref.alloca(%3) : memref<?xi32>
    %4 = arith.extsi %rank : i32 to i64
    scf.for %arg2 = %c0 to %3 step %c1 {
      %8 = arith.index_cast %arg2 : index to i64
      %9 = arith.muli %8, %4 : i64
      %10 = arith.trunci %9 : i64 to i32
      memref.store %10, %alloca_2[%arg2] : memref<?xi32>
    }
    %5 = arith.remsi %rank, %c2_i32 : i32
    %6 = arith.cmpi ne, %5, %c0_i32 : i32
    scf.if %6 {
      %8 = "polygeist.memref2pointer"(%alloca_2) : (memref<?xi32>) -> !llvm.ptr
      %9 = "polygeist.pointer2memref"(%8) : (!llvm.ptr) -> memref<?xi8>
      %10 = "polygeist.memref2pointer"(%alloca_3) : (memref<?xi32>) -> !llvm.ptr
      %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xi8>
      %12 = arith.extui %size : i32 to i64
      %13 = arith.extui %size : i32 to i64
      %error_4 = "spmd.alltoall"(%1, %9, %12, %0, %11, %13, %0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype) -> !spmd.error
    } else {
      %8 = "polygeist.memref2pointer"(%alloca_2) : (memref<?xi32>) -> !llvm.ptr
      %9 = "polygeist.pointer2memref"(%8) : (!llvm.ptr) -> memref<?xi8>
      %10 = "polygeist.memref2pointer"(%alloca_3) : (memref<?xi32>) -> !llvm.ptr
      %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xi8>
      %12 = arith.extui %size : i32 to i64
      %13 = arith.extui %size : i32 to i64
      %req, %error_4 = "spmd.alltoall"(%1, %9, %12, %0, %11, %13, %0) <{isBlocking = false, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype) -> (!spmd.req, !spmd.error)
      memref.store %req, %alloca_0[%c0] : memref<1x!spmd.req>
      %14 = "spmd.waitAll"(%c1_i32, %alloca_0, %alloca) <{usedModel = 0 : i32}> : (i32, memref<1x!spmd.req>, memref<1x!spmd.status>) -> !spmd.error
    }
    %7 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

