module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c10_i32 = arith.constant {spmd.executionKind = "All"} 10 : i32
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c20_i32 = arith.constant {spmd.executionKind = "All"} 20 : i32
    %c3_i32 = arith.constant {spmd.executionKind = "All"} 3 : i32
    %c4_i32 = arith.constant {spmd.executionKind = "All"} 4 : i32
    %true = arith.constant {spmd.executionKind = "All"} true
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %3 = memref.get_global @"main@static@recvData" : memref<1xi32> {spmd.executionKind = "All"}
    %4 = memref.get_global @"main@static@sendData" : memref<1xi32> {spmd.executionKind = "All"}
    %5 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    %6 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi eq, %rank, %c3_i32 {spmd.executionKind = "All"} : i32
    %size, %error_0 = "spmd.getSizeOfComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %8 = arith.cmpi eq, %size, %c4_i32 {spmd.executionKind = "All"} : i32
    %9 = arith.cmpi ne, %size, %c4_i32 {spmd.executionKind = "All"} : i32
    %10 = arith.select %9, %c1_i32, %5 {spmd.executionKind = "All"} : i32
    scf.if %9 {
      %12 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %11 = arith.select %8, %c0_i32, %10 {spmd.executionKind = "All"} : i32
    scf.if %8 {
      %12 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
      %13 = scf.if %12 -> (i1) {
        scf.yield {spmd.executedBy = array<i32: 0, 1>, spmd.executionKind = "Static"} %true : i1
      } else {
        %19 = arith.cmpi eq, %rank, %c1_i32 {spmd.executedNotBy = array<i32: 0, 1>, spmd.executionKind = "AllBut"} : i32
        scf.yield {spmd.executedNotBy = array<i32: 0, 1>, spmd.executionKind = "AllBut"} %19 : i1
      } {spmd.executionKind = "All", spmd.isMultiValued = true}
      scf.if %13 {
        memref.store %c10_i32, %4[%c0] {spmd.executedBy = array<i32: 0, 1>, spmd.executionKind = "Static"} : memref<1xi32>
        %cast = memref.cast %3 {spmd.executedBy = array<i32: 0, 1>, spmd.executionKind = "Static"} : memref<1xi32> to memref<?xi32>
        %cast_1 = memref.cast %4 {spmd.executedBy = array<i32: 0, 1>, spmd.executionKind = "Static"} : memref<1xi32> to memref<?xi32>
        %error_2 = "spmd.allreduce"(%2, %cast_1, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executedBy = array<i32: 0, 1>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
      } {spmd.executionKind = "All", spmd.isMultiValued = true}
      %14 = arith.cmpi eq, %rank, %c2_i32 {spmd.executionKind = "All"} : i32
      %15 = arith.cmpi ne, %rank, %c2_i32 {spmd.executionKind = "All"} : i32
      %16 = arith.andi %15, %7 {spmd.executionKind = "All"} : i1
      %17 = arith.ori %14, %16 {spmd.executionKind = "All"} : i1
      scf.if %17 {
        memref.store %c20_i32, %4[%c0] {spmd.executedBy = array<i32: 2, 3>, spmd.executionKind = "Static"} : memref<1xi32>
        %cast = memref.cast %3 {spmd.executedBy = array<i32: 2, 3>, spmd.executionKind = "Static"} : memref<1xi32> to memref<?xi32>
        %cast_1 = memref.cast %4 {spmd.executedBy = array<i32: 2, 3>, spmd.executionKind = "Static"} : memref<1xi32> to memref<?xi32>
        %error_2 = "spmd.allreduce"(%2, %cast_1, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executedBy = array<i32: 2, 3>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
      } {spmd.executionKind = "All", spmd.isMultiValued = true}
      %18 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    return {spmd.executionKind = "All"} %11 : i32
  }
}

