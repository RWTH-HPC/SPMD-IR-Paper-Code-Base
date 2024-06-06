module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c4_i64 = arith.constant {spmd.executionKind = "All"} 4 : i64
    %c10_i32 = arith.constant {spmd.executionKind = "All"} 10 : i32
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %1 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%0) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %rank, %error_0 = "spmd.getRankInComm"(%0) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %2 = arith.extsi %size {spmd.executionKind = "All"} : i32 to i64
    %3 = arith.muli %2, %c4_i64 {spmd.executionKind = "All"} : i64
    %memref, %error_1 = "spmd.malloc"(%0, %3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, i64) -> (memref<?xi8>, !spmd.error)
    %4 = "polygeist.memref2pointer"(%memref) {spmd.executionKind = "All"} : (memref<?xi8>) -> !llvm.ptr
    %5 = arith.index_cast %size {spmd.executionKind = "All"} : i32 to index
    scf.for %arg2 = %c0 to %5 step %c1 {
      %11 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %12 = llvm.getelementptr %4[%11] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i32
      llvm.store %11, %12 {spmd.executionKind = "All"} : i32, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %6 = llvm.getelementptr %4[%rank] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i32
    %7 = llvm.load %6 {spmd.executionKind = "All"} : !llvm.ptr -> i32
    %8 = arith.cmpi sgt, %7, %c10_i32 {spmd.executionKind = "All"} : i32
    scf.if %8 {
      %error_2 = "spmd.barrier"(%0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %9 = "spmd.free"(%0, %memref) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>) -> !spmd.error
    %10 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

