module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@sendData@init" : memref<1xi1> = dense<true>
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1_i64 = arith.constant 1 : i64
    %c0_i32 = arith.constant 0 : i32
    %c0_i64 = arith.constant 0 : i64
    %c2_i32 = arith.constant 2 : i32
    %false = arith.constant false
    %c13_i32 = arith.constant 13 : i32
    %alloca = memref.alloca() : memref<1xmemref<?x1xi32>>
    %0 = memref.get_global @"main@static@recvData" : memref<1xi32>
    %1 = memref.get_global @"main@static@sendData" : memref<1xi32>
    %2 = memref.get_global @"main@static@sendData@init" : memref<1xi1>
    %3 = memref.load %2[%c0] : memref<1xi1>
    scf.if %3 {
      memref.store %false, %2[%c0] : memref<1xi1>
      memref.store %c13_i32, %1[%c0] : memref<1xi32>
    }
    call @shmem_init() : () -> ()
    %4 = call @shmem_my_pe() : () -> i32
    %5 = call @shmem_n_pes() : () -> i32
    %6 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %7 = memref.load %6[%c0] : memref<1xmemref<?x1xi32>>
    %8 = arith.remsi %4, %c2_i32 : i32
    %9 = arith.divsi %5, %c2_i32 : i32
    %10 = llvm.mlir.zero : !llvm.ptr
    %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?x1xi32>
    %cast = memref.cast %alloca : memref<1xmemref<?x1xi32>> to memref<?xmemref<?x1xi32>>
    %12 = call @shmem_team_split_strided(%7, %8, %c2_i32, %9, %11, %c0_i64, %cast) : (memref<?x1xi32>, i32, i32, i32, memref<?x1xi32>, i64, memref<?xmemref<?x1xi32>>) -> i32
    %13 = arith.cmpi ne, %8, %c0_i32 : i32
    scf.if %13 {
      %16 = memref.load %alloca[%c0] : memref<1xmemref<?x1xi32>>
      %cast_0 = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %cast_1 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %17 = func.call @shmem_int_sum_reduce(%16, %cast_0, %cast_1, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
      %18 = memref.load %6[%c0] : memref<1xmemref<?x1xi32>>
      %19 = func.call @shmem_team_sync(%18) : (memref<?x1xi32>) -> i32
    } else {
      %16 = memref.load %6[%c0] : memref<1xmemref<?x1xi32>>
      %17 = func.call @shmem_team_sync(%16) : (memref<?x1xi32>) -> i32
      %18 = memref.load %alloca[%c0] : memref<1xmemref<?x1xi32>>
      %cast_0 = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %cast_1 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %19 = func.call @shmem_int_sum_reduce(%18, %cast_0, %cast_1, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    }
    %14 = memref.load %alloca[%c0] : memref<1xmemref<?x1xi32>>
    %15 = call @shmem_team_destroy(%14) : (memref<?x1xi32>) -> i32
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_split_strided(memref<?x1xi32>, i32, i32, i32, memref<?x1xi32>, i64, memref<?xmemref<?x1xi32>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_sync(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_destroy(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
}

