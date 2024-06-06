module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str3("total sum is %d\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str2("process %d exits barrier\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("process %d enters barrier\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("process %d has local sum of %d\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1476395011_i32 = arith.constant 1476395011 : i32
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c2_i32 = arith.constant 2 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<1xi32>
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
    %cast_6 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_6) : (i32, memref<?xi32>) -> i32
    %cast_7 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_7) : (i32, memref<?xi32>) -> i32
    memref.store %c0_i32, %alloca_0[%c0] : memref<1xi32>
    %4 = memref.load %alloca_2[%c0] : memref<1xi32>
    %5 = arith.addi %4, %c1_i32 : i32
    %6 = arith.index_cast %5 : i32 to index
    %7 = scf.for %arg2 = %c0 to %6 step %c1 iter_args(%arg3 = %c0_i32) -> (i32) {
      %16 = arith.index_cast %arg2 : index to i32
      %17 = arith.addi %arg3, %16 : i32
      memref.store %17, %alloca_0[%c0] : memref<1xi32>
      scf.yield %17 : i32
    }
    %8 = llvm.mlir.addressof @str0 : !llvm.ptr
    %9 = llvm.getelementptr %8[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<32 x i8>
    %10 = llvm.call @printf(%9, %4, %7) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32) -> i32
    %11 = arith.remsi %4, %c2_i32 : i32
    %12 = arith.cmpi ne, %11, %c0_i32 : i32
    scf.if %12 {
      %16 = llvm.mlir.addressof @str1 : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %18 = llvm.call @printf(%17, %4) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %19 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
      %20 = llvm.mlir.addressof @str2 : !llvm.ptr
      %21 = llvm.getelementptr %20[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %22 = memref.load %alloca_2[%c0] : memref<1xi32>
      %23 = llvm.call @printf(%21, %22) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %24 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %25 = "polygeist.pointer2memref"(%24) : (!llvm.ptr) -> memref<?xi8>
      %26 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %27 = "polygeist.pointer2memref"(%26) : (!llvm.ptr) -> memref<?xi8>
      %28 = func.call @MPI_Reduce(%25, %27, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
    } else {
      %16 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %17 = "polygeist.pointer2memref"(%16) : (!llvm.ptr) -> memref<?xi8>
      %18 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %19 = "polygeist.pointer2memref"(%18) : (!llvm.ptr) -> memref<?xi8>
      %20 = func.call @MPI_Reduce(%17, %19, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
      %21 = llvm.mlir.addressof @str1 : !llvm.ptr
      %22 = llvm.getelementptr %21[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %23 = memref.load %alloca_2[%c0] : memref<1xi32>
      %24 = llvm.call @printf(%22, %23) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %25 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
      %26 = llvm.mlir.addressof @str2 : !llvm.ptr
      %27 = llvm.getelementptr %26[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %28 = memref.load %alloca_2[%c0] : memref<1xi32>
      %29 = llvm.call @printf(%27, %28) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %13 = memref.load %alloca_2[%c0] : memref<1xi32>
    %14 = arith.cmpi eq, %13, %c0_i32 : i32
    scf.if %14 {
      %16 = llvm.mlir.addressof @str3 : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<17 x i8>
      %18 = memref.load %alloca[%c0] : memref<1xi32>
      %19 = llvm.call @printf(%17, %18) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %15 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Reduce(memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

