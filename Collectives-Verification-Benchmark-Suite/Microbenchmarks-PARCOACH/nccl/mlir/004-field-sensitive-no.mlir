module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @_Z1fP11_hydroparam(%arg0: memref<?x2xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128 = arith.constant 128 : index
    %c128_i32 = arith.constant 128 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i64 = arith.constant 0 : i64
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_3 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_3 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_4 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_4[%c0] : memref<1xi32>
    %alloca_5 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_5[%c0] : memref<1xi32>
    %cast_6 = memref.cast %alloca_5 : memref<1xi32> to memref<?xi32>
    %1 = call @MPI_Comm_rank(%c1140850688_i32, %cast_6) : (i32, memref<?xi32>) -> i32
    %cast_7 = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_7) : (i32, memref<?xi32>) -> i32
    %3 = memref.load %alloca_5[%c0] : memref<1xi32>
    %4 = arith.cmpi eq, %3, %c0_i32 : i32
    scf.if %4 {
      %35 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %5 = "polygeist.memref2pointer"(%alloca_3) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %6 = "polygeist.pointer2memref"(%5) : (!llvm.ptr) -> memref<?xi8>
    %7 = call @MPI_Bcast(%6, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %8 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %9 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %11 = call @cudaMalloc(%10, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_8 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %12 = call @cudaStreamCreate(%cast_8) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_9 = memref.cast %alloca_2 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %13 = memref.load %alloca_4[%c0] : memref<1xi32>
    %14 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg1 = %c0 to %c128 step %c1 {
      %35 = arith.index_cast %arg1 : index to i32
      %36 = llvm.getelementptr %5[%35] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %37 = llvm.load %36 : !llvm.ptr -> i8
      %38 = llvm.getelementptr %14[%35] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %37, %38 : i8, !llvm.ptr
    }
    %15 = memref.load %alloca_5[%c0] : memref<1xi32>
    %16 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %17 = call @ncclCommInitRank(%cast_9, %13, %16, %15) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %18 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %19 = "polygeist.subindex"(%arg0, %c0) : (memref<?x2xi32>, index) -> memref<2xi32>
    %20 = "polygeist.subindex"(%19, %c0) : (memref<2xi32>, index) -> memref<?xi32>
    %21 = call @ncclCommUserRank(%18, %20) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %22 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %23 = "polygeist.subindex"(%19, %c1) : (memref<2xi32>, index) -> memref<?xi32>
    %24 = call @ncclCommCount(%22, %23) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %25 = memref.load %arg0[%c0, %c1] : memref<?x2xi32>
    %26 = arith.cmpi sgt, %25, %c1_i32 : i32
    scf.if %26 {
      %35 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %36 = "polygeist.memref2pointer"(%35) : (memref<?xi32>) -> !llvm.ptr
      %37 = "polygeist.pointer2memref"(%36) : (!llvm.ptr) -> memref<?xi8>
      %38 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %39 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %40 = func.call @ncclAllGather(%37, %37, %c0_i64, %c2_i32, %38, %39) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %27 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %28 = call @cudaStreamSynchronize(%27) : (memref<?x!llvm.struct<()>>) -> i32
    %29 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %30 = "polygeist.memref2pointer"(%29) : (memref<?xi32>) -> !llvm.ptr
    %31 = "polygeist.pointer2memref"(%30) : (!llvm.ptr) -> memref<?xi8>
    %32 = call @cudaFree(%31) : (memref<?xi8>) -> i32
    %33 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %34 = call @ncclCommDestroy(%33) : (memref<?x!llvm.struct<()>>) -> i32
    return
  }
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i64 = arith.constant 0 : i64
    %c1_i32 = arith.constant 1 : i32
    %c2_i32 = arith.constant 2 : i32
    %c128_i32 = arith.constant 128 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<memref<?x2xi32>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_1[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %cast_2 = memref.cast %alloca_0 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %0 = call @MPI_Init(%cast, %cast_2) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %1 = memref.load %alloca[] : memref<memref<?x2xi32>>
    %alloca_3 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_4 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_5 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_6 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_7 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast_8 = memref.cast %alloca_7 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_9 = memref.alloca() : memref<1xi32>
    %2 = llvm.mlir.undef : i32
    memref.store %2, %alloca_9[%c0] : memref<1xi32>
    %alloca_10 = memref.alloca() : memref<1xi32>
    memref.store %2, %alloca_10[%c0] : memref<1xi32>
    %cast_11 = memref.cast %alloca_10 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_11) : (i32, memref<?xi32>) -> i32
    %cast_12 = memref.cast %alloca_9 : memref<1xi32> to memref<?xi32>
    %4 = call @MPI_Comm_size(%c1140850688_i32, %cast_12) : (i32, memref<?xi32>) -> i32
    %5 = memref.load %alloca_10[%c0] : memref<1xi32>
    %6 = arith.cmpi eq, %5, %c0_i32 : i32
    scf.if %6 {
      %38 = func.call @ncclGetUniqueId(%cast_8) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %7 = "polygeist.memref2pointer"(%alloca_7) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %8 = "polygeist.pointer2memref"(%7) : (!llvm.ptr) -> memref<?xi8>
    %9 = call @MPI_Bcast(%8, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %10 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %11 = "polygeist.memref2pointer"(%alloca_5) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %13 = call @cudaMalloc(%12, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_13 = memref.cast %alloca_4 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %14 = call @cudaStreamCreate(%cast_13) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_14 = memref.cast %alloca_6 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %15 = memref.load %alloca_9[%c0] : memref<1xi32>
    %16 = "polygeist.memref2pointer"(%alloca_3) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %38 = arith.index_cast %arg2 : index to i32
      %39 = llvm.getelementptr %7[%38] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %40 = llvm.load %39 : !llvm.ptr -> i8
      %41 = llvm.getelementptr %16[%38] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %40, %41 : i8, !llvm.ptr
    }
    %17 = memref.load %alloca_10[%c0] : memref<1xi32>
    %18 = memref.load %alloca_3[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %19 = call @ncclCommInitRank(%cast_14, %15, %18, %17) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %20 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %21 = "polygeist.subindex"(%1, %c0) : (memref<?x2xi32>, index) -> memref<2xi32>
    %22 = "polygeist.subindex"(%21, %c0) : (memref<2xi32>, index) -> memref<?xi32>
    %23 = call @ncclCommUserRank(%20, %22) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %24 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %25 = "polygeist.subindex"(%21, %c1) : (memref<2xi32>, index) -> memref<?xi32>
    %26 = call @ncclCommCount(%24, %25) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %27 = memref.load %1[%c0, %c1] : memref<?x2xi32>
    %28 = arith.cmpi sgt, %27, %c1_i32 : i32
    scf.if %28 {
      %38 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
      %39 = "polygeist.memref2pointer"(%38) : (memref<?xi32>) -> !llvm.ptr
      %40 = "polygeist.pointer2memref"(%39) : (!llvm.ptr) -> memref<?xi8>
      %41 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %42 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %43 = func.call @ncclAllGather(%40, %40, %c0_i64, %c2_i32, %41, %42) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %29 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %30 = call @cudaStreamSynchronize(%29) : (memref<?x!llvm.struct<()>>) -> i32
    %31 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
    %32 = "polygeist.memref2pointer"(%31) : (memref<?xi32>) -> !llvm.ptr
    %33 = "polygeist.pointer2memref"(%32) : (!llvm.ptr) -> memref<?xi8>
    %34 = call @cudaFree(%33) : (memref<?xi8>) -> i32
    %35 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %36 = call @ncclCommDestroy(%35) : (memref<?x!llvm.struct<()>>) -> i32
    %37 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

