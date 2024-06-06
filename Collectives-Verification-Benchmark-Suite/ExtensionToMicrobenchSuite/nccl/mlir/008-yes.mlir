module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c0_i64 = arith.constant 0 : i64
    %c21_i32 = arith.constant 21 : i32
    %c2_i32 = arith.constant 2 : i32
    %c8_i32 = arith.constant 8 : i32
    %c1_i64 = arith.constant 1 : i64
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c42_i32 = arith.constant 42 : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_4 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_5 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_5 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_6 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_6[%c0] : memref<1xi32>
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
      %68 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %6 = "polygeist.memref2pointer"(%alloca_5) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %13 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %14 = "polygeist.memref2pointer"(%13) : (memref<?xi32>) -> !llvm.ptr
    %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
    %16 = call @cudaMemset(%15, %c42_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %17 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %18 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %19 = call @cudaMalloc(%18, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %20 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %21 = "polygeist.memref2pointer"(%20) : (memref<?xi32>) -> !llvm.ptr
    %22 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xi8>
    %23 = call @cudaMemset(%22, %c8_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %cast_15 = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %24 = call @cudaStreamCreate(%cast_15) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_16 = memref.cast %alloca_4 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %25 = memref.load %alloca_7[%c0] : memref<1xi32>
    %26 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %68 = arith.index_cast %arg2 : index to i32
      %69 = llvm.getelementptr %6[%68] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %70 = llvm.load %69 : !llvm.ptr -> i8
      %71 = llvm.getelementptr %26[%68] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %70, %71 : i8, !llvm.ptr
    }
    %27 = memref.load %alloca_8[%c0] : memref<1xi32>
    %28 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %29 = call @ncclCommInitRank(%cast_16, %25, %28, %27) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %30 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_17 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %31 = call @ncclCommUserRank(%30, %cast_17) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %32 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %33 = "polygeist.memref2pointer"(%32) : (memref<?xi32>) -> !llvm.ptr
    %34 = "polygeist.pointer2memref"(%33) : (!llvm.ptr) -> memref<?xi8>
    %35 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %36 = "polygeist.memref2pointer"(%35) : (memref<?xi32>) -> !llvm.ptr
    %37 = "polygeist.pointer2memref"(%36) : (!llvm.ptr) -> memref<?xi8>
    %38 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %39 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %40 = call @ncclAllReduce(%34, %37, %c1_i64, %c2_i32, %c0_i32, %38, %39) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    %41 = "polygeist.memref2pointer"(%alloca_6) : (memref<1xi32>) -> !llvm.ptr
    %42 = "polygeist.pointer2memref"(%41) : (!llvm.ptr) -> memref<?xi8>
    %43 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %44 = "polygeist.memref2pointer"(%43) : (memref<?xi32>) -> !llvm.ptr
    %45 = "polygeist.pointer2memref"(%44) : (!llvm.ptr) -> memref<?xi8>
    %46 = call @cudaMemcpy(%42, %45, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
    %47 = memref.load %alloca_0[%c0] : memref<1xi32>
    %48 = arith.cmpi eq, %47, %c0_i32 : i32
    scf.if %48 {
      %68 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %69 = "polygeist.memref2pointer"(%68) : (memref<?xi32>) -> !llvm.ptr
      %70 = "polygeist.pointer2memref"(%69) : (!llvm.ptr) -> memref<?xi8>
      %71 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %72 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %73 = func.call @ncclBcast(%70, %c1_i64, %c2_i32, %c0_i32, %71, %72) : (memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %68 = memref.load %alloca_6[%c0] : memref<1xi32>
      %69 = arith.cmpi eq, %68, %c21_i32 : i32
      scf.if %69 {
        %70 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
        %71 = "polygeist.memref2pointer"(%70) : (memref<?xi32>) -> !llvm.ptr
        %72 = "polygeist.pointer2memref"(%71) : (!llvm.ptr) -> memref<?xi8>
        %73 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
        %74 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
        %75 = func.call @ncclBcast(%72, %c1_i64, %c2_i32, %c0_i32, %73, %74) : (memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      }
    }
    %49 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %50 = "polygeist.memref2pointer"(%49) : (memref<?xi32>) -> !llvm.ptr
    %51 = "polygeist.pointer2memref"(%50) : (!llvm.ptr) -> memref<?xi8>
    %52 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %53 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %54 = call @ncclAllGather(%51, %51, %c0_i64, %c2_i32, %52, %53) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    %55 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %56 = call @cudaStreamSynchronize(%55) : (memref<?x!llvm.struct<()>>) -> i32
    %57 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %58 = "polygeist.memref2pointer"(%57) : (memref<?xi32>) -> !llvm.ptr
    %59 = "polygeist.pointer2memref"(%58) : (!llvm.ptr) -> memref<?xi8>
    %60 = call @cudaFree(%59) : (memref<?xi8>) -> i32
    %61 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %62 = "polygeist.memref2pointer"(%61) : (memref<?xi32>) -> !llvm.ptr
    %63 = "polygeist.pointer2memref"(%62) : (!llvm.ptr) -> memref<?xi8>
    %64 = call @cudaFree(%63) : (memref<?xi8>) -> i32
    %65 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %66 = call @ncclCommDestroy(%65) : (memref<?x!llvm.struct<()>>) -> i32
    %67 = call @MPI_Finalize() : () -> i32
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
  func.func private @ncclAllReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclBcast(memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclAllGather(memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

