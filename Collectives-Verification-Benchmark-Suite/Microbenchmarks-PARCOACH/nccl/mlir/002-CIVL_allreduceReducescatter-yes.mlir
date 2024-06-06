module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str0("process %d with device %d receives %d\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c4 = arith.constant 4 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c2_i32 = arith.constant 2 : i32
    %c1_i32 = arith.constant 1 : i32
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
    %alloca_4 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_5 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_6 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_7 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_7 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
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
    %cast_14 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_14) : (i32, memref<?xi32>) -> i32
    %cast_15 = memref.cast %alloca_9 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_15) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_8[%c0] : memref<1xi32>
    %5 = arith.extsi %4 : i32 to i64
    %6 = arith.muli %5, %c4_i64 : i64
    %7 = arith.index_cast %6 : i64 to index
    %8 = arith.divui %7, %c4 : index
    %alloc = memref.alloc(%8) : memref<?xi32>
    %alloc_16 = memref.alloc() : memref<1xi32>
    %9 = memref.load %alloca_9[%c0] : memref<1xi32>
    %10 = arith.cmpi eq, %9, %c0_i32 : i32
    scf.if %10 {
      %59 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %11 = "polygeist.memref2pointer"(%alloca_7) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xi8>
    %13 = call @MPI_Bcast(%12, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %14 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %15 = memref.load %alloca_8[%c0] : memref<1xi32>
    %16 = arith.extsi %15 : i32 to i64
    %17 = arith.muli %16, %c4_i64 : i64
    %18 = "polygeist.memref2pointer"(%alloca_5) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %19 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %20 = call @cudaMalloc(%19, %17) : (memref<?xmemref<?xi8>>, i64) -> i32
    %21 = memref.load %alloca_8[%c0] : memref<1xi32>
    %22 = arith.extsi %21 : i32 to i64
    %23 = arith.muli %22, %c4_i64 : i64
    %24 = "polygeist.memref2pointer"(%alloca_4) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %25 = "polygeist.pointer2memref"(%24) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %26 = call @cudaMalloc(%25, %23) : (memref<?xmemref<?xi8>>, i64) -> i32
    %27 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %28 = "polygeist.pointer2memref"(%27) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %29 = call @cudaMalloc(%28, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_17 = memref.cast %alloca_2 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %30 = call @cudaStreamCreate(%cast_17) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_18 = memref.cast %alloca_6 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %31 = memref.load %alloca_8[%c0] : memref<1xi32>
    %32 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %59 = arith.index_cast %arg2 : index to i32
      %60 = llvm.getelementptr %11[%59] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %61 = llvm.load %60 : !llvm.ptr -> i8
      %62 = llvm.getelementptr %32[%59] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %61, %62 : i8, !llvm.ptr
    }
    %33 = memref.load %alloca_9[%c0] : memref<1xi32>
    %34 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %35 = call @ncclCommInitRank(%cast_18, %31, %34, %33) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %36 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_19 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %37 = call @ncclCommUserRank(%36, %cast_19) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %38 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_20 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %39 = call @ncclCommCuDevice(%38, %cast_20) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %40 = memref.load %alloca_0[%c0] : memref<1xi32>
    %41 = arith.cmpi eq, %40, %c0_i32 : i32
    scf.if %41 {
      %59 = memref.load %alloca_8[%c0] : memref<1xi32>
      %60 = arith.index_cast %59 : i32 to index
      scf.for %arg2 = %c0 to %60 step %c1 {
        %91 = arith.index_cast %arg2 : index to i32
        %92 = arith.subi %59, %91 : i32
        memref.store %92, %alloc[%arg2] : memref<?xi32>
      }
      %61 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
      %62 = "polygeist.memref2pointer"(%61) : (memref<?xi32>) -> !llvm.ptr
      %63 = "polygeist.pointer2memref"(%62) : (!llvm.ptr) -> memref<?xi8>
      %64 = "polygeist.memref2pointer"(%alloc) : (memref<?xi32>) -> !llvm.ptr
      %65 = "polygeist.pointer2memref"(%64) : (!llvm.ptr) -> memref<?xi8>
      %66 = arith.extsi %59 : i32 to i64
      %67 = arith.muli %66, %c4_i64 : i64
      %68 = func.call @cudaMemcpy(%63, %65, %67, %c1_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %69 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
      %70 = "polygeist.memref2pointer"(%69) : (memref<?xi32>) -> !llvm.ptr
      %71 = "polygeist.pointer2memref"(%70) : (!llvm.ptr) -> memref<?xi8>
      %72 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %73 = "polygeist.memref2pointer"(%72) : (memref<?xi32>) -> !llvm.ptr
      %74 = "polygeist.pointer2memref"(%73) : (!llvm.ptr) -> memref<?xi8>
      %75 = memref.load %alloca_8[%c0] : memref<1xi32>
      %76 = arith.extsi %75 : i32 to i64
      %77 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %78 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %79 = func.call @ncclAllReduce(%71, %74, %76, %c2_i32, %c0_i32, %77, %78) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %80 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
      %81 = "polygeist.memref2pointer"(%80) : (memref<?xi32>) -> !llvm.ptr
      %82 = "polygeist.pointer2memref"(%81) : (!llvm.ptr) -> memref<?xi8>
      %83 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %84 = "polygeist.memref2pointer"(%83) : (memref<?xi32>) -> !llvm.ptr
      %85 = "polygeist.pointer2memref"(%84) : (!llvm.ptr) -> memref<?xi8>
      %86 = memref.load %alloca_8[%c0] : memref<1xi32>
      %87 = arith.extsi %86 : i32 to i64
      %88 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %89 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %90 = func.call @ncclReduceScatter(%82, %85, %87, %c2_i32, %c0_i32, %88, %89) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %59 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
      %60 = "polygeist.memref2pointer"(%59) : (memref<?xi32>) -> !llvm.ptr
      %61 = "polygeist.pointer2memref"(%60) : (!llvm.ptr) -> memref<?xi8>
      %62 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %63 = "polygeist.memref2pointer"(%62) : (memref<?xi32>) -> !llvm.ptr
      %64 = "polygeist.pointer2memref"(%63) : (!llvm.ptr) -> memref<?xi8>
      %65 = memref.load %alloca_8[%c0] : memref<1xi32>
      %66 = arith.extsi %65 : i32 to i64
      %67 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %68 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %69 = func.call @ncclReduceScatter(%61, %64, %66, %c2_i32, %c0_i32, %67, %68) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %70 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
      %71 = "polygeist.memref2pointer"(%70) : (memref<?xi32>) -> !llvm.ptr
      %72 = "polygeist.pointer2memref"(%71) : (!llvm.ptr) -> memref<?xi8>
      %73 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %74 = "polygeist.memref2pointer"(%73) : (memref<?xi32>) -> !llvm.ptr
      %75 = "polygeist.pointer2memref"(%74) : (!llvm.ptr) -> memref<?xi8>
      %76 = memref.load %alloca_8[%c0] : memref<1xi32>
      %77 = arith.extsi %76 : i32 to i64
      %78 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %79 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %80 = func.call @ncclAllReduce(%72, %75, %77, %c2_i32, %c0_i32, %78, %79) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %81 = "polygeist.memref2pointer"(%alloc_16) : (memref<1xi32>) -> !llvm.ptr
      %82 = "polygeist.pointer2memref"(%81) : (!llvm.ptr) -> memref<?xi8>
      %83 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %84 = "polygeist.memref2pointer"(%83) : (memref<?xi32>) -> !llvm.ptr
      %85 = "polygeist.pointer2memref"(%84) : (!llvm.ptr) -> memref<?xi8>
      %86 = func.call @cudaMemcpy(%82, %85, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %87 = llvm.mlir.addressof @str0 : !llvm.ptr
      %88 = llvm.getelementptr %87[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<39 x i8>
      %89 = memref.load %alloca_0[%c0] : memref<1xi32>
      %90 = memref.load %alloca_1[%c0] : memref<1xi32>
      %91 = memref.load %alloc_16[%c0] : memref<1xi32>
      %92 = llvm.call @printf(%88, %89, %90, %91) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32, i32) -> i32
    }
    %42 = memref.load %alloca_2[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %43 = call @cudaStreamSynchronize(%42) : (memref<?x!llvm.struct<()>>) -> i32
    %44 = memref.load %alloca_5[%c0] : memref<1xmemref<?xi32>>
    %45 = "polygeist.memref2pointer"(%44) : (memref<?xi32>) -> !llvm.ptr
    %46 = "polygeist.pointer2memref"(%45) : (!llvm.ptr) -> memref<?xi8>
    %47 = call @cudaFree(%46) : (memref<?xi8>) -> i32
    %48 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %49 = "polygeist.memref2pointer"(%48) : (memref<?xi32>) -> !llvm.ptr
    %50 = "polygeist.pointer2memref"(%49) : (!llvm.ptr) -> memref<?xi8>
    %51 = call @cudaFree(%50) : (memref<?xi8>) -> i32
    %52 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %53 = "polygeist.memref2pointer"(%52) : (memref<?xi32>) -> !llvm.ptr
    %54 = "polygeist.pointer2memref"(%53) : (!llvm.ptr) -> memref<?xi8>
    %55 = call @cudaFree(%54) : (memref<?xi8>) -> i32
    %56 = memref.load %alloca_6[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %57 = call @ncclCommDestroy(%56) : (memref<?x!llvm.struct<()>>) -> i32
    memref.dealloc %alloc : memref<?xi32>
    memref.dealloc %alloc_16 : memref<1xi32>
    %58 = call @MPI_Finalize() : () -> i32
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
  func.func private @ncclCommCuDevice(memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclAllReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclReduceScatter(memref<?xi8>, memref<?xi8>, i64, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

