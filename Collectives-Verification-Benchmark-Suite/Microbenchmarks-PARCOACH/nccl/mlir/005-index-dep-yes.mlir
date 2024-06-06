module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z1fv() attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c2_i32 = arith.constant 2 : i32
    %c10_i32 = arith.constant 10 : i32
    %c0_i64 = arith.constant 0 : i64
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_1[%c0] : memref<1xi32>
    %alloca_2 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_4 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_5 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_5 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_6 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_6[%c0] : memref<1xi32>
    %alloca_7 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_7[%c0] : memref<1xi32>
    %cast_8 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32>
    %1 = call @MPI_Comm_size(%c1140850688_i32, %cast_8) : (i32, memref<?xi32>) -> i32
    %cast_9 = memref.cast %alloca_7 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_9) : (i32, memref<?xi32>) -> i32
    %3 = memref.load %alloca_7[%c0] : memref<1xi32>
    %4 = arith.cmpi eq, %3, %c0_i32 : i32
    scf.if %4 {
      %32 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %5 = "polygeist.memref2pointer"(%alloca_5) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %6 = "polygeist.pointer2memref"(%5) : (!llvm.ptr) -> memref<?xi8>
    %7 = call @MPI_Bcast(%6, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %8 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %9 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %11 = call @cudaMalloc(%10, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_10 = memref.cast %alloca_2 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %12 = call @cudaStreamCreate(%cast_10) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_11 = memref.cast %alloca_4 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %13 = memref.load %alloca_6[%c0] : memref<1xi32>
    %14 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg0 = %c0 to %c128 step %c1 {
      %32 = arith.index_cast %arg0 : index to i32
      %33 = llvm.getelementptr %5[%32] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %34 = llvm.load %33 : !llvm.ptr -> i8
      %35 = llvm.getelementptr %14[%32] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %34, %35 : i8, !llvm.ptr
    }
    %15 = memref.load %alloca_7[%c0] : memref<1xi32>
    %16 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %17 = call @ncclCommInitRank(%cast_11, %13, %16, %15) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %18 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_12 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %19 = call @ncclCommUserRank(%18, %cast_12) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %20 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_13 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %21 = call @ncclCommCount(%20, %cast_13) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %22 = memref.load %alloca_1[%c0] : memref<1xi32>
    %23 = arith.cmpi sgt, %22, %c10_i32 : i32
    scf.if %23 {
      %32 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %33 = "polygeist.memref2pointer"(%32) : (memref<?xi32>) -> !llvm.ptr
      %34 = "polygeist.pointer2memref"(%33) : (!llvm.ptr) -> memref<?xi8>
      %35 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %36 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %37 = func.call @ncclAllGather(%34, %34, %c0_i64, %c2_i32, %35, %36) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %24 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %25 = call @cudaStreamSynchronize(%24) : (memref<?x!llvm.struct<()>>) -> i32
    %26 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %27 = "polygeist.memref2pointer"(%26) : (memref<?xi32>) -> !llvm.ptr
    %28 = "polygeist.pointer2memref"(%27) : (!llvm.ptr) -> memref<?xi8>
    %29 = call @cudaFree(%28) : (memref<?xi8>) -> i32
    %30 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %31 = call @ncclCommDestroy(%30) : (memref<?x!llvm.struct<()>>) -> i32
    return
  }
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Bcast(memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
  func.func private @ncclCommUserRank(memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommCount(memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclAllGather(memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i64 = arith.constant 0 : i64
    %c10_i32 = arith.constant 10 : i32
    %c2_i32 = arith.constant 2 : i32
    %c128_i32 = arith.constant 128 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_0[%c0] : memref<1xi32>
    memref.store %arg1, %alloca[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %cast_1 = memref.cast %alloca : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %0 = call @MPI_Init(%cast, %cast_1) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %1 = llvm.mlir.undef : i32
    %alloca_2 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_3 = memref.alloca() : memref<1xi32>
    memref.store %1, %alloca_3[%c0] : memref<1xi32>
    %alloca_4 = memref.alloca() : memref<1xi32>
    memref.store %1, %alloca_4[%c0] : memref<1xi32>
    %alloca_5 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_6 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_7 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_8 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast_9 = memref.cast %alloca_8 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_10 = memref.alloca() : memref<1xi32>
    memref.store %1, %alloca_10[%c0] : memref<1xi32>
    %alloca_11 = memref.alloca() : memref<1xi32>
    memref.store %1, %alloca_11[%c0] : memref<1xi32>
    %cast_12 = memref.cast %alloca_10 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_12) : (i32, memref<?xi32>) -> i32
    %cast_13 = memref.cast %alloca_11 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_13) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_11[%c0] : memref<1xi32>
    %5 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %5 {
      %34 = func.call @ncclGetUniqueId(%cast_9) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %6 = "polygeist.memref2pointer"(%alloca_8) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_6) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_14 = memref.cast %alloca_5 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %13 = call @cudaStreamCreate(%cast_14) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_15 = memref.cast %alloca_7 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %14 = memref.load %alloca_10[%c0] : memref<1xi32>
    %15 = "polygeist.memref2pointer"(%alloca_2) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %34 = arith.index_cast %arg2 : index to i32
      %35 = llvm.getelementptr %6[%34] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %36 = llvm.load %35 : !llvm.ptr -> i8
      %37 = llvm.getelementptr %15[%34] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %36, %37 : i8, !llvm.ptr
    }
    %16 = memref.load %alloca_11[%c0] : memref<1xi32>
    %17 = memref.load %alloca_2[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %18 = call @ncclCommInitRank(%cast_15, %14, %17, %16) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %19 = memref.load %alloca_7[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_16 = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32>
    %20 = call @ncclCommUserRank(%19, %cast_16) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %21 = memref.load %alloca_7[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_17 = memref.cast %alloca_3 : memref<1xi32> to memref<?xi32>
    %22 = call @ncclCommCount(%21, %cast_17) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %23 = memref.load %alloca_4[%c0] : memref<1xi32>
    %24 = arith.cmpi sgt, %23, %c10_i32 : i32
    scf.if %24 {
      %34 = memref.load %alloca_6[%c0] : memref<1xmemref<?xi32>>
      %35 = "polygeist.memref2pointer"(%34) : (memref<?xi32>) -> !llvm.ptr
      %36 = "polygeist.pointer2memref"(%35) : (!llvm.ptr) -> memref<?xi8>
      %37 = memref.load %alloca_7[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %38 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %39 = func.call @ncclAllGather(%36, %36, %c0_i64, %c2_i32, %37, %38) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %25 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %26 = call @cudaStreamSynchronize(%25) : (memref<?x!llvm.struct<()>>) -> i32
    %27 = memref.load %alloca_6[%c0] : memref<1xmemref<?xi32>>
    %28 = "polygeist.memref2pointer"(%27) : (memref<?xi32>) -> !llvm.ptr
    %29 = "polygeist.pointer2memref"(%28) : (!llvm.ptr) -> memref<?xi8>
    %30 = call @cudaFree(%29) : (memref<?xi8>) -> i32
    %31 = memref.load %alloca_7[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %32 = call @ncclCommDestroy(%31) : (memref<?x!llvm.struct<()>>) -> i32
    %33 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

