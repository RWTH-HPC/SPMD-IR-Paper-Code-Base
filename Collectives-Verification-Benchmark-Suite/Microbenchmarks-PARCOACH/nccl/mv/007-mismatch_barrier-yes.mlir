module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  llvm.mlir.global internal constant @str0("This test needs at least 2 MPI processes\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.func @printf(!llvm.ptr, ...) -> i32 attributes {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c128_i64 = arith.constant {spmd.executionKind = "All"} 128 : i64
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c128 = arith.constant {spmd.executionKind = "All"} 128 : index
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c0_i64 = arith.constant {spmd.executionKind = "All"} 0 : i64
    %0 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %3 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %4 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %5 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca_2 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_2 {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %6 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %size, %error_3 = "spmd.getSizeOfComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi slt, %size, %c2_i32 {spmd.executionKind = "All"} : i32
    %8 = arith.cmpi sge, %size, %c2_i32 {spmd.executionKind = "All"} : i32
    %9 = arith.select %7, %c1_i32, %3 {spmd.executionKind = "All"} : i32
    scf.if %7 {
      %11 = llvm.mlir.addressof @str0 {spmd.executionKind = "All"} : !llvm.ptr
      %12 = llvm.getelementptr %11[0, 0] {spmd.executionKind = "All"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<42 x i8>
      %13 = llvm.call @printf(%12) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "All"} : (!llvm.ptr) -> i32
      %14 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %10 = arith.select %8, %c0_i32, %9 {spmd.executionKind = "All"} : i32
    scf.if %8 {
      %11 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
      scf.if %11 {
        %31 = func.call @ncclGetUniqueId(%cast) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
      } {spmd.executionKind = "All", spmd.isMultiValued = true}
      %12 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %error_4 = "spmd.bcast"(%2, %13, %13, %c128_i64, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %14 = func.call @cudaSetDevice(%c0_i32) {spmd.executionKind = "All"} : (i32) -> i32
      %15 = "polygeist.memref2pointer"(%alloca_1) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
      %16 = "polygeist.pointer2memref"(%15) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
      %17 = func.call @cudaMalloc(%16, %c0_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
      %cast_5 = memref.cast %alloca_0 {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
      %18 = func.call @cudaStreamCreate(%cast_5) {spmd.executionKind = "All"} : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
      %19 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
      %20 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
      scf.for %arg2 = %c0 to %c128 step %c1 {
        %31 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
        %32 = llvm.getelementptr %20[%31] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
        %33 = llvm.load %32 {spmd.executionKind = "All"} : !llvm.ptr -> i8
        %34 = llvm.getelementptr %19[%31] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
        llvm.store %33, %34 {spmd.executionKind = "All"} : i8, !llvm.ptr
      } {spmd.executionKind = "All", spmd.isMultiValued = false}
      %21 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
      %rank_6, %error_7 = "spmd.getRankInComm"(%5) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
      %22 = arith.remsi %rank_6, %c2_i32 {spmd.executionKind = "All"} : i32
      %23 = arith.cmpi ne, %22, %c0_i32 {spmd.executionKind = "All"} : i32
      scf.if %23 {
        %31 = memref.load %alloca_1[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
        %32 = "polygeist.memref2pointer"(%31) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
        %33 = "polygeist.pointer2memref"(%32) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
        %error_8 = "spmd.allgather"(%5, %33, %c0_i64, %1, %33, %c0_i64, %1, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
      } {spmd.executionKind = "All", spmd.isMultiValued = true}
      %24 = memref.load %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
      %25 = func.call @cudaStreamSynchronize(%24) {spmd.executionKind = "All"} : (memref<?x!llvm.struct<()>>) -> i32
      %26 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %27 = "polygeist.memref2pointer"(%26) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %28 = "polygeist.pointer2memref"(%27) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %29 = func.call @cudaFree(%28) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
      %30 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    return {spmd.executionKind = "All"} %10 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
}

