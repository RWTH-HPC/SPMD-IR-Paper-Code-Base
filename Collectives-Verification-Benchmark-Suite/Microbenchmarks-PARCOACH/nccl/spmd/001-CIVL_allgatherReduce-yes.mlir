module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str3("total sum is %d\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str2("process %d exits allgather\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("process %d enters allgather\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("process %d has local sum of %d\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128_i64 = arith.constant 128 : i64
    %c0_i32 = arith.constant 0 : i32
    %c2_i32 = arith.constant 2 : i32
    %c128 = arith.constant 128 : index
    %c1_i32 = arith.constant 1 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c4_i64 = arith.constant 4 : i64
    %c1_i64 = arith.constant 1 : i64
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> : () -> !spmd.reduceOp
    %3 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %4 = llvm.mlir.undef : i32
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %5 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %6 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_4 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_4 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_5 = memref.alloca() : memref<1xi32>
    memref.store %4, %alloca_5[%c0] : memref<1xi32>
    %7 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %size, %error = "spmd.getSizeOfComm"(%3) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %rank, %error_6 = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %8 = arith.addi %rank, %c1_i32 : i32
    %9 = arith.index_cast %8 : i32 to index
    %10 = scf.for %arg2 = %c0 to %9 step %c1 iter_args(%arg3 = %c0_i32) -> (i32) {
      %54 = arith.index_cast %arg2 : index to i32
      %55 = arith.addi %arg3, %54 : i32
      scf.yield %55 : i32
    }
    %11 = llvm.mlir.addressof @str0 : !llvm.ptr
    %12 = llvm.getelementptr %11[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<32 x i8>
    %13 = llvm.call @printf(%12, %rank, %10) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32) -> i32
    %14 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %14 {
      %54 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %15 = "polygeist.memref2pointer"(%alloca_4) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
    %error_7 = "spmd.bcast"(%3, %16, %16, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %17 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %18 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %19 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %20 = call @cudaMalloc(%19, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %21 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %22 = "polygeist.memref2pointer"(%21) : (memref<?xi32>) -> !llvm.ptr
    %23 = "polygeist.pointer2memref"(%22) : (!llvm.ptr) -> memref<?xi8>
    %24 = call @cudaMemset(%23, %10, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %25 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %26 = "polygeist.pointer2memref"(%25) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %27 = call @cudaMalloc(%26, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %28 = arith.extsi %size : i32 to i64
    %29 = arith.muli %28, %c4_i64 : i64
    %30 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %31 = "polygeist.pointer2memref"(%30) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %32 = call @cudaMalloc(%31, %29) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_8 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %33 = call @cudaStreamCreate(%cast_8) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %34 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %54 = arith.index_cast %arg2 : index to i32
      %55 = llvm.getelementptr %15[%54] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %56 = llvm.load %55 : !llvm.ptr -> i8
      %57 = llvm.getelementptr %34[%54] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %56, %57 : i8, !llvm.ptr
    }
    %35 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %rank_9, %error_10 = "spmd.getRankInComm"(%6) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %36 = arith.remsi %rank_9, %c2_i32 : i32
    %37 = arith.cmpi ne, %36, %c0_i32 : i32
    scf.if %37 {
      %54 = llvm.mlir.addressof @str1 : !llvm.ptr
      %55 = llvm.getelementptr %54[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<29 x i8>
      %56 = llvm.call @printf(%55, %rank_9) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %57 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %58 = "polygeist.memref2pointer"(%57) : (memref<?xi32>) -> !llvm.ptr
      %59 = "polygeist.pointer2memref"(%58) : (!llvm.ptr) -> memref<?xi8>
      %60 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %61 = "polygeist.memref2pointer"(%60) : (memref<?xi32>) -> !llvm.ptr
      %62 = "polygeist.pointer2memref"(%61) : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.allgather"(%6, %59, %c1_i64, %0, %62, %c1_i64, %0, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
      %63 = llvm.mlir.addressof @str2 : !llvm.ptr
      %64 = llvm.getelementptr %63[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<28 x i8>
      %65 = llvm.call @printf(%64, %rank_9) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %66 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %67 = "polygeist.memref2pointer"(%66) : (memref<?xi32>) -> !llvm.ptr
      %68 = "polygeist.pointer2memref"(%67) : (!llvm.ptr) -> memref<?xi8>
      %69 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %70 = "polygeist.memref2pointer"(%69) : (memref<?xi32>) -> !llvm.ptr
      %71 = "polygeist.pointer2memref"(%70) : (!llvm.ptr) -> memref<?xi8>
      %error_12 = "spmd.reduce"(%6, %68, %71, %c1_i64, %0, %2, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    } else {
      %54 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %55 = "polygeist.memref2pointer"(%54) : (memref<?xi32>) -> !llvm.ptr
      %56 = "polygeist.pointer2memref"(%55) : (!llvm.ptr) -> memref<?xi8>
      %57 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %58 = "polygeist.memref2pointer"(%57) : (memref<?xi32>) -> !llvm.ptr
      %59 = "polygeist.pointer2memref"(%58) : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.reduce"(%6, %56, %59, %c1_i64, %0, %2, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
      %60 = llvm.mlir.addressof @str1 : !llvm.ptr
      %61 = llvm.getelementptr %60[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<29 x i8>
      %62 = llvm.call @printf(%61, %rank_9) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %63 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %64 = "polygeist.memref2pointer"(%63) : (memref<?xi32>) -> !llvm.ptr
      %65 = "polygeist.pointer2memref"(%64) : (!llvm.ptr) -> memref<?xi8>
      %66 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %67 = "polygeist.memref2pointer"(%66) : (memref<?xi32>) -> !llvm.ptr
      %68 = "polygeist.pointer2memref"(%67) : (!llvm.ptr) -> memref<?xi8>
      %error_12 = "spmd.allgather"(%6, %65, %c1_i64, %0, %68, %c1_i64, %0, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
      %69 = llvm.mlir.addressof @str2 : !llvm.ptr
      %70 = llvm.getelementptr %69[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<28 x i8>
      %71 = llvm.call @printf(%70, %rank_9) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %38 = arith.cmpi eq, %rank_9, %c0_i32 : i32
    scf.if %38 {
      %54 = "polygeist.memref2pointer"(%alloca_5) : (memref<1xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) : (!llvm.ptr) -> memref<?xi8>
      %59 = func.call @cudaMemcpy(%55, %58, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
      %60 = llvm.mlir.addressof @str3 : !llvm.ptr
      %61 = llvm.getelementptr %60[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<17 x i8>
      %62 = memref.load %alloca_5[%c0] : memref<1xi32>
      %63 = llvm.call @printf(%61, %62) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %39 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %40 = call @cudaStreamSynchronize(%39) : (memref<?x!llvm.struct<()>>) -> i32
    %41 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %42 = "polygeist.memref2pointer"(%41) : (memref<?xi32>) -> !llvm.ptr
    %43 = "polygeist.pointer2memref"(%42) : (!llvm.ptr) -> memref<?xi8>
    %44 = call @cudaFree(%43) : (memref<?xi8>) -> i32
    %45 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %46 = "polygeist.memref2pointer"(%45) : (memref<?xi32>) -> !llvm.ptr
    %47 = "polygeist.pointer2memref"(%46) : (!llvm.ptr) -> memref<?xi8>
    %48 = call @cudaFree(%47) : (memref<?xi8>) -> i32
    %49 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %50 = "polygeist.memref2pointer"(%49) : (memref<?xi32>) -> !llvm.ptr
    %51 = "polygeist.pointer2memref"(%50) : (!llvm.ptr) -> memref<?xi8>
    %52 = call @cudaFree(%51) : (memref<?xi8>) -> i32
    %53 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemcpy(memref<?xi8>, memref<?xi8>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

