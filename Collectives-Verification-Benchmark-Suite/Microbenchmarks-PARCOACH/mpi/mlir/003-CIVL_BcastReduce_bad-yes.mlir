module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str2("int main(int, char **)\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("/home/sw339864/promotion/mlir-research/collective-verification-benchmark-suite/microbenchmarks-PC-2019/mpi/003-CIVL_BcastReduce_bad-yes.c\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("num == 3 * nprocs\00") {addr_space = 0 : i32}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c27_i32 = arith.constant 27 : i32
    %c1476395011_i32 = arith.constant 1476395011 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c3_i32 = arith.constant 3 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
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
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_6) : (i32, memref<?xi32>) -> i32
    %cast_7 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_7) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_1[%c0] : memref<1xi32>
    %5 = arith.cmpi eq, %4, %c0_i32 : i32
    scf.if %5 {
      memref.store %c3_i32, %alloca_0[%c0] : memref<1xi32>
    }
    %6 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
    %7 = "polygeist.pointer2memref"(%6) : (!llvm.ptr) -> memref<?xi8>
    %8 = call @MPI_Bcast(%7, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    %9 = memref.load %alloca_1[%c0] : memref<1xi32>
    %10 = arith.remsi %9, %c2_i32 : i32
    %11 = arith.cmpi eq, %10, %c0_i32 : i32
    scf.if %11 {
      %21 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %22 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xi8>
      %23 = func.call @MPI_Reduce(%7, %22, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
    } else {
      %21 = func.call @MPI_Bcast(%7, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    }
    %12 = memref.load %alloca_1[%c0] : memref<1xi32>
    %13 = arith.cmpi eq, %12, %c0_i32 : i32
    scf.if %13 {
      %21 = memref.load %alloca[%c0] : memref<1xi32>
      memref.store %21, %alloca_0[%c0] : memref<1xi32>
    }
    %14 = arith.remsi %12, %c2_i32 : i32
    %15 = arith.cmpi eq, %14, %c0_i32 : i32
    scf.if %15 {
      %21 = func.call @MPI_Bcast(%7, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    } else {
      %21 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %22 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xi8>
      %23 = func.call @MPI_Reduce(%7, %22, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
    }
    %16 = memref.load %alloca_0[%c0] : memref<1xi32>
    %17 = memref.load %alloca_2[%c0] : memref<1xi32>
    %18 = arith.muli %17, %c3_i32 : i32
    %19 = arith.cmpi eq, %16, %18 : i32
    scf.if %19 {
    } else {
      %21 = llvm.mlir.addressof @str0 : !llvm.ptr
      %22 = llvm.mlir.addressof @str1 : !llvm.ptr
      %23 = llvm.mlir.addressof @str2 : !llvm.ptr
      %24 = "polygeist.pointer2memref"(%21) : (!llvm.ptr) -> memref<?xi8>
      %25 = "polygeist.pointer2memref"(%22) : (!llvm.ptr) -> memref<?xi8>
      %26 = "polygeist.pointer2memref"(%23) : (!llvm.ptr) -> memref<?xi8>
      func.call @__assert_fail(%24, %25, %c27_i32, %26) : (memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) -> ()
    }
    %20 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Bcast(memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Reduce(memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @__assert_fail(memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

