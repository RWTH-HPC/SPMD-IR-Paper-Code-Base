module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  llvm.mlir.global internal constant @str3("total sum is %d\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.mlir.global internal constant @str2("process %d exits barrier\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.mlir.global internal constant @str1("process %d enters barrier\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.mlir.global internal constant @str0("process %d has local sum of %d\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.func @printf(!llvm.ptr, ...) -> i32 attributes {spmd.executionKind = "All"}
  memref.global "private" @"main@static@sum" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  memref.global "private" @"main@static@localsum" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %3 = memref.get_global @"main@static@sum" : memref<1xi32> {spmd.executionKind = "All"}
    %4 = memref.get_global @"main@static@localsum" : memref<1xi32> {spmd.executionKind = "All"}
    %5 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    memref.store %c0_i32, %4[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %6 = arith.addi %rank, %c1_i32 {spmd.executionKind = "All"} : i32
    %7 = arith.index_cast %6 {spmd.executionKind = "All"} : i32 to index
    %8 = scf.for %arg2 = %c0 to %7 step %c1 iter_args(%arg3 = %c0_i32) -> (i32) {
      %16 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %17 = arith.addi %arg3, %16 {spmd.executionKind = "All"} : i32
      memref.store %17, %4[%c0] {spmd.executionKind = "All"} : memref<1xi32>
      scf.yield {spmd.executionKind = "All"} %17 : i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %9 = llvm.mlir.addressof @str0 {spmd.executionKind = "All"} : !llvm.ptr
    %10 = llvm.getelementptr %9[0, 0] {spmd.executionKind = "All"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<32 x i8>
    %11 = llvm.call @printf(%10, %rank, %8) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "All"} : (!llvm.ptr, i32, i32) -> i32
    %12 = arith.remsi %rank, %c2_i32 {spmd.executionKind = "All"} : i32
    %13 = arith.cmpi ne, %12, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %13 {
      %16 = llvm.mlir.addressof @str1 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %18 = llvm.call @printf(%17, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
      %error_0 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
      %19 = llvm.mlir.addressof @str2 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %20 = llvm.getelementptr %19[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %21 = llvm.call @printf(%20, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
      %cast = memref.cast %3 {spmd.executionKind = "Dynamic"} : memref<1xi32> to memref<?xi32>
      %cast_1 = memref.cast %4 {spmd.executionKind = "Dynamic"} : memref<1xi32> to memref<?xi32>
      %error_2 = "spmd.allreduce"(%2, %cast_1, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
    } else {
      %cast = memref.cast %3 {spmd.executionKind = "Dynamic"} : memref<1xi32> to memref<?xi32>
      %cast_0 = memref.cast %4 {spmd.executionKind = "Dynamic"} : memref<1xi32> to memref<?xi32>
      %error_1 = "spmd.allreduce"(%2, %cast_0, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
      %16 = llvm.mlir.addressof @str1 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %18 = llvm.call @printf(%17, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
      %error_2 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
      %19 = llvm.mlir.addressof @str2 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %20 = llvm.getelementptr %19[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %21 = llvm.call @printf(%20, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %14 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %14 {
      %16 = llvm.mlir.addressof @str3 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<17 x i8>
      %18 = memref.load %3[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32>
      %19 = llvm.call @printf(%17, %18) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr, i32) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %15 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

