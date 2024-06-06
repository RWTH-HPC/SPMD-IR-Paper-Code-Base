module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@recvData" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@sendData" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %true = arith.constant true
    %c4_i32 = arith.constant 4 : i32
    %c3_i32 = arith.constant 3 : i32
    %c20_i32 = arith.constant 20 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1_i64 = arith.constant 1 : i64
    %c10_i32 = arith.constant 10 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %0 = memref.get_global @"main@static@recvData" : memref<1xi32>
    %1 = memref.get_global @"main@static@sendData" : memref<1xi32>
    %2 = llvm.mlir.undef : i32
    call @shmem_init() : () -> ()
    %3 = call @shmem_my_pe() : () -> i32
    %4 = arith.cmpi eq, %3, %c3_i32 : i32
    %5 = call @shmem_n_pes() : () -> i32
    %6 = arith.cmpi eq, %5, %c4_i32 : i32
    %7 = arith.cmpi ne, %5, %c4_i32 : i32
    %8 = arith.select %7, %c1_i32, %2 : i32
    scf.if %7 {
      func.call @shmem_finalize() : () -> ()
    }
    %9 = arith.select %6, %c0_i32, %8 : i32
    scf.if %6 {
      %10 = arith.cmpi eq, %3, %c0_i32 : i32
      %11 = scf.if %10 -> (i1) {
        scf.yield %true : i1
      } else {
        %16 = arith.cmpi eq, %3, %c1_i32 : i32
        scf.yield %16 : i1
      }
      scf.if %11 {
        memref.store %c10_i32, %1[%c0] : memref<1xi32>
        %16 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
        %17 = memref.load %16[%c0] : memref<1xmemref<?x1xi32>>
        %cast = memref.cast %0 : memref<1xi32> to memref<?xi32>
        %cast_0 = memref.cast %1 : memref<1xi32> to memref<?xi32>
        %18 = func.call @shmem_int_sum_reduce(%17, %cast, %cast_0, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
      }
      %12 = arith.cmpi eq, %3, %c2_i32 : i32
      %13 = arith.cmpi ne, %3, %c2_i32 : i32
      %14 = arith.andi %13, %4 : i1
      %15 = arith.ori %12, %14 : i1
      scf.if %15 {
        memref.store %c20_i32, %1[%c0] : memref<1xi32>
        %16 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
        %17 = memref.load %16[%c0] : memref<1xmemref<?x1xi32>>
        %cast = memref.cast %0 : memref<1xi32> to memref<?xi32>
        %cast_0 = memref.cast %1 : memref<1xi32> to memref<?xi32>
        %18 = func.call @shmem_int_sum_reduce(%17, %cast, %cast_0, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
      }
      func.call @shmem_finalize() : () -> ()
    }
    return %9 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

