module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128_i64 = arith.constant 128 : i64
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c0_i64 = arith.constant 0 : i64
    %c2_i32 = arith.constant 2 : i32
    %c0 = arith.constant 0 : index
    %c128 = arith.constant 128 : index
    %c1 = arith.constant 1 : index
    %alloca = memref.alloca() : memref<1x!spmd.req>
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %alloca_0 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_1 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %3 = "spmd.castStream"(%alloca_1) <{usedModel = 1 : i32}> : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %cast = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %4 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_3 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast_4 = memref.cast %alloca_3 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %5 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %6 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %6 {
      %25 = func.call @ncclGetUniqueId(%cast_4) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %7 = "polygeist.memref2pointer"(%alloca_3) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %8 = "polygeist.pointer2memref"(%7) : (!llvm.ptr) -> memref<?xi8>
    %error_5 = "spmd.bcast"(%2, %8, %8, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %13 = call @cudaStreamCreate(%cast) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %14 = "polygeist.memref2pointer"(%alloca_0) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %25 = arith.index_cast %arg2 : index to i32
      %26 = llvm.getelementptr %7[%25] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %27 = llvm.load %26 : !llvm.ptr -> i8
      %28 = llvm.getelementptr %14[%25] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %27, %28 : i8, !llvm.ptr
    }
    %15 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %rank_6, %error_7 = "spmd.getRankInComm"(%4) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %16 = arith.remsi %rank_6, %c2_i32 : i32
    %17 = arith.cmpi ne, %16, %c0_i32 : i32
    scf.if %17 {
      %25 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %26 = "polygeist.memref2pointer"(%25) : (memref<?xi32>) -> !llvm.ptr
      %27 = "polygeist.pointer2memref"(%26) : (!llvm.ptr) -> memref<?xi8>
      %error_8 = "spmd.allgather"(%4, %27, %c0_i64, %0, %27, %c0_i64, %0, %3) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    } else {
      %25 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %26 = "polygeist.memref2pointer"(%25) : (memref<?xi32>) -> !llvm.ptr
      %27 = "polygeist.pointer2memref"(%26) : (!llvm.ptr) -> memref<?xi8>
      %req, %error_8 = "spmd.allgather"(%4, %27, %c0_i64, %0, %27, %c0_i64, %0, %3) <{isBlocking = false, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> (!spmd.req, !spmd.error)
      memref.store %req, %alloca[%c0] : memref<1x!spmd.req>
      %alloca_9 = memref.alloca() : memref<1x!spmd.status>
      %28 = "spmd.waitAll"(%c1_i32, %alloca, %alloca_9) <{usedModel = 1 : i32}> : (i32, memref<1x!spmd.req>, memref<1x!spmd.status>) -> !spmd.error
    }
    %18 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %19 = call @cudaStreamSynchronize(%18) : (memref<?x!llvm.struct<()>>) -> i32
    %20 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %21 = "polygeist.memref2pointer"(%20) : (memref<?xi32>) -> !llvm.ptr
    %22 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xi8>
    %23 = call @cudaFree(%22) : (memref<?xi8>) -> i32
    %24 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

