module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c0_i32 = arith.constant 0 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1x5xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_1[%c0] : memref<1xi32>
    %alloca_2 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_2[%c0] : memref<1xi32>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_4 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_4[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_3[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32>
    %cast_5 = memref.cast %alloca_3 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast, %cast_5) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_6 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_6) : (i32, memref<?xi32>) -> i32
    %cast_7 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_size(%c1140850688_i32, %cast_7) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_1[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %alloca_8 = memref.alloca(%5) : memref<?xi32>
    %alloca_9 = memref.alloca(%5) : memref<?xi32>
    %6 = memref.load %alloca_2[%c0] : memref<1xi32>
    %7 = arith.extsi %6 : i32 to i64
    scf.for %arg2 = %c0 to %5 step %c1 {
      %12 = arith.index_cast %arg2 : index to i64
      %13 = arith.muli %12, %7 : i64
      %14 = arith.trunci %13 : i64 to i32
      memref.store %14, %alloca_8[%arg2] : memref<?xi32>
    }
    %8 = memref.load %alloca_2[%c0] : memref<1xi32>
    %9 = arith.remsi %8, %c2_i32 : i32
    %10 = arith.cmpi ne, %9, %c0_i32 : i32
    scf.if %10 {
      %12 = "polygeist.memref2pointer"(%alloca_8) : (memref<?xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = "polygeist.memref2pointer"(%alloca_9) : (memref<?xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %16 = func.call @MPI_Alltoall(%13, %4, %c1275069445_i32, %15, %4, %c1275069445_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32) -> i32
    } else {
      %12 = "polygeist.memref2pointer"(%alloca_8) : (memref<?xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = "polygeist.memref2pointer"(%alloca_9) : (memref<?xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %cast_10 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
      %16 = func.call @MPI_Ialltoall(%13, %4, %c1275069445_i32, %15, %4, %c1275069445_i32, %c1140850688_i32, %cast_10) : (memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32, memref<?xi32>) -> i32
      %cast_11 = memref.cast %alloca : memref<1x5xi32> to memref<?x5xi32>
      %17 = func.call @MPI_Wait(%cast_10, %cast_11) : (memref<?xi32>, memref<?x5xi32>) -> i32
    }
    %11 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Alltoall(memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Ialltoall(memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Wait(memref<?xi32>, memref<?x5xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

