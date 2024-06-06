module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128_i64 = arith.constant 128 : i64
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c13_i32 = arith.constant 13 : i32
    %c0_i64 = arith.constant 0 : i64
    %c2_i32 = arith.constant 2 : i32
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c4_i64 = arith.constant 4 : i64
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %1 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> : () -> !spmd.datatype
    %2 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> : () -> !spmd.reduceOp
    %3 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %4 = "spmd.castStream"(%alloca_0) <{usedModel = 1 : i32}> : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_1 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %5 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_4 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_4 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %6 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %7 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %7 {
      %45 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %8 = "polygeist.memref2pointer"(%alloca_4) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %9 = "polygeist.pointer2memref"(%8) : (!llvm.ptr) -> memref<?xi8>
    %error_5 = "spmd.bcast"(%3, %9, %9, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %10 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %11 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %13 = call @cudaMalloc(%12, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %14 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %15 = "polygeist.memref2pointer"(%14) : (memref<?xi32>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
    %17 = call @cudaMemset(%16, %c13_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %18 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %19 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %20 = call @cudaMalloc(%19, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %21 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %22 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %23 = call @cudaMalloc(%22, %c0_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_6 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %24 = call @cudaStreamCreate(%cast_6) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %25 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %45 = arith.index_cast %arg2 : index to i32
      %46 = llvm.getelementptr %8[%45] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %47 = llvm.load %46 : !llvm.ptr -> i8
      %48 = llvm.getelementptr %25[%45] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %47, %48 : i8, !llvm.ptr
    }
    %26 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %rank_7, %error_8 = "spmd.getRankInComm"(%5) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %27 = arith.remsi %rank_7, %c2_i32 : i32
    %newComm, %error_9 = "spmd.commSplit"(%5, %27, %rank_7) <{usedModel = 1 : i32}> : (!spmd.comm, i32, i32) -> (!spmd.comm, !spmd.error)
    %28 = arith.remsi %rank_7, %c2_i32 : i32
    %29 = arith.cmpi ne, %28, %c0_i32 : i32
    scf.if %29 {
      %45 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %46 = "polygeist.memref2pointer"(%45) : (memref<?xi32>) -> !llvm.ptr
      %47 = "polygeist.pointer2memref"(%46) : (!llvm.ptr) -> memref<?xi8>
      %48 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %49 = "polygeist.memref2pointer"(%48) : (memref<?xi32>) -> !llvm.ptr
      %50 = "polygeist.pointer2memref"(%49) : (!llvm.ptr) -> memref<?xi8>
      %error_10 = "spmd.reduce"(%newComm, %47, %50, %c1_i64, %0, %2, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
      %51 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %52 = "polygeist.memref2pointer"(%51) : (memref<?xi32>) -> !llvm.ptr
      %53 = "polygeist.pointer2memref"(%52) : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.allgather"(%5, %53, %c0_i64, %0, %53, %c0_i64, %0, %4) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    } else {
      %45 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %46 = "polygeist.memref2pointer"(%45) : (memref<?xi32>) -> !llvm.ptr
      %47 = "polygeist.pointer2memref"(%46) : (!llvm.ptr) -> memref<?xi8>
      %error_10 = "spmd.allgather"(%5, %47, %c0_i64, %0, %47, %c0_i64, %0, %4) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
      %48 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %49 = "polygeist.memref2pointer"(%48) : (memref<?xi32>) -> !llvm.ptr
      %50 = "polygeist.pointer2memref"(%49) : (!llvm.ptr) -> memref<?xi8>
      %51 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
      %52 = "polygeist.memref2pointer"(%51) : (memref<?xi32>) -> !llvm.ptr
      %53 = "polygeist.pointer2memref"(%52) : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.reduce"(%newComm, %50, %53, %c1_i64, %0, %2, %c0_i32, %4) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    }
    %30 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %31 = call @cudaStreamSynchronize(%30) : (memref<?x!llvm.struct<()>>) -> i32
    %32 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %33 = "polygeist.memref2pointer"(%32) : (memref<?xi32>) -> !llvm.ptr
    %34 = "polygeist.pointer2memref"(%33) : (!llvm.ptr) -> memref<?xi8>
    %35 = call @cudaFree(%34) : (memref<?xi8>) -> i32
    %36 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %37 = "polygeist.memref2pointer"(%36) : (memref<?xi32>) -> !llvm.ptr
    %38 = "polygeist.pointer2memref"(%37) : (!llvm.ptr) -> memref<?xi8>
    %39 = call @cudaFree(%38) : (memref<?xi8>) -> i32
    %40 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %41 = "polygeist.memref2pointer"(%40) : (memref<?xi32>) -> !llvm.ptr
    %42 = "polygeist.pointer2memref"(%41) : (!llvm.ptr) -> memref<?xi8>
    %43 = call @cudaFree(%42) : (memref<?xi8>) -> i32
    %44 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

