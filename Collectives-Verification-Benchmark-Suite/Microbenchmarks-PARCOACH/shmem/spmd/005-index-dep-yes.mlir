module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c4_i64 = arith.constant 4 : i64
    %c10_i32 = arith.constant 10 : i32
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %1 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%0) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %rank, %error_0 = "spmd.getRankInComm"(%0) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %2 = arith.extsi %size : i32 to i64
    %3 = arith.muli %2, %c4_i64 : i64
    %memref, %error_1 = "spmd.malloc"(%0, %3) <{usedModel = 0 : i32}> : (!spmd.comm, i64) -> (memref<?xi8>, !spmd.error)
    %4 = "polygeist.memref2pointer"(%memref) : (memref<?xi8>) -> !llvm.ptr
    %5 = arith.index_cast %size : i32 to index
    scf.for %arg2 = %c0 to %5 step %c1 {
      %11 = arith.index_cast %arg2 : index to i32
      %12 = llvm.getelementptr %4[%11] : (!llvm.ptr, i32) -> !llvm.ptr, i32
      llvm.store %11, %12 : i32, !llvm.ptr
    }
    %6 = llvm.getelementptr %4[%rank] : (!llvm.ptr, i32) -> !llvm.ptr, i32
    %7 = llvm.load %6 : !llvm.ptr -> i32
    %8 = arith.cmpi sgt, %7, %c10_i32 : i32
    scf.if %8 {
      %error_2 = "spmd.barrier"(%0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    }
    %9 = "spmd.free"(%0, %memref) <{usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>) -> !spmd.error
    %10 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

