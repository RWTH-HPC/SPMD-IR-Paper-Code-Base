module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c0_i64 = arith.constant 0 : i64
    %c21_i32 = arith.constant 21 : i32
    %c2_i32 = arith.constant 2 : i32
    %c13_i32 = arith.constant 13 : i32
    %c8_i32 = arith.constant 8 : i32
    %c42_i32 = arith.constant 42 : i32
    %c1_i64 = arith.constant 1 : i64
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_4 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_5 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_6 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_6 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_7 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_7[%c0] : memref<1xi32>
    %alloca_8 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_8[%c0] : memref<1xi32>
    %alloca_9 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_9[%c0] : memref<1xi32>
    %alloca_10 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_11 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_11[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_10[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast_12 = memref.cast %alloca_11 : memref<1xi32> to memref<?xi32>
    %cast_13 = memref.cast %alloca_10 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast_12, %cast_13) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_14 = memref.cast %alloca_9 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_14) : (i32, memref<?xi32>) -> i32
    %cast_15 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_size(%c1140850688_i32, %cast_15) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_9[%c0] : memref<1xi32>
    %5 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %5 {
      %84 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %6 = "polygeist.memref2pointer"(%alloca_6) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_4) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %13 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %14 = "polygeist.memref2pointer"(%13) : (memref<?xi32>) -> !llvm.ptr
    %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
    %16 = call @cudaMemset(%15, %c42_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %17 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %18 = "polygeist.pointer2memref"(%17) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %19 = call @cudaMalloc(%18, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %20 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %21 = "polygeist.memref2pointer"(%20) : (memref<?xi32>) -> !llvm.ptr
    %22 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xi8>
    %23 = call @cudaMemset(%22, %c8_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %24 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %25 = "polygeist.pointer2memref"(%24) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %26 = call @cudaMalloc(%25, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %27 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %28 = "polygeist.memref2pointer"(%27) : (memref<?xi32>) -> !llvm.ptr
    %29 = "polygeist.pointer2memref"(%28) : (!llvm.ptr) -> memref<?xi8>
    %30 = call @cudaMemset(%29, %c13_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %31 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %32 = "polygeist.pointer2memref"(%31) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %33 = call @cudaMalloc(%32, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_16 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %34 = call @cudaStreamCreate(%cast_16) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_17 = memref.cast %alloca_5 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %35 = memref.load %alloca_8[%c0] : memref<1xi32>
    %36 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %84 = arith.index_cast %arg2 : index to i32
      %85 = llvm.getelementptr %6[%84] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %86 = llvm.load %85 : !llvm.ptr -> i8
      %87 = llvm.getelementptr %36[%84] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %86, %87 : i8, !llvm.ptr
    }
    %37 = memref.load %alloca_9[%c0] : memref<1xi32>
    %38 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %39 = call @ncclCommInitRank(%cast_17, %35, %38, %37) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %40 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %41 = "polygeist.memref2pointer"(%40) : (memref<?xi32>) -> !llvm.ptr
    %42 = "polygeist.pointer2memref"(%41) : (!llvm.ptr) -> memref<?xi8>
    %43 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %44 = "polygeist.memref2pointer"(%43) : (memref<?xi32>) -> !llvm.ptr
    %45 = "polygeist.pointer2memref"(%44) : (!llvm.ptr) -> memref<?xi8>
    %46 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %47 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %48 = call @ncclAllReduce(%42, %45, %c1_i64, %c2_i32, %c0_i32, %46, %47) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    %49 = "polygeist.memref2pointer"(%alloca_7) : (memref<1xi32>) -> !llvm.ptr
    %50 = "polygeist.pointer2memref"(%49) : (!llvm.ptr) -> memref<?xi8>
    %51 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %52 = "polygeist.memref2pointer"(%51) : (memref<?xi32>) -> !llvm.ptr
    %53 = "polygeist.pointer2memref"(%52) : (!llvm.ptr) -> memref<?xi8>
    %54 = call @cudaMemcpy(%50, %53, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
    %55 = memref.load %alloca_7[%c0] : memref<1xi32>
    %56 = arith.cmpi eq, %55, %c21_i32 : i32
    scf.if %56 {
      %84 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %85 = "polygeist.memref2pointer"(%84) : (memref<?xi32>) -> !llvm.ptr
      %86 = "polygeist.pointer2memref"(%85) : (!llvm.ptr) -> memref<?xi8>
      %87 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %88 = "polygeist.memref2pointer"(%87) : (memref<?xi32>) -> !llvm.ptr
      %89 = "polygeist.pointer2memref"(%88) : (!llvm.ptr) -> memref<?xi8>
      %90 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %91 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %92 = func.call @ncclReduce(%86, %89, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %90, %91) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %93 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %94 = "polygeist.memref2pointer"(%93) : (memref<?xi32>) -> !llvm.ptr
      %95 = "polygeist.pointer2memref"(%94) : (!llvm.ptr) -> memref<?xi8>
      %96 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %97 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %98 = func.call @ncclBcast(%95, %c1_i64, %c2_i32, %c0_i32, %96, %97) : (memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %84 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %85 = "polygeist.memref2pointer"(%84) : (memref<?xi32>) -> !llvm.ptr
      %86 = "polygeist.pointer2memref"(%85) : (!llvm.ptr) -> memref<?xi8>
      %87 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %88 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %89 = func.call @ncclBcast(%86, %c1_i64, %c2_i32, %c0_i32, %87, %88) : (memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %90 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %91 = "polygeist.memref2pointer"(%90) : (memref<?xi32>) -> !llvm.ptr
      %92 = "polygeist.pointer2memref"(%91) : (!llvm.ptr) -> memref<?xi8>
      %93 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %94 = "polygeist.memref2pointer"(%93) : (memref<?xi32>) -> !llvm.ptr
      %95 = "polygeist.pointer2memref"(%94) : (!llvm.ptr) -> memref<?xi8>
      %96 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %97 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %98 = func.call @ncclReduce(%92, %95, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %96, %97) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %57 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %58 = "polygeist.memref2pointer"(%57) : (memref<?xi32>) -> !llvm.ptr
    %59 = "polygeist.pointer2memref"(%58) : (!llvm.ptr) -> memref<?xi8>
    %60 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %61 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %62 = call @ncclAllGather(%59, %59, %c0_i64, %c2_i32, %60, %61) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    %63 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %64 = call @cudaStreamSynchronize(%63) : (memref<?x!llvm.struct<()>>) -> i32
    %65 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %66 = "polygeist.memref2pointer"(%65) : (memref<?xi32>) -> !llvm.ptr
    %67 = "polygeist.pointer2memref"(%66) : (!llvm.ptr) -> memref<?xi8>
    %68 = call @cudaFree(%67) : (memref<?xi8>) -> i32
    %69 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %70 = "polygeist.memref2pointer"(%69) : (memref<?xi32>) -> !llvm.ptr
    %71 = "polygeist.pointer2memref"(%70) : (!llvm.ptr) -> memref<?xi8>
    %72 = call @cudaFree(%71) : (memref<?xi8>) -> i32
    %73 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %74 = "polygeist.memref2pointer"(%73) : (memref<?xi32>) -> !llvm.ptr
    %75 = "polygeist.pointer2memref"(%74) : (!llvm.ptr) -> memref<?xi8>
    %76 = call @cudaFree(%75) : (memref<?xi8>) -> i32
    %77 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %78 = "polygeist.memref2pointer"(%77) : (memref<?xi32>) -> !llvm.ptr
    %79 = "polygeist.pointer2memref"(%78) : (!llvm.ptr) -> memref<?xi8>
    %80 = call @cudaFree(%79) : (memref<?xi8>) -> i32
    %81 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %82 = call @ncclCommDestroy(%81) : (memref<?x!llvm.struct<()>>) -> i32
    %83 = call @MPI_Finalize() : () -> i32
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
  func.func private @ncclAllReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclBcast(memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclAllGather(memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

