module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@_ZZ4mainE2id@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@_ZZ4mainE2id" : memref<1x!llvm.struct<(array<128 x i8>)>> = uninitialized
  memref.global "private" @"main@static@_ZZ4mainE4data" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c4_i64 = arith.constant 4 : i64
    %c1_i64 = arith.constant 1 : i64
    %3 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> : () -> !spmd.reduceOp
    %c0_i32 = arith.constant 0 : i32
    %c128_i64 = arith.constant 128 : i64
    %4 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %c2_i32 = arith.constant 2 : i32
    %c42_i32 = arith.constant 42 : i32
    %c13_i32 = arith.constant 13 : i32
    %false = arith.constant false
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %5 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %6 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_3 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %7 = memref.get_global @"main@static@_ZZ4mainE2id" : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %7 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %8 = memref.get_global @"main@static@_ZZ4mainE4data" : memref<1xi32>
    %9 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %10 = arith.cmpi eq, %rank, %c0_i32 : i32
    %size, %error_4 = "spmd.getSizeOfComm"(%2) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %11 = memref.get_global @"main@static@_ZZ4mainE2id@init" : memref<1xi1>
    %12 = memref.load %11[%c0] : memref<1xi1>
    scf.if %12 {
      memref.store %false, %11[%c0] : memref<1xi1>
    }
    scf.if %10 {
      %44 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %13 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %14 = memref.load %13[%c0] : memref<1xmemref<?x1xi32>>
    %15 = "polygeist.memref2pointer"(%7) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
    %error_5 = "spmd.bcast"(%2, %16, %16, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %17 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %18 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %19 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %20 = call @cudaMalloc(%19, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %21 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %22 = "polygeist.memref2pointer"(%21) : (memref<?xi32>) -> !llvm.ptr
    %23 = "polygeist.pointer2memref"(%22) : (!llvm.ptr) -> memref<?xi8>
    %24 = call @cudaMemset(%23, %c13_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %25 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %26 = "polygeist.pointer2memref"(%25) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %27 = call @cudaMalloc(%26, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_6 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %28 = call @cudaStreamCreate(%cast_6) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_7 = memref.cast %alloca_3 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %29 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %44 = arith.index_cast %arg2 : index to i32
      %45 = llvm.getelementptr %15[%44] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %46 = llvm.load %45 : !llvm.ptr -> i8
      %47 = llvm.getelementptr %29[%44] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %46, %47 : i8, !llvm.ptr
    }
    %30 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %31 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    scf.if %10 {
      memref.store %c42_i32, %8[%c0] : memref<1xi32>
      %44 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %45 = "polygeist.memref2pointer"(%44) : (memref<?xi32>) -> !llvm.ptr
      %46 = "polygeist.pointer2memref"(%45) : (!llvm.ptr) -> memref<?xi8>
      %47 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %48 = "polygeist.memref2pointer"(%47) : (memref<?xi32>) -> !llvm.ptr
      %49 = "polygeist.pointer2memref"(%48) : (!llvm.ptr) -> memref<?xi8>
      %50 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %51 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %error_9 = "spmd.reduce"(%6, %46, %49, %c1_i64, %4, %3, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
      %52 = memref.load %13[%c0] : memref<1xmemref<?x1xi32>>
      %cast_10 = memref.cast %8 : memref<1xi32> to memref<?xi32>
      %error_11 = "spmd.bcast"(%2, %cast_10, %cast_10, %c1_i64, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
    } else {
      %44 = memref.load %13[%c0] : memref<1xmemref<?x1xi32>>
      %cast_9 = memref.cast %8 : memref<1xi32> to memref<?xi32>
      %error_10 = "spmd.bcast"(%2, %cast_9, %cast_9, %c1_i64, %0, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, i32) -> !spmd.error
      %45 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %46 = "polygeist.memref2pointer"(%45) : (memref<?xi32>) -> !llvm.ptr
      %47 = "polygeist.pointer2memref"(%46) : (!llvm.ptr) -> memref<?xi8>
      %48 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %49 = "polygeist.memref2pointer"(%48) : (memref<?xi32>) -> !llvm.ptr
      %50 = "polygeist.pointer2memref"(%49) : (!llvm.ptr) -> memref<?xi8>
      %51 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %52 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %error_11 = "spmd.reduce"(%6, %47, %50, %c1_i64, %4, %3, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    }
    %32 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %33 = call @cudaStreamSynchronize(%32) : (memref<?x!llvm.struct<()>>) -> i32
    %error_8 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    %34 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %35 = "polygeist.memref2pointer"(%34) : (memref<?xi32>) -> !llvm.ptr
    %36 = "polygeist.pointer2memref"(%35) : (!llvm.ptr) -> memref<?xi8>
    %37 = call @cudaFree(%36) : (memref<?xi8>) -> i32
    %38 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %39 = "polygeist.memref2pointer"(%38) : (memref<?xi32>) -> !llvm.ptr
    %40 = "polygeist.pointer2memref"(%39) : (!llvm.ptr) -> memref<?xi8>
    %41 = call @cudaFree(%40) : (memref<?xi8>) -> i32
    %42 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %43 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func @_ZN12ncclUniqueIdC1ERKS_(%arg0: memref<?x!llvm.struct<(array<128 x i8>)>>, %arg1: memref<?x!llvm.struct<(array<128 x i8>)>>) attributes {llvm.linkage = #llvm.linkage<linkonce_odr>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %0 = "polygeist.memref2pointer"(%arg0) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %1 = "polygeist.memref2pointer"(%arg1) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %2 = arith.index_cast %arg2 : index to i32
      %3 = llvm.getelementptr %1[%2] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %4 = llvm.load %3 : !llvm.ptr -> i8
      %5 = llvm.getelementptr %0[%2] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %4, %5 : i8, !llvm.ptr
    }
    return
  }
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}
