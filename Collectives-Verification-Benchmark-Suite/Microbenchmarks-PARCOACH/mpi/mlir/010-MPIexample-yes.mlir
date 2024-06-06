module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @g(%arg0: i32) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c1476395011_i32 = arith.constant 1476395011 : i32
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c256_i32 = arith.constant 256 : i32
    %c12_i32 = arith.constant 12 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %c0_i32, %alloca_0[%c0] : memref<1xi32>
    memref.store %c12_i32, %alloca[%c0] : memref<1xi32>
    %0 = arith.cmpi sgt, %arg0, %c256_i32 : i32
    scf.if %0 {
      %1 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %2 = "polygeist.pointer2memref"(%1) : (!llvm.ptr) -> memref<?xi8>
      %3 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %4 = "polygeist.pointer2memref"(%3) : (!llvm.ptr) -> memref<?xi8>
      %5 = func.call @MPI_Reduce(%2, %4, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
    }
    return
  }
  func.func private @MPI_Reduce(memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func @f() attributes {llvm.linkage = #llvm.linkage<external>} {
    %c12_i32 = arith.constant 12 : i32
    %c256_i32 = arith.constant 256 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1476395011_i32 = arith.constant 1476395011 : i32
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %0 = llvm.mlir.undef : i32
    %alloca = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_0[%c0] : memref<1xi32>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32>
    %1 = call @MPI_Comm_rank(%c1140850688_i32, %cast) : (i32, memref<?xi32>) -> i32
    %cast_1 = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_size(%c1140850688_i32, %cast_1) : (i32, memref<?xi32>) -> i32
    %3 = memref.load %alloca[%c0] : memref<1xi32>
    %4 = arith.remsi %3, %c2_i32 : i32
    %5 = arith.cmpi ne, %4, %c0_i32 : i32
    scf.if %5 {
      %7 = memref.load %alloca_0[%c0] : memref<1xi32>
      %alloca_2 = memref.alloca() : memref<1xi32>
      %alloca_3 = memref.alloca() : memref<1xi32>
      memref.store %c0_i32, %alloca_3[%c0] : memref<1xi32>
      memref.store %c12_i32, %alloca_2[%c0] : memref<1xi32>
      %8 = arith.cmpi sgt, %7, %c256_i32 : i32
      scf.if %8 {
        %9 = "polygeist.memref2pointer"(%alloca_2) : (memref<1xi32>) -> !llvm.ptr
        %10 = "polygeist.pointer2memref"(%9) : (!llvm.ptr) -> memref<?xi8>
        %11 = "polygeist.memref2pointer"(%alloca_3) : (memref<1xi32>) -> !llvm.ptr
        %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xi8>
        %13 = func.call @MPI_Reduce(%10, %12, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
      }
    }
    %6 = call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    return
  }
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_size(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c12_i32 = arith.constant 12 : i32
    %c256_i32 = arith.constant 256 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1476395011_i32 = arith.constant 1476395011 : i32
    %c0 = arith.constant 0 : index
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %c2_i32 = arith.constant 2 : i32
    %c0_i32 = arith.constant 0 : i32
    %alloca = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_0 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_0[%c0] : memref<1xi32>
    memref.store %arg1, %alloca[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    %cast = memref.cast %alloca_0 : memref<1xi32> to memref<?xi32>
    %cast_1 = memref.cast %alloca : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %0 = call @MPI_Init(%cast, %cast_1) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    %1 = llvm.mlir.undef : i32
    %alloca_2 = memref.alloca() : memref<1xi32>
    memref.store %1, %alloca_2[%c0] : memref<1xi32>
    %alloca_3 = memref.alloca() : memref<1xi32>
    memref.store %1, %alloca_3[%c0] : memref<1xi32>
    %cast_4 = memref.cast %alloca_2 : memref<1xi32> to memref<?xi32>
    %2 = call @MPI_Comm_rank(%c1140850688_i32, %cast_4) : (i32, memref<?xi32>) -> i32
    %cast_5 = memref.cast %alloca_3 : memref<1xi32> to memref<?xi32>
    %3 = call @MPI_Comm_size(%c1140850688_i32, %cast_5) : (i32, memref<?xi32>) -> i32
    %4 = memref.load %alloca_2[%c0] : memref<1xi32>
    %5 = arith.remsi %4, %c2_i32 : i32
    %6 = arith.cmpi ne, %5, %c0_i32 : i32
    scf.if %6 {
      %9 = memref.load %alloca_3[%c0] : memref<1xi32>
      %alloca_6 = memref.alloca() : memref<1xi32>
      %alloca_7 = memref.alloca() : memref<1xi32>
      memref.store %c0_i32, %alloca_7[%c0] : memref<1xi32>
      memref.store %c12_i32, %alloca_6[%c0] : memref<1xi32>
      %10 = arith.cmpi sgt, %9, %c256_i32 : i32
      scf.if %10 {
        %11 = "polygeist.memref2pointer"(%alloca_6) : (memref<1xi32>) -> !llvm.ptr
        %12 = "polygeist.pointer2memref"(%11) : (!llvm.ptr) -> memref<?xi8>
        %13 = "polygeist.memref2pointer"(%alloca_7) : (memref<1xi32>) -> !llvm.ptr
        %14 = "polygeist.pointer2memref"(%13) : (!llvm.ptr) -> memref<?xi8>
        %15 = func.call @MPI_Reduce(%12, %14, %c1_i32, %c1275069445_i32, %c1476395011_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, memref<?xi8>, i32, i32, i32, i32, i32) -> i32
      }
    }
    %7 = call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    %8 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

