module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>> {spmd.executionKind = "All"}
  memref.global "private" @"main@static@sendData@init" : memref<1xi1> = dense<true> {spmd.executionKind = "All"}
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c42_i32 = arith.constant {spmd.executionKind = "All"} 42 : i32
    %c13_i32 = arith.constant {spmd.executionKind = "All"} 13 : i32
    %false = arith.constant {spmd.executionKind = "All"} false
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %3 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %4 = memref.get_global @"main@static@sendData" : memref<1xi32> {spmd.executionKind = "All"}
    %5 = memref.get_global @"main@static@recvData" : memref<1xi32> {spmd.executionKind = "All"}
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    memref.store %c42_i32, %alloca[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %6 = memref.get_global @"main@static@sendData@init" : memref<1xi1> {spmd.executionKind = "All"}
    %7 = memref.load %6[%c0] {spmd.executionKind = "All"} : memref<1xi1>
    scf.if %7 {
      memref.store %false, %6[%c0] {spmd.executionKind = "All"} : memref<1xi1>
      memref.store %c13_i32, %4[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %8 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %9 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %10 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %rank, %error = "spmd.getRankInComm"(%10) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %11 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %11 {
      %14 = "polygeist.memref2pointer"(%alloca) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<1xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %error_2 = "spmd.bcast"(%10, %15, %15, %c1_i64, %3, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %cast = memref.cast %5 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32> to memref<?xi32>
      %cast_3 = memref.cast %4 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32> to memref<?xi32>
      %error_4 = "spmd.allreduce"(%2, %cast_3, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    } else {
      %14 = "polygeist.memref2pointer"(%alloca) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<1xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %error_2 = "spmd.bcast"(%10, %15, %15, %c1_i64, %3, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %cast = memref.cast %5 {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xi32> to memref<?xi32>
      %cast_3 = memref.cast %4 {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xi32> to memref<?xi32>
      %error_4 = "spmd.allreduce"(%2, %cast_3, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %error_0 = "spmd.barrier"(%10) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> !spmd.error
    %error_1 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> !spmd.error
    %12 = "spmd.finalize"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %13 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

