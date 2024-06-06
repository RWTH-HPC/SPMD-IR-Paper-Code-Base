module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  llvm.mlir.global internal constant @str3("total sum is %d\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.mlir.global internal constant @str2("process %d exits barrier\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.mlir.global internal constant @str1("process %d enters barrier\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.mlir.global internal constant @str0("process %d has local sum of %d\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.func @printf(!llvm.ptr, ...) -> i32 attributes {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %3 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    memref.store %3, %alloca[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    memref.store %3, %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %4 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    memref.store %c0_i32, %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %5 = arith.addi %rank, %c1_i32 {spmd.executionKind = "All"} : i32
    %6 = arith.index_cast %5 {spmd.executionKind = "All"} : i32 to index
    %7 = scf.for %arg2 = %c0 to %6 step %c1 iter_args(%arg3 = %c0_i32) -> (i32) {
      %15 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %16 = arith.addi %arg3, %15 {spmd.executionKind = "All"} : i32
      memref.store %16, %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xi32>
      scf.yield {spmd.executionKind = "All"} %16 : i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %8 = llvm.mlir.addressof @str0 {spmd.executionKind = "All"} : !llvm.ptr
    %9 = llvm.getelementptr %8[0, 0] {spmd.executionKind = "All"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<32 x i8>
    %10 = llvm.call @printf(%9, %rank, %7) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "All"} : (!llvm.ptr, i32, i32) -> i32
    %11 = arith.remsi %rank, %c2_i32 {spmd.executionKind = "All"} : i32
    %12 = arith.cmpi ne, %11, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %12 {
      %15 = llvm.mlir.addressof @str1 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %16 = llvm.getelementptr %15[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %17 = llvm.call @printf(%16, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
      %error_1 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
      %18 = llvm.mlir.addressof @str2 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %19 = llvm.getelementptr %18[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %20 = llvm.call @printf(%19, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
      %21 = "polygeist.memref2pointer"(%alloca_0) {spmd.executionKind = "Dynamic"} : (memref<1xi32>) -> !llvm.ptr
      %22 = "polygeist.pointer2memref"(%21) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %23 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "Dynamic"} : (memref<1xi32>) -> !llvm.ptr
      %24 = "polygeist.pointer2memref"(%23) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %error_2 = "spmd.reduce"(%2, %22, %24, %c1_i64, %1, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
    } else {
      %15 = "polygeist.memref2pointer"(%alloca_0) {spmd.executionKind = "Dynamic"} : (memref<1xi32>) -> !llvm.ptr
      %16 = "polygeist.pointer2memref"(%15) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %17 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "Dynamic"} : (memref<1xi32>) -> !llvm.ptr
      %18 = "polygeist.pointer2memref"(%17) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %error_1 = "spmd.reduce"(%2, %16, %18, %c1_i64, %1, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32) -> !spmd.error
      %19 = llvm.mlir.addressof @str1 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %20 = llvm.getelementptr %19[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %21 = llvm.call @printf(%20, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
      %error_2 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
      %22 = llvm.mlir.addressof @str2 {spmd.executionKind = "Dynamic"} : !llvm.ptr
      %23 = llvm.getelementptr %22[0, 0] {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %24 = llvm.call @printf(%23, %rank) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "Dynamic"} : (!llvm.ptr, i32) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %13 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %13 {
      %15 = llvm.mlir.addressof @str3 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : !llvm.ptr
      %16 = llvm.getelementptr %15[0, 0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<17 x i8>
      %17 = memref.load %alloca[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32>
      %18 = llvm.call @printf(%16, %17) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr, i32) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %14 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

