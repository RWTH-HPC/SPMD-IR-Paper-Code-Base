module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c2_i32 = arith.constant 2 : i32
    %c4_i32 = arith.constant 4 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %alloca = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1x5xi32>
    %alloca_1 = memref.alloca() : memref<1x5xi32>
    %alloca_2 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_2[%c0] : memref<1xi32>
    %alloca_3 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_3[%c0] : memref<1xi32>
    %alloca_4 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_4[%c0] : memref<1xi32>
    %alloca_5 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_6 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_6[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_5[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_6 : memref<1xi32> to memref<?xi32>
    %cast_7 = memref.cast %alloca_5 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %1 = call @MPI_Init(%cast, %cast_7) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %cast_8 = memref.cast %alloca_4 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_8) : (i32, memref<?xi32>) -> i32
    %3 = memref.load %alloca_4[%c0] : memref<1xi32>
    %4 = arith.remsi %3, %c4_i32 : i32
    %cast_9 = memref.cast %alloca : memref<1xi32> to memref<?xi32>
    %5 = call @MPI_Comm_split(%c1140850688_i32, %4, %3, %cast_9) : (i32, i32, i32, memref<?xi32>) -> i32
    %cast_10 = memref.cast %alloca_3 : memref<1xi32> to memref<?xi32>
    %6 = call @MPI_Ibarrier(%c1140850688_i32, %cast_10) : (i32, memref<?xi32>) -> i32
    %7 = memref.load %alloca[%c0] : memref<1xi32>
    %cast_11 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32>
    %8 = call @MPI_Ibarrier(%7, %cast_11) : (i32, memref<?xi32>) -> i32
    %9 = memref.load %alloca_4[%c0] : memref<1xi32>
    %10 = arith.remsi %9, %c2_i32 : i32
    %11 = arith.cmpi ne, %10, %c0_i32 : i32
    scf.if %11 {
      %cast_12 = memref.cast %alloca_1 : memref<1x5xi32> to memref<?x5xi32>
      %14 = func.call @MPI_Wait(%cast_10, %cast_12) : (memref<?xi32>, memref<?x5xi32>) -> i32
    } else {
      %cast_12 = memref.cast %alloca_0 : memref<1x5xi32> to memref<?x5xi32>
      %14 = func.call @MPI_Wait(%cast_11, %cast_12) : (memref<?xi32>, memref<?x5xi32>) -> i32
    }
    %12 = call @MPI_Comm_free(%cast_9) : (memref<?xi32>) -> i32
    %13 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_split(i32, i32, i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Ibarrier(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Wait(memref<?xi32>, memref<?x5xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_free(memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

