module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@_ZZ4mainE2id@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@_ZZ4mainE2id" : memref<1x!llvm.struct<(array<128 x i8>)>> = uninitialized
  memref.global "private" @"main@static@_ZZ4mainE4data" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c4_i64 = arith.constant 4 : i64
    %c1_i64 = arith.constant 1 : i64
    %c0_i32 = arith.constant 0 : i32
    %c128_i64 = arith.constant 128 : i64
    %c2_i32 = arith.constant 2 : i32
    %c42_i32 = arith.constant 42 : i32
    %c13_i32 = arith.constant 13 : i32
    %false = arith.constant false
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %0 = memref.get_global @"main@static@_ZZ4mainE2id" : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %0 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %1 = memref.get_global @"main@static@_ZZ4mainE4data" : memref<1xi32>
    call @shmem_init() : () -> ()
    %2 = call @shmem_my_pe() : () -> i32
    %3 = arith.cmpi eq, %2, %c0_i32 : i32
    %4 = call @shmem_n_pes() : () -> i32
    %5 = memref.get_global @"main@static@_ZZ4mainE2id@init" : memref<1xi1>
    %6 = memref.load %5[%c0] : memref<1xi1>
    scf.if %6 {
      memref.store %false, %5[%c0] : memref<1xi1>
    }
    scf.if %3 {
      %39 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %7 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %8 = memref.load %7[%c0] : memref<1xmemref<?x1xi32>>
    %9 = "polygeist.memref2pointer"(%0) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xi8>
    %11 = call @shmem_broadcastmem(%8, %10, %10, %c128_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi8>, memref<?xi8>, i64, i32) -> i32
    %12 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %13 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %14 = "polygeist.pointer2memref"(%13) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %15 = call @cudaMalloc(%14, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %16 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %17 = "polygeist.memref2pointer"(%16) : (memref<?xi32>) -> !llvm.ptr
    %18 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xi8>
    %19 = call @cudaMemset(%18, %c13_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %20 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %21 = "polygeist.pointer2memref"(%20) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %22 = call @cudaMalloc(%21, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_4 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %23 = call @cudaStreamCreate(%cast_4) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_5 = memref.cast %alloca_3 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %24 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %39 = arith.index_cast %arg2 : index to i32
      %40 = llvm.getelementptr %9[%39] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %41 = llvm.load %40 : !llvm.ptr -> i8
      %42 = llvm.getelementptr %24[%39] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %41, %42 : i8, !llvm.ptr
    }
    %25 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %26 = call @ncclCommInitRank(%cast_5, %4, %25, %2) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    scf.if %3 {
      memref.store %c42_i32, %1[%c0] : memref<1xi32>
      %39 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %40 = "polygeist.memref2pointer"(%39) : (memref<?xi32>) -> !llvm.ptr
      %41 = "polygeist.pointer2memref"(%40) : (!llvm.ptr) -> memref<?xi8>
      %42 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %43 = "polygeist.memref2pointer"(%42) : (memref<?xi32>) -> !llvm.ptr
      %44 = "polygeist.pointer2memref"(%43) : (!llvm.ptr) -> memref<?xi8>
      %45 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %46 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %47 = func.call @ncclReduce(%41, %44, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %45, %46) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %48 = memref.load %7[%c0] : memref<1xmemref<?x1xi32>>
      %cast_6 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %49 = func.call @shmem_int_broadcast(%48, %cast_6, %cast_6, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
    } else {
      %39 = memref.load %7[%c0] : memref<1xmemref<?x1xi32>>
      %cast_6 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %40 = func.call @shmem_int_broadcast(%39, %cast_6, %cast_6, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
      %41 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %42 = "polygeist.memref2pointer"(%41) : (memref<?xi32>) -> !llvm.ptr
      %43 = "polygeist.pointer2memref"(%42) : (!llvm.ptr) -> memref<?xi8>
      %44 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %45 = "polygeist.memref2pointer"(%44) : (memref<?xi32>) -> !llvm.ptr
      %46 = "polygeist.pointer2memref"(%45) : (!llvm.ptr) -> memref<?xi8>
      %47 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %48 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %49 = func.call @ncclReduce(%43, %46, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %47, %48) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %27 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %28 = call @cudaStreamSynchronize(%27) : (memref<?x!llvm.struct<()>>) -> i32
    call @shmem_sync_all() : () -> ()
    %29 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %30 = "polygeist.memref2pointer"(%29) : (memref<?xi32>) -> !llvm.ptr
    %31 = "polygeist.pointer2memref"(%30) : (!llvm.ptr) -> memref<?xi8>
    %32 = call @cudaFree(%31) : (memref<?xi8>) -> i32
    %33 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %34 = "polygeist.memref2pointer"(%33) : (memref<?xi32>) -> !llvm.ptr
    %35 = "polygeist.pointer2memref"(%34) : (!llvm.ptr) -> memref<?xi8>
    %36 = call @cudaFree(%35) : (memref<?xi8>) -> i32
    %37 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %38 = call @ncclCommDestroy(%37) : (memref<?x!llvm.struct<()>>) -> i32
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_broadcastmem(memref<?x1xi32>, memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommInitRank(memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
  func.func private @ncclReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_broadcast(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_sync_all() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

