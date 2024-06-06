module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@sendData@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@myRank" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    %true = arith.constant true
    %c4_i64 = arith.constant 4 : i64
    %c1275069445_i32 = arith.constant 1275069445 : i32
    %c1_i32 = arith.constant 1 : i32
    %c1_i64 = arith.constant 1 : i64
    %c1140850688_i32 = arith.constant 1140850688 : i32
    %false = arith.constant false
    %c13_i32 = arith.constant 13 : i32
    %c42_i32 = arith.constant 42 : i32
    %0 = memref.get_global @"main@static@sendData" : memref<1xi32>
    %1 = memref.get_global @"main@static@recvData" : memref<1xi32>
    %alloca = memref.alloca() : memref<1xi32>
    %2 = memref.get_global @"main@static@myRank" : memref<1xi32>
    %alloca_0 = memref.alloca() : memref<1xmemref<?xmemref<?xi8>>>
    %alloca_1 = memref.alloca() : memref<1xi32>
    memref.store %arg0, %alloca_1[%c0] : memref<1xi32>
    memref.store %arg1, %alloca_0[%c0] : memref<1xmemref<?xmemref<?xi8>>>
    memref.store %c42_i32, %alloca[%c0] : memref<1xi32>
    %3 = memref.get_global @"main@static@sendData@init" : memref<1xi1>
    %4 = memref.load %3[%c0] : memref<1xi1>
    scf.if %4 {
      memref.store %false, %3[%c0] : memref<1xi1>
      memref.store %c13_i32, %0[%c0] : memref<1xi32>
    }
    %cast = memref.cast %alloca_1 : memref<1xi32> to memref<?xi32>
    %cast_2 = memref.cast %alloca_0 : memref<1xmemref<?xmemref<?xi8>>> to memref<?xmemref<?xmemref<?xi8>>>
    %5 = call @MPI_Init(%cast, %cast_2) : (memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32
    call @shmem_init() : () -> ()
    %cast_3 = memref.cast %2 : memref<1xi32> to memref<?xi32>
    %6 = call @MPI_Comm_rank(%c1140850688_i32, %cast_3) : (i32, memref<?xi32>) -> i32
    %7 = call @shmem_my_pe() : () -> i32
    %8 = arith.cmpi eq, %7, %c0_i32 : i32
    %9 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %10 = memref.load %9[%c0] : memref<1xmemref<?x1xi32>>
    %11 = call @shmem_team_n_pes(%10) : (memref<?x1xi32>) -> i32
    %12 = arith.extsi %11 : i32 to i64
    %13 = arith.muli %12, %c4_i64 : i64
    %14 = call @shmem_malloc(%13) : (i64) -> memref<?xi8>
    %15 = "polygeist.memref2pointer"(%14) : (memref<?xi8>) -> !llvm.ptr
    %16 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi32>
    %17 = memref.load %9[%c0] : memref<1xmemref<?x1xi32>>
    %18 = call @shmem_int_fcollect(%17, %16, %cast_3, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    %19 = scf.if %8 -> (i1) {
      scf.yield %true : i1
    } else {
      %22 = llvm.getelementptr %15[%7] : (!llvm.ptr, i32) -> !llvm.ptr, i32
      %23 = llvm.load %22 : !llvm.ptr -> i32
      %24 = arith.cmpi eq, %23, %c0_i32 : i32
      scf.yield %24 : i1
    }
    scf.if %19 {
      %22 = memref.load %9[%c0] : memref<1xmemref<?x1xi32>>
      %cast_4 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %cast_5 = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %23 = func.call @shmem_int_sum_reduce(%22, %cast_4, %cast_5, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
      %24 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %25 = "polygeist.pointer2memref"(%24) : (!llvm.ptr) -> memref<?xi8>
      %26 = func.call @MPI_Bcast(%25, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
    } else {
      %22 = "polygeist.memref2pointer"(%alloca) : (memref<1xi32>) -> !llvm.ptr
      %23 = "polygeist.pointer2memref"(%22) : (!llvm.ptr) -> memref<?xi8>
      %24 = func.call @MPI_Bcast(%23, %c1_i32, %c1275069445_i32, %c0_i32, %c1140850688_i32) : (memref<?xi8>, i32, i32, i32, i32) -> i32
      %25 = memref.load %9[%c0] : memref<1xmemref<?x1xi32>>
      %cast_4 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %cast_5 = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %26 = func.call @shmem_int_sum_reduce(%25, %cast_4, %cast_5, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    }
    %20 = call @MPI_Barrier(%c1140850688_i32) : (i32) -> i32
    call @shmem_sync_all() : () -> ()
    call @shmem_finalize() : () -> ()
    %21 = call @MPI_Finalize() : () -> i32
    return %c0_i32 : i32
  }
  func.func private @MPI_Init(memref<?xi32>, memref<?xmemref<?xmemref<?xi8>>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Comm_rank(i32, memref<?xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_n_pes(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_malloc(i64) -> memref<?xi8> attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_fcollect(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Bcast(memref<?xi8>, i32, i32, i32, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Barrier(i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_sync_all() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @MPI_Finalize() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

