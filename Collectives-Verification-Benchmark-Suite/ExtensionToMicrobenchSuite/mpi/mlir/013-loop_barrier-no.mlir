module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str0("This test needs at least 2 MPI processes\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c10 = arith.constant 10 : index
    %c1 = arith.constant 1 : index
    %c0_i32 = arith.constant 0 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1_i32 = arith.constant 1 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_2 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_2[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_1[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32>
    %cast_3 = memref.cast %alloca_1 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast, %cast_3) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_4 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_4) : (i32, memref<?xi32>) -> i32
    %cast_5 = memref.cast %alloca : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_size(%c1140850688_i32, %cast_5) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca[%c0] : memref<1xi32>
    %5 = arith.cmpi slt, %4, %c2_i32 : i32
    %6 = arith.cmpi sge, %4, %c2_i32 : i32
    %7 = arith.select %5, %c1_i32, %0 : i32
    scf.if %5 {
      %9 = llvm.mlir.addressof @str0 : !llvm.ptr
      %10 = llvm.getelementptr %9[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<42 x i8>
      %11 = llvm.call @printf(%10) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr) -> i32
      %12 = func.call @MPI_Finalize() : () -> i32
    }
    %8 = arith.select %6, %c0_i32, %7 : i32
    scf.if %6 {
      %9 = memref.load %alloca_0[%c0] : memref<1xi32>
      %10 = arith.remsi %9, %c2_i32 : i32
      %11 = arith.cmpi ne, %10, %c0_i32 : i32
      scf.if %11 {
        scf.for %arg2 = %c1 to %c10 step %c1 {
          %13 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
        }
      } else {
        scf.for %arg2 = %c1 to %c10 step %c1 {
          %13 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
        }
      }
      %12 = func.call @MPI_Finalize() : () -> i32
    }
    return %8 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

