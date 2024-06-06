module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@sendData@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1_i64 = arith.constant 1 : i64
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %false = arith.constant false
    %c13_i32 = arith.constant 13 : i32
    %c42_i32 = arith.constant 42 : i32
    %alloca = memref.alloca() : memref<1xi32>
    %0 = llvm.mlir.undef : i32
    memref.store %0, %alloca[%c0] : memref<1xi32>
    %1 = memref.get_global @"main@static@sendData" : memref<1xi32>
    %2 = memref.get_global @"main@static@recvData" : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xi32>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %0, %alloca_1[%c0] : memref<1xi32>
    %alloca_2 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_3 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_3[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_2[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    memref.store %c42_i32, %alloca_0[%c0] : memref<1xi32>
    %3 = memref.get_global @"main@static@sendData@init" : memref<1xi1>
    %4 = memref.load %3[%c0] : memref<1xi1>
    scf.if %4 {
      memref.store %false, %3[%c0] : memref<1xi1>
      memref.store %c13_i32, %1[%c0] : memref<1xi32>
    }
    %cast = memref.cast %alloca_3 : memref<1xi32> to memref<?xi32>
    %cast_4 = memref.cast %alloca_2 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %5 = call @MPI_Init(%cast, %cast_4) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    call @shmem_init() : () -> ()
    %6 = call @shmem_my_pe() : () -> i32
    %cast_5 = memref.cast %alloca : memref<1xi32> to memref<?xi32>
    %7 = call @MPI_Comm_split(%c1140850688_i32, %c0_i32, %6, %cast_5) : (i32, i32, i32, memref<?xi32>) -> i32
    %8 = memref.load %alloca[%c0] : memref<1xi32>
    %cast_6 = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %9 = call @MPI_Comm_rank(%8, %cast_6) : (i32, memref<?xi32>) -> i32
    %10 = memref.load %alloca_1[%c0] : memref<1xi32>
    %11 = arith.cmpi eq, %10, %c0_i32 : i32
    scf.if %11 {
      %15 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
      %17 = memref.load %alloca[%c0] : memref<1xi32>
      %18 = func.call @MPI_Bcast(%16, %c1_i32, %c1275069445_i32, %c0_i32, %17) : (memref<?xi8>, i32, i32, i32, i32) -> i32
      %19 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
      %20 = memref.load %19[%c0] : memref<1xmemref<?x1xi32>>
      %cast_7 = memref.cast %2 : memref<1xi32> to memref<?xi32>
      %cast_8 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %21 = func.call @shmem_int_sum_reduce(%20, %cast_7, %cast_8, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    } else {
      %15 = "polygeist.memref2pointer"(%alloca_0) : (memref<1xi32>) -> !llvm.ptr
      %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
      %17 = memref.load %alloca[%c0] : memref<1xi32>
      %18 = func.call @MPI_Bcast(%16, %c1_i32, %c1275069445_i32, %c0_i32, %17) : (memref<?xi8>, i32, i32, i32, i32) -> i32
      %19 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
      %20 = memref.load %19[%c0] : memref<1xmemref<?x1xi32>>
      %cast_7 = memref.cast %2 : memref<1xi32> to memref<?xi32>
      %cast_8 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %21 = func.call @shmem_int_sum_reduce(%20, %cast_7, %cast_8, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    }
    %12 = memref.load %alloca[%c0] : memref<1xi32>
    %13 = call @MPI_Barrier(%12) : (i32) -> i32
    call @shmem_sync_all() : () -> ()
    call @shmem_finalize() : () -> ()
    %14 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_split(i32, i32, i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Bcast(memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_sync_all() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

