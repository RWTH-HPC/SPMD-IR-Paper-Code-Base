module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@data" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c21_i32 = arith.constant 21 : i32
    %c42_i32 = arith.constant 42 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c8_i32 = arith.constant 8 : i32
    %0 = memref.get_global @"main@static@data" : memref<1xi32>
    %alloca = memref.alloca() : memref<1xi32>
    memref.store %c8_i32, %alloca[%c0] : memref<1xi32>
    call @shmem_init() : () -> ()
    %1 = call @shmem_my_pe() : () -> i32
    %2 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %3 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
    %cast = memref.cast %alloca : memref<1xi32> to memref<?xi32>
    %cast_0 = memref.cast %0 : memref<1xi32> to memref<?xi32>
    %4 = call @shmem_int_sum_reduce(%3, %cast, %cast_0, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    %5 = arith.cmpi eq, %1, %c0_i32 : i32
    scf.if %5 {
      memref.store %c42_i32, %0[%c0] : memref<1xi32>
      %6 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
      %7 = func.call @shmem_int_broadcast(%6, %cast_0, %cast_0, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
    } else {
      %6 = memref.load %alloca[%c0] : memref<1xi32>
      %7 = arith.cmpi eq, %6, %c21_i32 : i32
      scf.if %7 {
        %8 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
        %9 = func.call @shmem_int_broadcast(%8, %cast_0, %cast_0, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
      }
    }
    call @shmem_sync_all() : () -> ()
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_broadcast(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_sync_all() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
}

