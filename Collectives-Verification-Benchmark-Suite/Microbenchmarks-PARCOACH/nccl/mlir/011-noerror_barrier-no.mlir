module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c2_i32 = arith.constant 2 : i32
    %c256_i32 = arith.constant 256 : i32
    %c0_i64 = arith.constant 0 : i64
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_4 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_4 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_5 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_5[%c0] : memref<1xi32>
    %alloca_6 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_6[%c0] : memref<1xi32>
    %alloca_7 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_8 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_8[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_7[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast_9 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32>
    %cast_10 = memref.cast %alloca_7 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast_9, %cast_10) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_11 = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_11) : (i32, memref<?xi32>) -> i32
    %cast_12 = memref.cast %alloca_5 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_12) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_5[%c0] : memref<1xi32>
    %5 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %5 {
      %32 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %6 = "polygeist.memref2pointer"(%alloca_4) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %10 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %12 = call @cudaMalloc(%11, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_13 = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %13 = call @cudaStreamCreate(%cast_13) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_14 = memref.cast %alloca_3 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %14 = memref.load %alloca_6[%c0] : memref<1xi32>
    %15 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %32 = arith.index_cast %arg2 : index to i32
      %33 = llvm.getelementptr %6[%32] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %34 = llvm.load %33 : !llvm.ptr -> i8
      %35 = llvm.getelementptr %15[%32] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %34, %35 : i8, !llvm.ptr
    }
    %16 = memref.load %alloca_5[%c0] : memref<1xi32>
    %17 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %18 = call @ncclCommInitRank(%cast_14, %14, %17, %16) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %19 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_15 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %20 = call @ncclCommCount(%19, %cast_15) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %21 = memref.load %alloca_0[%c0] : memref<1xi32>
    %22 = arith.cmpi slt, %21, %c256_i32 : i32
    scf.if %22 {
      %32 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %33 = "polygeist.memref2pointer"(%32) : (memref<?xi32>) -> !llvm.ptr
      %34 = "polygeist.pointer2memref"(%33) : (!llvm.ptr) -> memref<?xi8>
      %35 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %36 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %37 = func.call @ncclAllGather(%34, %34, %c0_i64, %c2_i32, %35, %36) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    }
    %23 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %24 = call @cudaStreamSynchronize(%23) : (memref<?x!llvm.struct<()>>) -> i32
    %25 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %26 = "polygeist.memref2pointer"(%25) : (memref<?xi32>) -> !llvm.ptr
    %27 = "polygeist.pointer2memref"(%26) : (!llvm.ptr) -> memref<?xi8>
    %28 = call @cudaFree(%27) : (memref<?xi8>) -> i32
    %29 = memref.load %alloca_3[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %30 = call @ncclCommDestroy(%29) : (memref<?x!llvm.struct<()>>) -> i32
    %31 = call @MPI_Finalize() : () -> i32
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
  func.func private @ncclCommCount(memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclAllGather(memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}
