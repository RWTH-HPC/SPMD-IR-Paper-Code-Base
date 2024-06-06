module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c128_i64 = arith.constant {spmd.executionKind = "All"} 128 : i64
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c3_i32 = arith.constant {spmd.executionKind = "All"} 3 : i32
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c128 = arith.constant {spmd.executionKind = "All"} 128 : index
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c4_i64 = arith.constant {spmd.executionKind = "All"} 4 : i64
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %3 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %4 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %5 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %6 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca_3 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_3 {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_4 = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    memref.store %4, %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %7 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %8 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %8 {
      %41 = func.call @ncclGetUniqueId(%cast) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %9 = "polygeist.memref2pointer"(%alloca_3) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %10 = "polygeist.pointer2memref"(%9) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_5 = "spmd.bcast"(%3, %10, %10, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %11 = call @cudaSetDevice(%c0_i32) {spmd.executionKind = "All"} : (i32) -> i32
    %12 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %13 = "polygeist.pointer2memref"(%12) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %14 = call @cudaMalloc(%13, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %15 = "polygeist.memref2pointer"(%alloca_1) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %17 = call @cudaMalloc(%16, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_6 = memref.cast %alloca_0 {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %18 = call @cudaStreamCreate(%cast_6) {spmd.executionKind = "All"} : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %19 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %41 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %42 = llvm.getelementptr %9[%41] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %43 = llvm.load %42 {spmd.executionKind = "All"} : !llvm.ptr -> i8
      %44 = llvm.getelementptr %19[%41] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %43, %44 {spmd.executionKind = "All"} : i8, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %20 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank_7, %error_8 = "spmd.getRankInComm"(%6) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %21 = arith.cmpi eq, %rank_7, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %21 {
      memref.store %c3_i32, %alloca_4[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32>
      %41 = memref.load %alloca_2[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %42 = "polygeist.memref2pointer"(%41) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %43 = "polygeist.pointer2memref"(%42) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %44 = func.call @cudaMemset(%43, %c3_i32, %c4_i64) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi8>, i32, i64) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %22 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %23 = "polygeist.memref2pointer"(%22) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %24 = "polygeist.pointer2memref"(%23) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_9 = "spmd.bcast"(%6, %24, %24, %c1_i64, %0, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
    %25 = arith.remsi %rank_7, %c2_i32 {spmd.executionKind = "All"} : i32
    %26 = arith.cmpi eq, %25, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %26 {
      %41 = memref.load %alloca_2[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %42 = "polygeist.memref2pointer"(%41) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %43 = "polygeist.pointer2memref"(%42) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %44 = memref.load %alloca_1[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %45 = "polygeist.memref2pointer"(%44) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %46 = "polygeist.pointer2memref"(%45) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %error_10 = "spmd.reduce"(%6, %43, %46, %c1_i64, %0, %2, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    } else {
      %41 = memref.load %alloca_2[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %42 = "polygeist.memref2pointer"(%41) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %43 = "polygeist.pointer2memref"(%42) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %error_10 = "spmd.bcast"(%6, %43, %43, %c1_i64, %0, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %27 = arith.cmpi eq, %rank_7, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %27 {
      %41 = "polygeist.memref2pointer"(%alloca_4) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<1xi32>) -> !llvm.ptr
      %42 = "polygeist.pointer2memref"(%41) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %43 = memref.load %alloca_1[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %44 = "polygeist.memref2pointer"(%43) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %45 = "polygeist.pointer2memref"(%44) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %46 = func.call @cudaMemcpy(%42, %45, %c4_i64, %c2_i32) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %47 = memref.load %alloca_2[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %48 = "polygeist.memref2pointer"(%47) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %49 = "polygeist.pointer2memref"(%48) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %50 = memref.load %alloca_4[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xi32>
      %51 = func.call @cudaMemset(%49, %50, %c4_i64) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi8>, i32, i64) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %28 = arith.remsi %rank_7, %c2_i32 {spmd.executionKind = "All"} : i32
    %29 = arith.cmpi eq, %28, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %29 {
      %41 = memref.load %alloca_2[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %42 = "polygeist.memref2pointer"(%41) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %43 = "polygeist.pointer2memref"(%42) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %error_10 = "spmd.bcast"(%6, %43, %43, %c1_i64, %0, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
    } else {
      %41 = memref.load %alloca_2[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %42 = "polygeist.memref2pointer"(%41) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %43 = "polygeist.pointer2memref"(%42) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %44 = memref.load %alloca_1[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %45 = "polygeist.memref2pointer"(%44) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %46 = "polygeist.pointer2memref"(%45) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %error_10 = "spmd.reduce"(%6, %43, %46, %c1_i64, %0, %2, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %30 = memref.load %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %31 = call @cudaStreamSynchronize(%30) {spmd.executionKind = "All"} : (memref<?x!llvm.struct<()>>) -> i32
    %32 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %33 = "polygeist.memref2pointer"(%32) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %34 = "polygeist.pointer2memref"(%33) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %35 = call @cudaFree(%34) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %36 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %37 = "polygeist.memref2pointer"(%36) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %38 = "polygeist.pointer2memref"(%37) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %39 = call @cudaFree(%38) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %40 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
}

