module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c21_i32 = arith.constant 21 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1476395011_i32 = arith.constant 1476395011 : i32
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c13_i32 = arith.constant 13 : i32
    %c42_i32 = arith.constant 42 : i32
    %c8_i32 = arith.constant 8 : i32
    %alloca = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    %alloca_2 = memref.alloca() : memref<1xi32>
    %alloca_3 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_4 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_4[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_3[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    memref.store %c8_i32, %alloca_2[%c0] : memref<1xi32>
    memref.store %c42_i32, %alloca_1[%c0] : memref<1xi32>
    memref.store %c13_i32, %alloca_0[%c0] : memref<1xi32>
    %cast = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32>
    %cast_5 = memref.cast %alloca_3 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast, %cast_5) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %2 = "polygeist.memref2pointer"(%alloca_1) : (memref<1xi32>) -> !llvm.ptr
    %3 = "polygeist.pointer2memref"(%2) : (!llvm.ptr) -> memref<?xi8>
    %4 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xi32>) -> !llvm.ptr
    %5 = "polygeist.pointer2memref"(%4) : (!llvm.ptr) -> memref<?xi8>
    %6 = call @MPI_Allreduce(%3, %5, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32) -> i32
    %7 = memref.load %alloca_2[%c0] : memref<1xi32>
    %8 = arith.cmpi eq, %7, %c21_i32 : i32
    scf.if %8 {
      %11 = func.call @MPI_Bcast(%3, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
      %12 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %16 = func.call @MPI_Reduce(%13, %15, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
    } else {
      %11 = func.call @MPI_Bcast(%3, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
      %12 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %13 = "polygeist.pointer2memref"(%12) : (!llvm.ptr) -> memref<?xi8>
      %14 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %15 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %16 = func.call @MPI_Reduce(%13, %15, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
    }
    %9 = call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    %10 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Allreduce(memref<?xi8>, memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Bcast(memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Reduce(memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

