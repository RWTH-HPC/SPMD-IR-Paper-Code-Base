module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c128_i64 = arith.constant {spmd.executionKind = "All"} 128 : i64
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c42_i32 = arith.constant {spmd.executionKind = "All"} 42 : i32
    %c0_i64 = arith.constant {spmd.executionKind = "All"} 0 : i64
    %c4_i64 = arith.constant {spmd.executionKind = "All"} 4 : i64
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c128 = arith.constant {spmd.executionKind = "All"} 128 : index
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %0 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %3 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %4 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %5 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca_2 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_2 {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %6 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %7 {
      %25 = func.call @ncclGetUniqueId(%cast) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %8 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %9 = "polygeist.pointer2memref"(%8) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_3 = "spmd.bcast"(%3, %9, %9, %c128_i64, %2, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %10 = call @cudaSetDevice(%c0_i32) {spmd.executionKind = "All"} : (i32) -> i32
    %cast_4 = memref.cast %alloca_0 {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %11 = call @cudaStreamCreate(%cast_4) {spmd.executionKind = "All"} : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %12 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %25 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %26 = llvm.getelementptr %8[%25] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %27 = llvm.load %26 {spmd.executionKind = "All"} : !llvm.ptr -> i8
      %28 = llvm.getelementptr %12[%25] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %27, %28 {spmd.executionKind = "All"} : i8, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %13 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank_5, %error_6 = "spmd.getRankInComm"(%5) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %14 = arith.cmpi eq, %rank_5, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %14 {
      %25 = memref.load %alloca_1[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %26 = "polygeist.memref2pointer"(%25) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %27 = "polygeist.pointer2memref"(%26) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %28 = func.call @cudaMemset(%27, %c42_i32, %c4_i64) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi8>, i32, i64) -> i32
      %29 = memref.load %alloca_1[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %30 = "polygeist.memref2pointer"(%29) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %31 = "polygeist.pointer2memref"(%30) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %error_8 = "spmd.bcast"(%5, %31, %31, %c1_i64, %1, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %15 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %16 = "polygeist.memref2pointer"(%15) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %17 = "polygeist.pointer2memref"(%16) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_7 = "spmd.allgather"(%5, %17, %c0_i64, %1, %17, %c0_i64, %1, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    %18 = memref.load %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %19 = call @cudaStreamSynchronize(%18) {spmd.executionKind = "All"} : (memref<?x!llvm.struct<()>>) -> i32
    %20 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %21 = "polygeist.memref2pointer"(%20) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %22 = "polygeist.pointer2memref"(%21) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %23 = "spmd.free"(%0, %22) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>) -> !spmd.error
    %24 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
}

