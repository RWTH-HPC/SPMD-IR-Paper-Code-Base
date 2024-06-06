module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c4_i64 = arith.constant 4 : i64
    %c0_i64 = arith.constant 0 : i64
    %0 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 1 : i32}> : () -> !spmd.datatype
    %c2_i32 = arith.constant 2 : i32
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> : () -> !spmd.datatype
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c42_i32 = arith.constant 42 : i32
    %c13_i32 = arith.constant 13 : i32
    %c1_i64 = arith.constant 1 : i64
    %2 = "spmd.constDatatype"() <{typeAttr = i8, usedModel = 0 : i32}> : () -> !spmd.datatype
    %c1275068685_i32 = arith.constant 1275068685 : i32
    %3 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 1 : i32}> : () -> !spmd.reduceOp
    %c0_i32 = arith.constant 0 : i32
    %4 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %5 = llvm.mlir.undef : i32
    memref.store %5, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %6 = "spmd.castStream"(%alloca_1) <{usedModel = 1 : i32}> : (memref<1xmemref<?x!llvm.struct<()>>>) -> !spmd.stream
    %alloca_2 = memref.alloca() : memref<1xmemref<?xi32>>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xi32>>
    %7 = "spmd.commWorld"() <{usedModel = 1 : i32}> : () -> !spmd.comm
    %alloca_4 = memref.alloca() : memref<1xmemref<?x!llvm.struct<()>>>
    %alloca_5 = memref.alloca() : memref<1x!llvm.struct<(array<128 x i8>)>>
    %cast = memref.cast %alloca_5 : memref<1x!llvm.struct<(array<128 x i8>)>> to memref<?x!llvm.struct<(array<128 x i8>)>>
    %alloca_6 = memref.alloca() : memref<1xi32>
    memref.store %5, %alloca_6[%c0] : memref<1xi32>
    %alloca_7 = memref.alloca() : memref<1xi32>
    memref.store %5, %alloca_7[%c0] : memref<1xi32>
    %alloca_8 = memref.alloca() : memref<1xi32>
    memref.store %5, %alloca_8[%c0] : memref<1xi32>
    %alloca_9 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_10 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_10[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_9[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast_11 = memref.cast %alloca_10 : memref<1xi32> to memref<?xi32>
    %cast_12 = memref.cast %alloca_9 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %8 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %cast_13 = memref.cast %alloca_8 : memref<1xi32> to memref<?xi32>
    %rank, %error = "spmd.getRankInComm"(%4) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %cast_14 = memref.cast %alloca_7 : memref<1xi32> to memref<?xi32>
    %size, %error_15 = "spmd.getSizeOfComm"(%4) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %9 = memref.load %alloca_8[%c0] : memref<1xi32>
    %10 = arith.cmpi eq, %rank, %c0_i32 : i32
    scf.if %10 {
      %54 = func.call @ncclGetUniqueId(%cast) : (memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32
    }
    %11 = "polygeist.memref2pointer"(%alloca_5) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xi8>
    %13 = arith.extui %c128_i32 : i32 to i64
    %error_16 = "spmd.bcast"(%4, %12, %12, %13, %2, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
    %14 = call @cudaSetDevice(%c0_i32) : (i32) -> i32
    %15 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %17 = call @cudaMalloc(%16, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %18 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %19 = "polygeist.memref2pointer"(%18) : (memref<?xi32>) -> !llvm.ptr
    %20 = "polygeist.pointer2memref"(%19) : (!llvm.ptr) -> memref<?xi8>
    %21 = call @cudaMemset(%20, %c13_i32, %c4_i64) : (memref<?xi8>, i32, i64) -> i32
    %22 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xmemref<?xi32>>) -> !llvm.ptr
    %23 = "polygeist.pointer2memref"(%22) : (!llvm.ptr) -> memref<?xmemref<?xi8>>
    %24 = call @cudaMalloc(%23, %c4_i64) : (memref<?xmemref<?xi8>>, i64) -> i32
    %cast_17 = memref.cast %alloca_1 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %25 = call @cudaStreamCreate(%cast_17) : (memref<?xmemref<?x!llvm.struct<()>>>) -> i32
    %cast_18 = memref.cast %alloca_4 : memref<1xmemref<?x!llvm.struct<()>>> to memref<?xmemref<?x!llvm.struct<()>>>
    %26 = memref.load %alloca_7[%c0] : memref<1xi32>
    %27 = "polygeist.memref2pointer"(%alloca) : (memref<1x!llvm.struct<(array<128 x i8>)>>) -> !llvm.ptr
    scf.for %arg2 = %c0 to %c128 step %c1 {
      %54 = arith.index_cast %arg2 : index to i32
      %55 = llvm.getelementptr %11[%54] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      %56 = llvm.load %55 : !llvm.ptr -> i8
      %57 = llvm.getelementptr %27[%54] : (!llvm.ptr, i32) -> !llvm.ptr, i8
      llvm.store %56, %57 : i8, !llvm.ptr
    }
    %28 = memref.load %alloca_8[%c0] : memref<1xi32>
    %29 = memref.load %alloca[%c0] : memref<1x!llvm.struct<(array<128 x i8>)>>
    %30 = "spmd.init"() <{usedModel = 1 : i32}> : () -> !spmd.error
    %31 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %cast_19 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %rank_20, %error_21 = "spmd.getRankInComm"(%7) <{usedModel = 1 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    %32 = memref.load %alloca_0[%c0] : memref<1xi32>
    %33 = arith.cmpi eq, %rank_20, %c0_i32 : i32
    scf.if %33 {
      memref.store %c42_i32, %alloca_6[%c0] : memref<1xi32>
      %54 = "polygeist.memref2pointer"(%alloca_6) : (memref<1xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = arith.extui %c1_i32 : i32 to i64
      %error_23 = "spmd.bcast"(%4, %55, %55, %56, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %57 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %58 = "polygeist.memref2pointer"(%57) : (memref<?xi32>) -> !llvm.ptr
      %59 = "polygeist.pointer2memref"(%58) : (!llvm.ptr) -> memref<?xi8>
      %60 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %61 = "polygeist.memref2pointer"(%60) : (memref<?xi32>) -> !llvm.ptr
      %62 = "polygeist.pointer2memref"(%61) : (!llvm.ptr) -> memref<?xi8>
      %63 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %64 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %error_24 = "spmd.reduce"(%7, %59, %62, %c1_i64, %0, %3, %c0_i32, %6) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    } else {
      %54 = "polygeist.memref2pointer"(%alloca_6) : (memref<1xi32>) -> !llvm.ptr
      %55 = "polygeist.pointer2memref"(%54) : (!llvm.ptr) -> memref<?xi8>
      %56 = arith.extui %c1_i32 : i32 to i64
      %error_23 = "spmd.bcast"(%4, %55, %55, %56, %1, %c0_i32) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, i32) -> !spmd.error
      %57 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
      %58 = "polygeist.memref2pointer"(%57) : (memref<?xi32>) -> !llvm.ptr
      %59 = "polygeist.pointer2memref"(%58) : (!llvm.ptr) -> memref<?xi8>
      %60 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
      %61 = "polygeist.memref2pointer"(%60) : (memref<?xi32>) -> !llvm.ptr
      %62 = "polygeist.pointer2memref"(%61) : (!llvm.ptr) -> memref<?xi8>
      %63 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %64 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
      %error_24 = "spmd.reduce"(%7, %59, %62, %c1_i64, %0, %3, %c0_i32, %6) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, i32, !spmd.stream) -> !spmd.error
    }
    %34 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %35 = "polygeist.memref2pointer"(%34) : (memref<?xi32>) -> !llvm.ptr
    %36 = "polygeist.pointer2memref"(%35) : (!llvm.ptr) -> memref<?xi8>
    %37 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %38 = "polygeist.memref2pointer"(%37) : (memref<?xi32>) -> !llvm.ptr
    %39 = "polygeist.pointer2memref"(%38) : (!llvm.ptr) -> memref<?xi8>
    %40 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %41 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %error_22 = "spmd.reduceScatter"(%7, %36, %39, %c0_i64, %0, %3, %6) <{isBlocking = true, usedModel = 1 : i32}> : (!spmd.comm, memref<?xi8>, memref<?xi8>, i64, !spmd.datatype, !spmd.reduceOp, !spmd.stream) -> !spmd.error
    %42 = memref.load %alloca_1[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %43 = call @cudaStreamSynchronize(%42) : (memref<?x!llvm.struct<()>>) -> i32
    %44 = memref.load %alloca_3[%c0] : memref<1xmemref<?xi32>>
    %45 = "polygeist.memref2pointer"(%44) : (memref<?xi32>) -> !llvm.ptr
    %46 = "polygeist.pointer2memref"(%45) : (!llvm.ptr) -> memref<?xi8>
    %47 = call @cudaFree(%46) : (memref<?xi8>) -> i32
    %48 = memref.load %alloca_2[%c0] : memref<1xmemref<?xi32>>
    %49 = "polygeist.memref2pointer"(%48) : (memref<?xi32>) -> !llvm.ptr
    %50 = "polygeist.pointer2memref"(%49) : (!llvm.ptr) -> memref<?xi8>
    %51 = call @cudaFree(%50) : (memref<?xi8>) -> i32
    %52 = memref.load %alloca_4[%c0] : memref<1xmemref<?x!llvm.struct<()>>>
    %53 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
  func.func private @ncclGetUniqueId(memref<?x!llvm.struct<(array<128 x i8>)>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaSetDevice(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMemset(memref<?xi8>, i32, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaStreamCreate(memref<?xmemref<?x!llvm.struct<()>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
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
  func.func private @cudaStreamSynchronize(memref<?x!llvm.struct<()>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaFree(memref<?xi8>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @cudaMalloc(memref<?xmemref<?xi8>>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

