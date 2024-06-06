module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c128_i64 = arith.constant 128 : i64
    %c42_i32 = arith.constant 42 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c8_i32 = arith.constant 8 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c4_i64 = arith.constant 4 : i64
    %c0_i64 = arith.constant 0 : i64
    %c21_i32 = arith.constant 21 : i32
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
    %6 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_3 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_3 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_4 = memref.alloca() : memref<1xi32>
    memref.store %4, %alloca_4[%c0] : memref<1xi32>
    %7 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%3) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %8 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %8 {
      %56 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %9 = "polygeist.memref2pointer"(%alloca_3) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xi8>
    %error_5 = "spmd.bcast"(%3, %10, %10, %c128_i64, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %11 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %12 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %14 = call @cudaMalloc(%13, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %15 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %16 = "polygeist.memref2pointer"(%15) : (memref<?xi32>) -> !llvm.ptr
    %17 = "polygeist.pointer2memref"(%16) : (!llvm.ptr) -> memref<?xi8>
    %18 = call @cudaMemset(%17, %c42_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %19 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %20 = "polygeist.pointer2memref"(%19) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %21 = call @cudaMalloc(%20, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %22 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %23 = "polygeist.memref2pointer"(%22) : (memref<?xi32>) -> !llvm.ptr
    %24 = "polygeist.pointer2memref"(%23) : (!llvm.ptr) -> memref<?xi8>
    %25 = call @cudaMemset(%24, %c8_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %cast_6 = memref.cast %alloca_0 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %26 = call @cudaStreamCreate(%cast_6) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %27 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %56 = arith.index_cast %arg2 : index to i32
      %57 = llvm.getelementptr %9[%56] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %58 = llvm.load %57 : !llvm.ptr -> i8
      %59 = llvm.getelementptr %27[%56] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %58, %59 : i8, !llvm.ptr
    }
    %28 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %rank_7, %error_8 = "spmd.getRankInComm"(%6) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %29 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %30 = "polygeist.memref2pointer"(%29) : (memref<?xi32>) -> !llvm.ptr
    %31 = "polygeist.pointer2memref"(%30) : (!llvm.ptr) -> memref<?xi8>
    %32 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %33 = "polygeist.memref2pointer"(%32) : (memref<?xi32>) -> !llvm.ptr
    %34 = "polygeist.pointer2memref"(%33) : (!llvm.ptr) -> memref<?xi8>
    %error_9 = "spmd.allreduce"(%6, %31, %34, %c1_i64, %0, %2, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
    %35 = "polygeist.memref2pointer"(%alloca_4) : (memref<1xi32>) -> !llvm.ptr
    %36 = "polygeist.pointer2memref"(%35) : (!llvm.ptr) -> memref<?xi8>
    %37 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %38 = "polygeist.memref2pointer"(%37) : (memref<?xi32>) -> !llvm.ptr
    %39 = "polygeist.pointer2memref"(%38) : (!llvm.ptr) -> memref<?xi8>
    %40 = call @cudaMemcpy(%36, %39, %c4_i64, %c2_i32) : (memref<?xi8>, memref<?xi8>, i64, i32) -> i32
    %41 = arith.cmpi eq, %rank_7, %c0_i32 : i32
    scf.if %41 {
      %56 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %57 = "polygeist.memref2pointer"(%56) : (memref<?xi32>) -> !llvm.ptr
      %58 = "polygeist.pointer2memref"(%57) : (!llvm.ptr) -> memref<?xi8>
      %error_11 = "spmd.bcast"(%6, %58, %58, %c1_i64, %0, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
    } else {
      %56 = memref.load %alloca_4[%c0] : memref<1xi32>
      %57 = arith.cmpi eq, %56, %c21_i32 : i32
      scf.if %57 {
        %58 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
        %59 = "polygeist.memref2pointer"(%58) : (memref<?xi32>) -> !llvm.ptr
        %60 = "polygeist.pointer2memref"(%59) : (!llvm.ptr) -> memref<?xi8>
        %error_11 = "spmd.bcast"(%6, %60, %60, %c1_i64, %0, %c0_i32, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32, !spmd.stream) -> !spmd.error
      }
    }
    %42 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %43 = "polygeist.memref2pointer"(%42) : (memref<?xi32>) -> !llvm.ptr
    %44 = "polygeist.pointer2memref"(%43) : (!llvm.ptr) -> memref<?xi8>
    %error_10 = "spmd.allgather"(%6, %44, %c0_i64, %0, %44, %c0_i64, %0, %5) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, i64, !spmd.datatype, memref<?xi8>, i64, !spmd.datatype, !spmd.stream) -> !spmd.error
    %45 = memref.load %alloca_0[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %46 = call @cudaStreamSynchronize(%45) : (memref<?x!llvm.struct<()>>) -> i32
    %47 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %48 = "polygeist.memref2pointer"(%47) : (memref<?xi32>) -> !llvm.ptr
    %49 = "polygeist.pointer2memref"(%48) : (!llvm.ptr) -> memref<?xi8>
    %50 = call @cudaFree(%49) : (memref<?xi8>) -> i32
    %51 = memref.load %alloca_1[%c0] : memref<1xmemref<?xi32>>
    %52 = "polygeist.memref2pointer"(%51) : (memref<?xi32>) -> !llvm.ptr
    %53 = "polygeist.pointer2memref"(%52) : (!llvm.ptr) -> memref<?xi8>
    %54 = call @cudaFree(%53) : (memref<?xi8>) -> i32
    %55 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
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
