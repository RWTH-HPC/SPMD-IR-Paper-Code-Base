module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c8_i32 = arith.constant {spmd.executionKind = "All"} 8 : i32
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c21_i32 = arith.constant {spmd.executionKind = "All"} 21 : i32
    %c42_i32 = arith.constant {spmd.executionKind = "All"} 42 : i32
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    %3 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    memref.store %3, %alloca[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    memref.store %c8_i32, %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %4 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %5 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1xi32>) -> !llvm.ptr
    %6 = "polygeist.pointer2memref"(%5) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %7 = "polygeist.memref2pointer"(%alloca_0) {spmd.executionKind = "All"} : (memref<1xi32>) -> !llvm.ptr
    %8 = "polygeist.pointer2memref"(%7) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_1 = "spmd.allreduce"(%2, %6, %8, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    %9 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %9 {
      memref.store %c42_i32, %alloca[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32>
      %error_3 = "spmd.bcast"(%2, %6, %6, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    } else {
      %11 = memref.load %alloca_0[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xi32>
      %12 = arith.cmpi eq, %11, %c21_i32 {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : i32
      scf.if %12 {
        %error_3 = "spmd.bcast"(%2, %6, %6, %c1_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      } {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut", spmd.isMultiValued = false}
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %error_2 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> !spmd.error
    %10 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

