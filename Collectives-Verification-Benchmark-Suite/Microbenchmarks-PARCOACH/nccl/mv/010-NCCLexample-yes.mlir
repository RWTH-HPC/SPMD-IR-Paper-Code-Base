module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c128_i64 = arith.constant {spmd.executionKind = "All"} 128 : i64
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c0_i64 = arith.constant {spmd.executionKind = "All"} 0 : i64
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c12_i32 = arith.constant {spmd.executionKind = "All"} 12 : i32
    %c256_i32 = arith.constant {spmd.executionKind = "All"} 256 : i32
    %c4_i64 = arith.constant {spmd.executionKind = "All"} 4 : i64
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c128 = arith.constant {spmd.executionKind = "All"} 128 : index
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %3 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %4 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %5 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %cast = memref.cast %alloca_0 {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %alloca_1 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %6 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca_2 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast_3 = memref.cast %alloca_2 {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %rank, %error = "spmd.getRankInComm"(%0) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %7 {
      %29 = func.call @ncclGetUniqueId(%cast_3) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %8 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %9 = "polygeist.pointer2memref"(%8) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_4 = "spmd.bcast"(%0, %9, %9, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %10 = call @cudaSetDevice(%c0_i32) {spmd.executionKind = "All"} : (i32) -> i32
    %11 = "polygeist.memref2pointer"(%alloca_1) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %12 = "polygeist.pointer2memref"(%11) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %13 = call @cudaMalloc(%12, %c0_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %14 = call @cudaStreamCreate(%cast) {spmd.executionKind = "All"} : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %15 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %29 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %30 = llvm.getelementptr %8[%29] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %31 = llvm.load %30 {spmd.executionKind = "All"} : !llvm.ptr -> i8
      %32 = llvm.getelementptr %15[%29] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %31, %32 {spmd.executionKind = "All"} : i8, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %16 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank_5, %error_6 = "spmd.getRankInComm"(%6) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %size, %error_7 = "spmd.getSizeOfComm"(%6) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %17 = arith.remsi %rank_5, %c2_i32 {spmd.executionKind = "All"} : i32
    %18 = arith.cmpi ne, %17, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %18 {
      %alloca_9 = memref.alloca() {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %alloca_10 = memref.alloca() {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %29 = "polygeist.memref2pointer"(%alloca_10) {spmd.executionKind = "Dynamic"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
      %30 = "polygeist.pointer2memref"(%29) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
      %31 = func.call @cudaMalloc(%30, %c4_i64) {spmd.executionKind = "Dynamic"} : (memref<?xmemref<?xi8>>, i64) -> i32
      %32 = "polygeist.memref2pointer"(%alloca_9) {spmd.executionKind = "Dynamic"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
      %33 = "polygeist.pointer2memref"(%32) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
      %34 = func.call @cudaMalloc(%33, %c4_i64) {spmd.executionKind = "Dynamic"} : (memref<?xmemref<?xi8>>, i64) -> i32
      %35 = memref.load %alloca_10[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %36 = "polygeist.memref2pointer"(%35) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %37 = "polygeist.pointer2memref"(%36) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %38 = func.call @cudaMemset(%37, %c0_i32, %c4_i64) {spmd.executionKind = "Dynamic"} : (memref<?xi8>, i32, i64) -> i32
      %39 = memref.load %alloca_9[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %40 = "polygeist.memref2pointer"(%39) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %41 = "polygeist.pointer2memref"(%40) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %42 = func.call @cudaMemset(%41, %c12_i32, %c4_i64) {spmd.executionKind = "Dynamic"} : (memref<?xi8>, i32, i64) -> i32
      %43 = arith.cmpi sgt, %size, %c256_i32 {spmd.executionKind = "Dynamic"} : i32
      scf.if %43 {
        %52 = "polygeist.pointer2memref"(%29) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
        %53 = "polygeist.pointer2memref"(%32) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
        %error_11 = "spmd.reduce"(%6, %52, %53, %c1_i64, %2, %3, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
      } {spmd.executionKind = "Dynamic", spmd.isMultiValued = false}
      %44 = memref.load %alloca_10[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %45 = "polygeist.memref2pointer"(%44) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %46 = "polygeist.pointer2memref"(%45) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %47 = func.call @cudaFree(%46) {spmd.executionKind = "Dynamic"} : (memref<?xi8>) -> i32
      %48 = memref.load %alloca_9[%c0] {spmd.executionKind = "Dynamic"} : memref<1xmemref<?xi32>>
      %49 = "polygeist.memref2pointer"(%48) {spmd.executionKind = "Dynamic"} : (memref<?xi32>) -> !llvm.ptr
      %50 = "polygeist.pointer2memref"(%49) {spmd.executionKind = "Dynamic"} : (!llvm.ptr) -> memref<?xi8>
      %51 = func.call @cudaFree(%50) {spmd.executionKind = "Dynamic"} : (memref<?xi8>) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %19 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %20 = "polygeist.memref2pointer"(%19) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %21 = "polygeist.pointer2memref"(%20) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_8 = "spmd.allgather"(%6, %21, %c0_i64, %2, %21, %c0_i64, %2, %5) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    %22 = memref.load %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %23 = call @cudaStreamSynchronize(%22) {spmd.executionKind = "All"} : (memref<?x!llvm.struct<()>>) -> i32
    %24 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %25 = "polygeist.memref2pointer"(%24) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %26 = "polygeist.pointer2memref"(%25) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %27 = call @cudaFree(%26) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %28 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
}

