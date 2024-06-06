module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c0_i64 = arith.constant 0 : i64
    %c2_i32 = arith.constant 2 : i32
    %c42_i32 = arith.constant 42 : i32
    %c13_i32 = arith.constant 13 : i32
    %c1_i64 = arith.constant 1 : i64
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_4 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_5 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_6 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_6 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_7 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_7[%c0] : memref<1xi32>
    %alloca_8 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_8[%c0] : memref<1xi32>
    %alloca_9 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_10 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_10[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_9[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast_11 = memref.cast %alloca_10 : memref<1xi32> to memref<?xi32>
    %cast_12 = memref.cast %alloca_9 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast_11, %cast_12) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_13 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_13) : (i32, memref<?xi32>) -> i32
    %cast_14 = memref.cast %alloca_7 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_size(%c1140850688_i32, %cast_14) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_8[%c0] : memref<1xi32>
    %5 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %5 {
      %56 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %6 = "polygeist.memref2pointer"(%alloca_6) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_4) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %13 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %14 = "polygeist.pointer2memref"(%13) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %15 = call @cudaMalloc(%14, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %16 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %17 = "polygeist.memref2pointer"(%16) : (memref<?xi32>) -> !llvm.ptr
    %18 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xi8>
    %19 = call @cudaMemset(%18, %c13_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %20 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %21 = "polygeist.pointer2memref"(%20) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %22 = call @cudaMalloc(%21, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_15 = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %23 = call @cudaStreamCreate(%cast_15) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_16 = memref.cast %alloca_5 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %24 = memref.load %alloca_7[%c0] : memref<1xi32>
    %25 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %56 = arith.index_cast %arg2 : index to i32
      %57 = llvm.getelementptr %6[%56] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %58 = llvm.load %57 : !llvm.ptr -> i8
      %59 = llvm.getelementptr %25[%56] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %58, %59 : i8, !llvm.ptr
    }
    %26 = memref.load %alloca_8[%c0] : memref<1xi32>
    %27 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %28 = call @ncclCommInitRank(%cast_16, %24, %27, %26) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %29 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_17 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %30 = call @ncclCommUserRank(%29, %cast_17) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %31 = memref.load %alloca_0[%c0] : memref<1xi32>
    %32 = arith.cmpi eq, %31, %c0_i32 : i32
    scf.if %32 {
      %56 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) : (!llvm.ptr) -> memref<?xi8>
      %59 = func.call @cudaMemset(%58, %c42_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
      %60 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %61 = "polygeist.memref2pointer"(%60) : (memref<?xi32>) -> !llvm.ptr
      %62 = "polygeist.pointer2memref"(%61) : (!llvm.ptr) -> memref<?xi8>
      %63 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %64 = "polygeist.memref2pointer"(%63) : (memref<?xi32>) -> !llvm.ptr
      %65 = "polygeist.pointer2memref"(%64) : (!llvm.ptr) -> memref<?xi8>
      %66 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %67 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %68 = func.call @ncclReduce(%62, %65, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %66, %67) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %69 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %70 = "polygeist.memref2pointer"(%69) : (memref<?xi32>) -> !llvm.ptr
      %71 = "polygeist.pointer2memref"(%70) : (!llvm.ptr) -> memref<?xi8>
      %72 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %73 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %74 = func.call @ncclBcast(%71, %c1_i64, %c2_i32, %c0_i32, %72, %73) : (memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %56 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) : (!llvm.ptr) -> memref<?xi8>
      %59 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %60 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %61 = func.call @ncclBcast(%58, %c1_i64, %c2_i32, %c0_i32, %59, %60) : (memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %62 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %63 = "polygeist.memref2pointer"(%62) : (memref<?xi32>) -> !llvm.ptr
      %64 = "polygeist.pointer2memref"(%63) : (!llvm.ptr) -> memref<?xi8>
      %65 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %66 = "polygeist.memref2pointer"(%65) : (memref<?xi32>) -> !llvm.ptr
      %67 = "polygeist.pointer2memref"(%66) : (!llvm.ptr) -> memref<?xi8>
      %68 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %69 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %70 = func.call @ncclReduce(%64, %67, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %68, %69) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %33 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %34 = "polygeist.memref2pointer"(%33) : (memref<?xi32>) -> !llvm.ptr
    %35 = "polygeist.pointer2memref"(%34) : (!llvm.ptr) -> memref<?xi8>
    %36 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %37 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %38 = call @ncclAllGather(%35, %35, %c0_i64, %c2_i32, %36, %37) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    %39 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %40 = call @cudaStreamSynchronize(%39) : (memref<?x!llvm.struct<()>>) -> i32
    %41 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %42 = "polygeist.memref2pointer"(%41) : (memref<?xi32>) -> !llvm.ptr
    %43 = "polygeist.pointer2memref"(%42) : (!llvm.ptr) -> memref<?xi8>
    %44 = call @cudaFree(%43) : (memref<?xi8>) -> i32
    %45 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %46 = "polygeist.memref2pointer"(%45) : (memref<?xi32>) -> !llvm.ptr
    %47 = "polygeist.pointer2memref"(%46) : (!llvm.ptr) -> memref<?xi8>
    %48 = call @cudaFree(%47) : (memref<?xi8>) -> i32
    %49 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %50 = "polygeist.memref2pointer"(%49) : (memref<?xi32>) -> !llvm.ptr
    %51 = "polygeist.pointer2memref"(%50) : (!llvm.ptr) -> memref<?xi8>
    %52 = call @cudaFree(%51) : (memref<?xi8>) -> i32
    %53 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %54 = call @ncclCommDestroy(%53) : (memref<?x!llvm.struct<()>>) -> i32
    %55 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Bcast(memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
  func.func private @ncclCommUserRank(memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclBcast(memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclAllGather(memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

