module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %alloca = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_1[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %cast_2 = memref.cast %alloca_0 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast, %cast_2) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    memref.store %c1_i32, %alloca[%c0] : memref<1xi32>
    %cast_3 = memref.cast %alloca : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    %3 = call @MPI_Comm_rank(%c1140850688_i32, %cast_3) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca[%c0] : memref<1xi32>
    %5 = arith.cmpi sgt, %4, %c0_i32 : i32
    scf.if %5 {
      %7 = func.call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    }
    %6 = call @MPI_Finalize() : () -> i32
    return %0 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

