module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c128_i64 = arith.constant {spmd.executionKind = "All"} 128 : i64
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c42_i32 = arith.constant {spmd.executionKind = "All"} 42 : i32
    %c8_i32 = arith.constant {spmd.executionKind = "All"} 8 : i32
    %c13_i32 = arith.constant {spmd.executionKind = "All"} 13 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c128 = arith.constant {spmd.executionKind = "All"} 128 : index
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c4_i64 = arith.constant {spmd.executionKind = "All"} 4 : i64
    %c0_i64 = arith.constant {spmd.executionKind = "All"} 0 : i64
    %c21_i32 = arith.constant {spmd.executionKind = "All"} 21 : i32
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %3 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %4 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %alloca_4 = memref.alloca() {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %5 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca_5 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_5 {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_6 = memref.alloca() {spmd.executionKind = "All"} : memref<1xi32>
    %6 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    memref.store %6, %alloca_6[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %7 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %8 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %8 {
      %75 = func.call @ncclGetUniqueId(%cast) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %9 = "polygeist.memref2pointer"(%alloca_5) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %10 = "polygeist.pointer2memref"(%9) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_7 = "spmd.bcast"(%3, %10, %10, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %11 = call @cudaSetDevice(%c0_i32) {spmd.executionKind = "All"} : (i32) -> i32
    %12 = "polygeist.memref2pointer"(%alloca_4) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %13 = "polygeist.pointer2memref"(%12) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %14 = call @cudaMalloc(%13, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %15 = memref.load %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %16 = "polygeist.memref2pointer"(%15) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %17 = "polygeist.pointer2memref"(%16) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %18 = call @cudaMemset(%17, %c42_i32, %c4_i64) {spmd.executionKind = "All"} : (memref<?xi8>, i32, i64) -> i32
    %19 = "polygeist.memref2pointer"(%alloca_3) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %20 = "polygeist.pointer2memref"(%19) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %21 = call @cudaMalloc(%20, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %22 = memref.load %alloca_3[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %23 = "polygeist.memref2pointer"(%22) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %24 = "polygeist.pointer2memref"(%23) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %25 = call @cudaMemset(%24, %c8_i32, %c4_i64) {spmd.executionKind = "All"} : (memref<?xi8>, i32, i64) -> i32
    %26 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %27 = "polygeist.pointer2memref"(%26) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %28 = call @cudaMalloc(%27, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %29 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %30 = "polygeist.memref2pointer"(%29) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %31 = "polygeist.pointer2memref"(%30) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %32 = call @cudaMemset(%31, %c13_i32, %c4_i64) {spmd.executionKind = "All"} : (memref<?xi8>, i32, i64) -> i32
    %33 = "polygeist.memref2pointer"(%alloca_1) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %34 = "polygeist.pointer2memref"(%33) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %35 = call @cudaMalloc(%34, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_8 = memref.cast %alloca_0 {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %36 = call @cudaStreamCreate(%cast_8) {spmd.executionKind = "All"} : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %37 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %75 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %76 = llvm.getelementptr %9[%75] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %77 = llvm.load %76 {spmd.executionKind = "All"} : !llvm.ptr -> i8
      %78 = llvm.getelementptr %37[%75] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %77, %78 {spmd.executionKind = "All"} : i8, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %38 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %39 = memref.load %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %40 = "polygeist.memref2pointer"(%39) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %41 = "polygeist.pointer2memref"(%40) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %42 = memref.load %alloca_3[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %43 = "polygeist.memref2pointer"(%42) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %44 = "polygeist.pointer2memref"(%43) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_9 = "spmd.allreduce"(%5, %41, %44, %c1_i64, %0, %2, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
    %45 = "polygeist.memref2pointer"(%alloca_6) {spmd.executionKind = "All"} : (memref<1xi32>) -> !llvm.ptr
    %46 = "polygeist.pointer2memref"(%45) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %47 = memref.load %alloca_3[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %48 = "polygeist.memref2pointer"(%47) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %49 = "polygeist.pointer2memref"(%48) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %50 = call @cudaMemcpy(%46, %49, %c4_i64, %c2_i32) {spmd.executionKind = "All"} : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
    %51 = memref.load %alloca_6[%c0] {spmd.executionKind = "All"} : memref<1xi32>
    %52 = arith.cmpi eq, %51, %c21_i32 {spmd.executionKind = "All"} : i32
    scf.if %52 {
      %75 = memref.load %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %76 = "polygeist.memref2pointer"(%75) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %77 = "polygeist.pointer2memref"(%76) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.bcast"(%5, %77, %77, %c1_i64, %0, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
      %78 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %79 = "polygeist.memref2pointer"(%78) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %80 = "polygeist.pointer2memref"(%79) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %81 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %82 = "polygeist.memref2pointer"(%81) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %83 = "polygeist.pointer2memref"(%82) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %error_12 = "spmd.reduce"(%5, %80, %83, %c1_i64, %0, %2, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    } else {
      %75 = memref.load %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %76 = "polygeist.memref2pointer"(%75) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %77 = "polygeist.pointer2memref"(%76) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.bcast"(%5, %77, %77, %c1_i64, %0, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
      %78 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %79 = "polygeist.memref2pointer"(%78) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %80 = "polygeist.pointer2memref"(%79) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %81 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
      %82 = "polygeist.memref2pointer"(%81) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
      %83 = "polygeist.pointer2memref"(%82) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
      %error_12 = "spmd.reduce"(%5, %80, %83, %c1_i64, %0, %2, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %53 = memref.load %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %54 = "polygeist.memref2pointer"(%53) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %55 = "polygeist.pointer2memref"(%54) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_10 = "spmd.allgather"(%5, %55, %c0_i64, %0, %55, %c0_i64, %0, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    %56 = memref.load %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %57 = call @cudaStreamSynchronize(%56) {spmd.executionKind = "All"} : (memref<?x!llvm.struct<()>>) -> i32
    %58 = memref.load %alloca_4[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %59 = "polygeist.memref2pointer"(%58) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %60 = "polygeist.pointer2memref"(%59) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %61 = call @cudaFree(%60) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %62 = memref.load %alloca_3[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %63 = "polygeist.memref2pointer"(%62) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %64 = "polygeist.pointer2memref"(%63) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %65 = call @cudaFree(%64) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %66 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %67 = "polygeist.memref2pointer"(%66) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %68 = "polygeist.pointer2memref"(%67) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %69 = call @cudaFree(%68) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %70 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %71 = "polygeist.memref2pointer"(%70) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %72 = "polygeist.pointer2memref"(%71) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %73 = call @cudaFree(%72) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %74 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
}

