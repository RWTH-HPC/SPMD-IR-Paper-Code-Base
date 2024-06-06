module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c2_i32 = arith.constant 2 : i32
    %c1_i64 = arith.constant 1 : i64
    %c3_i32 = arith.constant 3 : i32
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
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_13) : (i32, memref<?xi32>) -> i32
    %cast_14 = memref.cast %alloca_7 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_14) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_7[%c0] : memref<1xi32>
    %5 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %5 {
      %53 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %6 = "polygeist.memref2pointer"(%alloca_5) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %13 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %14 = "polygeist.pointer2memref"(%13) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %15 = call @cudaMalloc(%14, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_15 = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %16 = call @cudaStreamCreate(%cast_15) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_16 = memref.cast %alloca_4 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %17 = memref.load %alloca_8[%c0] : memref<1xi32>
    %18 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %53 = arith.index_cast %arg2 : index to i32
      %54 = llvm.getelementptr %6[%53] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %55 = llvm.load %54 : !llvm.ptr -> i8
      %56 = llvm.getelementptr %18[%53] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %55, %56 : i8, !llvm.ptr
    }
    %19 = memref.load %alloca_7[%c0] : memref<1xi32>
    %20 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %21 = call @ncclCommInitRank(%cast_16, %17, %20, %19) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %22 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_17 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %23 = call @ncclCommUserRank(%22, %cast_17) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %24 = memref.load %alloca_0[%c0] : memref<1xi32>
    %25 = arith.cmpi eq, %24, %c0_i32 : i32
    scf.if %25 {
      memref.store %c3_i32, %alloca_6[%c0] : memref<1xi32>
      %53 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %54 = "polygeist.memref2pointer"(%53) : (memref<?xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = func.call @cudaMemset(%55, %c3_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    }
    %26 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %27 = "polygeist.memref2pointer"(%26) : (memref<?xi32>) -> !llvm.ptr
    %28 = "polygeist.pointer2memref"(%27) : (!llvm.ptr) -> memref<?xi8>
    %29 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %30 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %31 = call @ncclBroadcast(%28, %28, %c1_i64, %c2_i32, %c0_i32, %29, %30) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    %32 = memref.load %alloca_0[%c0] : memref<1xi32>
    %33 = arith.remsi %32, %c2_i32 : i32
    %34 = arith.cmpi eq, %33, %c0_i32 : i32
    scf.if %34 {
      %53 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %54 = "polygeist.memref2pointer"(%53) : (memref<?xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) : (!llvm.ptr) -> memref<?xi8>
      %59 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %60 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %61 = func.call @ncclReduce(%55, %58, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %59, %60) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %53 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %54 = "polygeist.memref2pointer"(%53) : (memref<?xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %57 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %58 = func.call @ncclBroadcast(%55, %55, %c1_i64, %c2_i32, %c0_i32, %56, %57) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %35 = memref.load %alloca_0[%c0] : memref<1xi32>
    %36 = arith.cmpi eq, %35, %c0_i32 : i32
    scf.if %36 {
      %53 = "polygeist.memref2pointer"(%alloca_6) : (memref<1xi32>) -> !llvm.ptr
      %54 = "polygeist.pointer2memref"(%53) : (!llvm.ptr) -> memref<?xi8>
      %55 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %56 = "polygeist.memref2pointer"(%55) : (memref<?xi32>) -> !llvm.ptr
      %57 = "polygeist.pointer2memref"(%56) : (!llvm.ptr) -> memref<?xi8>
      %58 = func.call @cudaMemcpy(%54, %57, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %59 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %60 = "polygeist.memref2pointer"(%59) : (memref<?xi32>) -> !llvm.ptr
      %61 = "polygeist.pointer2memref"(%60) : (!llvm.ptr) -> memref<?xi8>
      %62 = memref.load %alloca_6[%c0] : memref<1xi32>
      %63 = func.call @cudaMemset(%61, %62, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    }
    %37 = memref.load %alloca_0[%c0] : memref<1xi32>
    %38 = arith.remsi %37, %c2_i32 : i32
    %39 = arith.cmpi eq, %38, %c0_i32 : i32
    scf.if %39 {
      %53 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %54 = "polygeist.memref2pointer"(%53) : (memref<?xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %57 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %58 = func.call @ncclBroadcast(%55, %55, %c1_i64, %c2_i32, %c0_i32, %56, %57) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %53 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %54 = "polygeist.memref2pointer"(%53) : (memref<?xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) : (!llvm.ptr) -> memref<?xi8>
      %59 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %60 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %61 = func.call @ncclReduce(%55, %58, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %59, %60) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %40 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %41 = call @cudaStreamSynchronize(%40) : (memref<?x!llvm.struct<()>>) -> i32
    %42 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %43 = "polygeist.memref2pointer"(%42) : (memref<?xi32>) -> !llvm.ptr
    %44 = "polygeist.pointer2memref"(%43) : (!llvm.ptr) -> memref<?xi8>
    %45 = call @cudaFree(%44) : (memref<?xi8>) -> i32
    %46 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %47 = "polygeist.memref2pointer"(%46) : (memref<?xi32>) -> !llvm.ptr
    %48 = "polygeist.pointer2memref"(%47) : (!llvm.ptr) -> memref<?xi8>
    %49 = call @cudaFree(%48) : (memref<?xi8>) -> i32
    %50 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %51 = call @ncclCommDestroy(%50) : (memref<?x!llvm.struct<()>>) -> i32
    %52 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclBroadcast(memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

