module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c42_i32 = arith.constant 42 : i32
    %alloca = memref.alloca() : memref<1x5xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    %alloca_2 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_2[%c0] : memref<1xi32>
    %alloca_3 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_3[%c0] : memref<1xi32>
    %alloca_4 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_5 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_5[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_4[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    memref.store %c42_i32, %alloca_1[%c0] : memref<1xi32>
    %cast = memref.cast %alloca_5 : memref<1xi32> to memref<?xi32>
    %cast_6 = memref.cast %alloca_4 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast, %cast_6) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_7 = memref.cast %alloca_3 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_7) : (i32, memref<?xi32>) -> i32
    %cast_8 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_size(%c1140850688_i32, %cast_8) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_2[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %alloca_9 = memref.alloca(%5) : memref<?xi32>
    %6 = memref.load %alloca_3[%c0] : memref<1xi32>
    %7 = arith.remsi %6, %c2_i32 : i32
    %8 = arith.cmpi ne, %7, %c0_i32 : i32
    scf.if %8 {
      %10 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xi32>) -> !llvm.ptr
      %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xi8>
      %12 = "polygeist.memref2pointer"(%alloca_9) : (memref<?xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = func.call @MPI_Allgather(%11, %c1_i32, %c1275069445_i32, %13, %4, %c1275069445_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32) -> i32
    } else {
      %10 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xi32>) -> !llvm.ptr
      %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?xi8>
      %12 = "polygeist.memref2pointer"(%alloca_9) : (memref<?xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %cast_10 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
      %14 = func.call @MPI_Iallgather(%11, %c1_i32, %c1275069445_i32, %13, %4, %c1275069445_i32, %c1140850688_i32, %cast_10) : (memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32, memref<?xi32>) -> i32
      %cast_11 = memref.cast %alloca : memref<1x5xi32> to memref<?x5xi32>
      %15 = func.call @MPI_Wait(%cast_10, %cast_11) : (memref<?xi32>, memref<?x5xi32>) -> i32
    }
    %9 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Allgather(memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Iallgather(memref<?xi8>, i32, i32, memref<?xi8>, i32, i32, i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Wait(memref<?xi32>, memref<?x5xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

