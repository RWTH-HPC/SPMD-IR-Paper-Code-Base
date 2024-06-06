module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c42_i32 = arith.constant 42 : i32
    %c2_i64 = arith.constant 2 : i64
    %c4_i64 = arith.constant 4 : i64
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %1 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %2 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%1) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %3 = arith.extsi %size : i32 to i64
    %4 = arith.muli %3, %c4_i64 : i64
    %memref, %error_0 = "spmd.malloc"(%1, %4) <{usedModel = 0 : i32}> : (!spmd.comm, i64) -> (memref<?xi8>, !spmd.error)
    %5 = "polygeist.memref2pointer"(%memref) : (memref<?xi8>) -> !llvm.ptr
    %6 = "polygeist.pointer2memref"(%5) : (!llvm.ptr) -> memref<?xi32>
    %rank, %error_1 = "spmd.getRankInComm"(%1) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %7 {
      llvm.store %c42_i32, %5 : i32, !llvm.ptr
      %error_3 = "spmd.bcast"(%1, %6, %6, %c2_i64, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
    }
    %error_2 = "spmd.barrier"(%1) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    %8 = "spmd.free"(%1, %memref) <{usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>) -> !spmd.error
    %9 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

