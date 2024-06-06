module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  llvm.mlir.global internal constant @str0("process %d with device %d receives %d\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.func @printf(!llvm.ptr, ...) -> i32 attributes {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c128_i64 = arith.constant {spmd.executionKind = "All"} 128 : i64
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c128 = arith.constant {spmd.executionKind = "All"} 128 : index
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c1 = arith.constant {spmd.executionKind = "All"} 1 : index
    %c4 = arith.constant {spmd.executionKind = "All"} 4 : index
    %c4_i64 = arith.constant {spmd.executionKind = "All"} 4 : i64
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
    %5 = "spmd.commWorld"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca_4 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_4 {spmd.executionKind = "All"} : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %6 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %rank, %error_5 = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.extsi %size {spmd.executionKind = "All"} : i32 to i64
    %8 = arith.muli %7, %c4_i64 {spmd.executionKind = "All"} : i64
    %9 = arith.index_cast %8 {spmd.executionKind = "All"} : i64 to index
    %10 = arith.divui %9, %c4 {spmd.executionKind = "All"} : index
    %alloc = memref.alloc(%10) {spmd.executionKind = "All"} : memref<?xi32>
    %alloc_6 = memref.alloc() {spmd.executionKind = "All"} : memref<1xi32>
    %11 = arith.cmpi eq, %rank, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %11 {
      %47 = func.call @ncclGetUniqueId(%cast) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %12 = "polygeist.memref2pointer"(%alloca_4) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %13 = "polygeist.pointer2memref"(%12) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %error_7 = "spmd.bcast"(%3, %13, %13, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %14 = call @cudaSetDevice(%c0_i32) {spmd.executionKind = "All"} : (i32) -> i32
    %15 = arith.extsi %size {spmd.executionKind = "All"} : i32 to i64
    %16 = arith.muli %15, %c4_i64 {spmd.executionKind = "All"} : i64
    %17 = "polygeist.memref2pointer"(%alloca_3) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %18 = "polygeist.pointer2memref"(%17) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %19 = call @cudaMalloc(%18, %16) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %20 = arith.extsi %size {spmd.executionKind = "All"} : i32 to i64
    %21 = arith.muli %20, %c4_i64 {spmd.executionKind = "All"} : i64
    %22 = "polygeist.memref2pointer"(%alloca_2) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %23 = "polygeist.pointer2memref"(%22) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %24 = call @cudaMalloc(%23, %21) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %25 = "polygeist.memref2pointer"(%alloca_1) {spmd.executionKind = "All"} : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %26 = "polygeist.pointer2memref"(%25) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %27 = call @cudaMalloc(%26, %c4_i64) {spmd.executionKind = "All"} : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_8 = memref.cast %alloca_0 {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %28 = call @cudaStreamCreate(%cast_8) {spmd.executionKind = "All"} : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %29 = "polygeist.memref2pointer"(%alloca) {spmd.executionKind = "All"} : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %47 = arith.index_cast %arg2 {spmd.executionKind = "All"} : index to i32
      %48 = llvm.getelementptr %12[%47] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %49 = llvm.load %48 {spmd.executionKind = "All"} : !llvm.ptr -> i8
      %50 = llvm.getelementptr %29[%47] {spmd.executionKind = "All"} : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %49, %50 {spmd.executionKind = "All"} : i8, !llvm.ptr
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %30 = "spmd.init"() <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank_9, %error_10 = "spmd.getRankInComm"(%5) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %device, %error_11 = "spmd.getDeviceInComm"(%5) <{usedModel = 1 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %31 = arith.cmpi eq, %rank_9, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %31 {
      %47 = arith.index_cast %size {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32 to index
      scf.for %arg2 = %c0 to %47 step %c1 {
        %70 = arith.index_cast %arg2 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : index to i32
        %71 = arith.subi %size, %70 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32
        memref.store %71, %alloc[%arg2] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<?xi32>
      } {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static", spmd.isMultiValued = false}
      %48 = memref.load %alloca_3[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %49 = "polygeist.memref2pointer"(%48) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %50 = "polygeist.pointer2memref"(%49) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %51 = "polygeist.memref2pointer"(%alloc) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %52 = "polygeist.pointer2memref"(%51) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %53 = arith.extsi %size {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32 to i64
      %54 = arith.muli %53, %c4_i64 {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i64
      %55 = func.call @cudaMemcpy(%50, %52, %54, %c1_i32) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %56 = memref.load %alloca_3[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %59 = memref.load %alloca_2[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %60 = "polygeist.memref2pointer"(%59) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %61 = "polygeist.pointer2memref"(%60) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %62 = arith.extsi %size {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32 to i64
      %error_12 = "spmd.allreduce"(%5, %58, %61, %62, %0, %2, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
      %63 = memref.load %alloca_3[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %64 = "polygeist.memref2pointer"(%63) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %65 = "polygeist.pointer2memref"(%64) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %66 = memref.load %alloca_1[%c0] {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : memref<1xmemref<?xi32>>
      %67 = "polygeist.memref2pointer"(%66) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (memref<?xi32>) -> !llvm.ptr
      %68 = "polygeist.pointer2memref"(%67) {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!llvm.ptr) -> memref<?xi8>
      %69 = arith.extsi %size {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : i32 to i64
      %error_13 = "spmd.reduceScatter"(%5, %65, %68, %69, %0, %2, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedBy = array<i32: 0>, spmd.executionKind = "Static"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
    } else {
      %47 = memref.load %alloca_3[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xmemref<?xi32>>
      %48 = "polygeist.memref2pointer"(%47) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<?xi32>) -> !llvm.ptr
      %49 = "polygeist.pointer2memref"(%48) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %50 = memref.load %alloca_1[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xmemref<?xi32>>
      %51 = "polygeist.memref2pointer"(%50) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<?xi32>) -> !llvm.ptr
      %52 = "polygeist.pointer2memref"(%51) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %53 = arith.extsi %size {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : i32 to i64
      %error_12 = "spmd.reduceScatter"(%5, %49, %52, %53, %0, %2, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
      %54 = memref.load %alloca_3[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xmemref<?xi32>>
      %55 = "polygeist.memref2pointer"(%54) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<?xi32>) -> !llvm.ptr
      %56 = "polygeist.pointer2memref"(%55) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %57 = memref.load %alloca_2[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xmemref<?xi32>>
      %58 = "polygeist.memref2pointer"(%57) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<?xi32>) -> !llvm.ptr
      %59 = "polygeist.pointer2memref"(%58) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %60 = arith.extsi %size {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : i32 to i64
      %error_13 = "spmd.allreduce"(%5, %56, %59, %60, %0, %2, %4) <{isBlocking = true, usedModel = 1 : i32}> {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
      %61 = "polygeist.memref2pointer"(%alloc_6) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<1xi32>) -> !llvm.ptr
      %62 = "polygeist.pointer2memref"(%61) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %63 = memref.load %alloca_1[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xmemref<?xi32>>
      %64 = "polygeist.memref2pointer"(%63) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<?xi32>) -> !llvm.ptr
      %65 = "polygeist.pointer2memref"(%64) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> memref<?xi8>
      %66 = func.call @cudaMemcpy(%62, %65, %c4_i64, %c2_i32) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %67 = llvm.mlir.addressof @str0 {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : !llvm.ptr
      %68 = llvm.getelementptr %67[0, 0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<39 x i8>
      %69 = memref.load %alloc_6[%c0] {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : memref<1xi32>
      %70 = llvm.call @printf(%68, %rank_9, %device, %69) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executedNotBy = array<i32: 0>, spmd.executionKind = "AllBut"} : (!llvm.ptr, i32, i32, i32) -> i32
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %32 = memref.load %alloca_0[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?x!llvm.struct<()>>>
    %33 = call @cudaStreamSynchronize(%32) {spmd.executionKind = "All"} : (memref<?x!llvm.struct<()>>) -> i32
    %34 = memref.load %alloca_3[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %35 = "polygeist.memref2pointer"(%34) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %36 = "polygeist.pointer2memref"(%35) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %37 = call @cudaFree(%36) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %38 = memref.load %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %39 = "polygeist.memref2pointer"(%38) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %40 = "polygeist.pointer2memref"(%39) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %41 = call @cudaFree(%40) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    %42 = memref.load %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1xmemref<?xi32>>
    %43 = "polygeist.memref2pointer"(%42) {spmd.executionKind = "All"} : (memref<?xi32>) -> !llvm.ptr
    %44 = "polygeist.pointer2memref"(%43) {spmd.executionKind = "All"} : (!llvm.ptr) -> memref<?xi8>
    %45 = call @cudaFree(%44) {spmd.executionKind = "All"} : (memref<?xi8>) -> i32
    memref.dealloc %alloc {spmd.executionKind = "All"} : memref<?xi32>
    memref.dealloc %alloc_6 {spmd.executionKind = "All"} : memref<1xi32>
    %46 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"}
}

