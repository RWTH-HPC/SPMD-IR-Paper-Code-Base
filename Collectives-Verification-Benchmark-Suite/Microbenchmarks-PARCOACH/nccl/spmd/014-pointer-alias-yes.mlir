module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128_i64 = arith.constant 128 : i64
    %c0_i32 = arith.constant 0 : i32
    %c0_i64 = arith.constant 0 : i64
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %3 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %4 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %5 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_2 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_2 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %6 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %7 {
      %28 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %8 = "polygeist.memref2pointer"(%alloca_2) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %9 = "polygeist.pointer2memref"(%8) : (!llvm.ptr) -> memref<?xi8>
    %error_3 = "spmd.bcast"(%2, %9, %9, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %10 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %11 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %13 = call @cudaMalloc(%12, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_4 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %14 = call @cudaStreamCreate(%cast_4) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %15 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %28 = arith.index_cast %arg2 : index to i32
      %29 = llvm.getelementptr %8[%28] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %30 = llvm.load %29 : !llvm.ptr -> i8
      %31 = llvm.getelementptr %15[%28] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %30, %31 : i8, !llvm.ptr
    }
    %16 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %rank_5, %error_6 = "spmd.getRankInComm"(%5) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %17 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %18 = "polygeist.memref2pointer"(%17) : (memref<?xi32>) -> !llvm.ptr
    %19 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xi8>
    %error_7 = "spmd.allgather"(%5, %19, %c0_i64, %0, %19, %c0_i64, %0, %4) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    %20 = arith.cmpi sgt, %rank_5, %c0_i32 : i32
    scf.if %20 {
      %28 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %29 = "polygeist.memref2pointer"(%28) : (memref<?xi32>) -> !llvm.ptr
      %30 = "polygeist.pointer2memref"(%29) : (!llvm.ptr) -> memref<?xi8>
      %error_8 = "spmd.allgather"(%5, %30, %c0_i64, %0, %30, %c0_i64, %0, %4) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    }
    %21 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %22 = call @cudaStreamSynchronize(%21) : (memref<?x!llvm.struct<()>>) -> i32
    %23 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %24 = "polygeist.memref2pointer"(%23) : (memref<?xi32>) -> !llvm.ptr
    %25 = "polygeist.pointer2memref"(%24) : (!llvm.ptr) -> memref<?xi8>
    %26 = call @cudaFree(%25) : (memref<?xi8>) -> i32
    %27 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %3 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

