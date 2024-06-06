module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str0("process %d of %d processes\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @f(%arg0: memref<?x2xi32>) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = "polygeist.subindex"(%arg0, %c0) : (memref<?x2xi32>, index) -> memref<2xi32>
    %1 = "polygeist.subindex"(%0, %c0) : (memref<2xi32>, index) -> memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %1) : (i32, memref<?xi32>) -> i32
    %3 = "polygeist.subindex"(%0, %c1) : (memref<2xi32>, index) -> memref<?xi32>
    %4 = call @MPI_Comm_size(%c1140850688_i32, %3) : (i32, memref<?xi32>) -> i32
    %5 = memref.load %arg0[%c0, %c1] : memref<?x2xi32>
    %6 = arith.cmpi sgt, %5, %c1_i32 : i32
    scf.if %6 {
      %7 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    }
    return
  }
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<memref<?x2xi32>>
    %alloca_0 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_1[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %cast_2 = memref.cast %alloca_0 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %0 = call @MPI_Init(%cast, %cast_2) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %1 = memref.load %alloca[] : memref<memref<?x2xi32>>
    %2 = "polygeist.subindex"(%1, %c0) : (memref<?x2xi32>, index) -> memref<2xi32>
    %3 = "polygeist.subindex"(%2, %c0) : (memref<2xi32>, index) -> memref<?xi32>
    %4 = call @MPI_Comm_rank(%c1140850688_i32, %3) : (i32, memref<?xi32>) -> i32
    %5 = "polygeist.subindex"(%2, %c1) : (memref<2xi32>, index) -> memref<?xi32>
    %6 = call @MPI_Comm_size(%c1140850688_i32, %5) : (i32, memref<?xi32>) -> i32
    %7 = memref.load %1[%c0, %c1] : memref<?x2xi32>
    %8 = arith.cmpi sgt, %7, %c1_i32 : i32
    scf.if %8 {
      %15 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    }
    %9 = llvm.mlir.addressof @str0 : !llvm.ptr
    %10 = llvm.getelementptr %9[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<28 x i8>
    %11 = memref.load %1[%c0, %c0] : memref<?x2xi32>
    %12 = memref.load %1[%c0, %c1] : memref<?x2xi32>
    %13 = llvm.call @printf(%10, %11, %12) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32) -> i32
    %14 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

