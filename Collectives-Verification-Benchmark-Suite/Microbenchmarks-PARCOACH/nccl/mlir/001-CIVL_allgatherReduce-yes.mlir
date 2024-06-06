module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str3("total sum is %d\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str2("process %d exits allgather\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("process %d enters allgather\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("process %d has local sum of %d\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128 = arith.constant 128 : index
    %c1_i32 = arith.constant 1 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c1_i64 = arith.constant 1 : i64
    %c2_i32 = arith.constant 2 : i32
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
    %4 = memref.load %alloca_9[%c0] : memref<1xi32>
    %5 = arith.addi %4, %c1_i32 : i32
    %6 = arith.index_cast %5 : i32 to index
    %7 = scf.for %arg2 = %c0 to %6 step %c1 iter_args(%arg3 = %c0_i32) -> (i32) {
      %62 = arith.index_cast %arg2 : index to i32
      %63 = arith.addi %arg3, %62 : i32
      scf.yield %63 : i32
    }
    %8 = llvm.mlir.addressof @str0 : !llvm.ptr
    %9 = llvm.getelementptr %8[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<32 x i8>
    %10 = llvm.call @printf(%9, %4, %7) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32) -> i32
    %11 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %11 {
      %62 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %12 = "polygeist.memref2pointer"(%alloca_6) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
    %14 = call @MPI_Bcast(%13, %c128_i32, %c1275068685_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %15 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %16 = "polygeist.memref2pointer"(%alloca_4) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %17 = "polygeist.pointer2memref"(%16) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %18 = call @cudaMalloc(%17, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %19 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %20 = "polygeist.memref2pointer"(%19) : (memref<?xi32>) -> !llvm.ptr
    %21 = "polygeist.pointer2memref"(%20) : (!llvm.ptr) -> memref<?xi8>
    %22 = call @cudaMemset(%21, %7, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %23 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %24 = "polygeist.pointer2memref"(%23) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %25 = call @cudaMalloc(%24, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %26 = memref.load %alloca_8[%c0] : memref<1xi32>
    %27 = arith.extsi %26 : i32 to i64
    %28 = arith.muli %27, %c4_i64 : i64
    %29 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %30 = "polygeist.pointer2memref"(%29) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %31 = call @cudaMalloc(%30, %28) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_16 = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %32 = call @cudaStreamCreate(%cast_16) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_17 = memref.cast %alloca_5 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %33 = memref.load %alloca_8[%c0] : memref<1xi32>
    %34 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %62 = arith.index_cast %arg2 : index to i32
      %63 = llvm.getelementptr %12[%62] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %64 = llvm.load %63 : !llvm.ptr -> i8
      %65 = llvm.getelementptr %34[%62] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %64, %65 : i8, !llvm.ptr
    }
    %35 = memref.load %alloca_9[%c0] : memref<1xi32>
    %36 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %37 = call @ncclCommInitRank(%cast_17, %33, %36, %35) : (memref<?xmemref<?x!llvm.struct<()>>>, i32, !llvm.struct<(array<128 x i8>)>, i32) -> i32
    %38 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_18 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %39 = call @ncclCommUserRank(%38, %cast_18) : (memref<?x!llvm.struct<()>>, memref<?xi32>) -> i32
    %40 = memref.load %alloca_0[%c0] : memref<1xi32>
    %41 = arith.remsi %40, %c2_i32 : i32
    %42 = arith.cmpi ne, %41, %c0_i32 : i32
    scf.if %42 {
      %62 = llvm.mlir.addressof @str1 : !llvm.ptr
      %63 = llvm.getelementptr %62[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<29 x i8>
      %64 = llvm.call @printf(%63, %40) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %65 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %66 = "polygeist.memref2pointer"(%65) : (memref<?xi32>) -> !llvm.ptr
      %67 = "polygeist.pointer2memref"(%66) : (!llvm.ptr) -> memref<?xi8>
      %68 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %69 = "polygeist.memref2pointer"(%68) : (memref<?xi32>) -> !llvm.ptr
      %70 = "polygeist.pointer2memref"(%69) : (!llvm.ptr) -> memref<?xi8>
      %71 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %72 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %73 = func.call @ncclAllGather(%67, %70, %c1_i64, %c2_i32, %71, %72) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %74 = llvm.mlir.addressof @str2 : !llvm.ptr
      %75 = llvm.getelementptr %74[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<28 x i8>
      %76 = memref.load %alloca_0[%c0] : memref<1xi32>
      %77 = llvm.call @printf(%75, %76) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %78 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %79 = "polygeist.memref2pointer"(%78) : (memref<?xi32>) -> !llvm.ptr
      %80 = "polygeist.pointer2memref"(%79) : (!llvm.ptr) -> memref<?xi8>
      %81 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %82 = "polygeist.memref2pointer"(%81) : (memref<?xi32>) -> !llvm.ptr
      %83 = "polygeist.pointer2memref"(%82) : (!llvm.ptr) -> memref<?xi8>
      %84 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %85 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %86 = func.call @ncclReduce(%80, %83, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %84, %85) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
    } else {
      %62 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %63 = "polygeist.memref2pointer"(%62) : (memref<?xi32>) -> !llvm.ptr
      %64 = "polygeist.pointer2memref"(%63) : (!llvm.ptr) -> memref<?xi8>
      %65 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %66 = "polygeist.memref2pointer"(%65) : (memref<?xi32>) -> !llvm.ptr
      %67 = "polygeist.pointer2memref"(%66) : (!llvm.ptr) -> memref<?xi8>
      %68 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %69 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %70 = func.call @ncclReduce(%64, %67, %c1_i64, %c2_i32, %c0_i32, %c0_i32, %68, %69) : (memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %71 = llvm.mlir.addressof @str1 : !llvm.ptr
      %72 = llvm.getelementptr %71[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<29 x i8>
      %73 = memref.load %alloca_0[%c0] : memref<1xi32>
      %74 = llvm.call @printf(%72, %73) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %75 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
      %76 = "polygeist.memref2pointer"(%75) : (memref<?xi32>) -> !llvm.ptr
      %77 = "polygeist.pointer2memref"(%76) : (!llvm.ptr) -> memref<?xi8>
      %78 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %79 = "polygeist.memref2pointer"(%78) : (memref<?xi32>) -> !llvm.ptr
      %80 = "polygeist.pointer2memref"(%79) : (!llvm.ptr) -> memref<?xi8>
      %81 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %82 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %83 = func.call @ncclAllGather(%77, %80, %c1_i64, %c2_i32, %81, %82) : (memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32
      %84 = llvm.mlir.addressof @str2 : !llvm.ptr
      %85 = llvm.getelementptr %84[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<28 x i8>
      %86 = memref.load %alloca_0[%c0] : memref<1xi32>
      %87 = llvm.call @printf(%85, %86) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %43 = memref.load %alloca_0[%c0] : memref<1xi32>
    %44 = arith.cmpi eq, %43, %c0_i32 : i32
    scf.if %44 {
      %62 = "polygeist.memref2pointer"(%alloca_7) : (memref<1xi32>) -> !llvm.ptr
      %63 = "polygeist.pointer2memref"(%62) : (!llvm.ptr) -> memref<?xi8>
      %64 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %65 = "polygeist.memref2pointer"(%64) : (memref<?xi32>) -> !llvm.ptr
      %66 = "polygeist.pointer2memref"(%65) : (!llvm.ptr) -> memref<?xi8>
      %67 = func.call @cudaMemcpy(%63, %66, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %68 = llvm.mlir.addressof @str3 : !llvm.ptr
      %69 = llvm.getelementptr %68[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<17 x i8>
      %70 = memref.load %alloca_7[%c0] : memref<1xi32>
      %71 = llvm.call @printf(%69, %70) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %45 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %46 = call @cudaStreamSynchronize(%45) : (memref<?x!llvm.struct<()>>) -> i32
    %47 = memref.load %alloca_4[%c0] : memref<1xmemref<?xi32>>
    %48 = "polygeist.memref2pointer"(%47) : (memref<?xi32>) -> !llvm.ptr
    %49 = "polygeist.pointer2memref"(%48) : (!llvm.ptr) -> memref<?xi8>
    %50 = call @cudaFree(%49) : (memref<?xi8>) -> i32
    %51 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %52 = "polygeist.memref2pointer"(%51) : (memref<?xi32>) -> !llvm.ptr
    %53 = "polygeist.pointer2memref"(%52) : (!llvm.ptr) -> memref<?xi8>
    %54 = call @cudaFree(%53) : (memref<?xi8>) -> i32
    %55 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %56 = "polygeist.memref2pointer"(%55) : (memref<?xi32>) -> !llvm.ptr
    %57 = "polygeist.pointer2memref"(%56) : (!llvm.ptr) -> memref<?xi8>
    %58 = call @cudaFree(%57) : (memref<?xi8>) -> i32
    %59 = memref.load %alloca_5[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %60 = call @ncclCommDestroy(%59) : (memref<?x!llvm.struct<()>>) -> i32
    %61 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
  func.func private @ncclAllGather(memref<?xi8>, memref<?xi8>, i64, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclReduce(memref<?xi8>, memref<?xi8>, i64, i32, i32, i32, memref<?x!llvm.struct<()>>, memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @ncclCommDestroy(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

