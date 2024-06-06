module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str2("int main(int, char **)\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("/home/sw339864/promotion/mlir-research/collective-verification-benchmark-suite/microbenchmarks-PC-2019/shmem/003-CIVL_BcastReduce_bad-yes.c\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("num == 3 * nprocs\00") {addr_space = 0 : i32}
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@recv" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@num" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c27_i32 = arith.constant 27 : i32
    %c2_i32 = arith.constant 2 : i32
    %c1_i64 = arith.constant 1 : i64
    %c3_i32 = arith.constant 3 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = memref.get_global @"main@static@recv" : memref<1xi32>
    %1 = memref.get_global @"main@static@num" : memref<1xi32>
    call @shmem_init() : () -> ()
    %2 = call @shmem_n_pes() : () -> i32
    %3 = call @shmem_my_pe() : () -> i32
    %4 = arith.cmpi eq, %3, %c0_i32 : i32
    scf.if %4 {
      memref.store %c3_i32, %1[%c0] : memref<1xi32>
    }
    %5 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %6 = memref.load %5[%c0] : memref<1xmemref<?x1xi32>>
    %cast = memref.cast %1 : memref<1xi32> to memref<?xi32>
    %7 = call @shmem_int_broadcast(%6, %cast, %cast, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
    %8 = arith.remsi %3, %c2_i32 : i32
    %9 = arith.cmpi eq, %8, %c0_i32 : i32
    scf.if %9 {
      %13 = memref.load %5[%c0] : memref<1xmemref<?x1xi32>>
      %cast_0 = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %14 = func.call @shmem_int_sum_reduce(%13, %cast_0, %cast, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    } else {
      %13 = memref.load %5[%c0] : memref<1xmemref<?x1xi32>>
      %14 = func.call @shmem_int_broadcast(%13, %cast, %cast, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
    }
    scf.if %4 {
      %13 = memref.load %0[%c0] : memref<1xi32>
      memref.store %13, %1[%c0] : memref<1xi32>
    }
    scf.if %9 {
      %13 = memref.load %5[%c0] : memref<1xmemref<?x1xi32>>
      %14 = func.call @shmem_int_broadcast(%13, %cast, %cast, %c1_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
    } else {
      %13 = memref.load %5[%c0] : memref<1xmemref<?x1xi32>>
      %cast_0 = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %14 = func.call @shmem_int_sum_reduce(%13, %cast_0, %cast, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    }
    %10 = memref.load %1[%c0] : memref<1xi32>
    %11 = arith.muli %2, %c3_i32 : i32
    %12 = arith.cmpi eq, %10, %11 : i32
    scf.if %12 {
    } else {
      %13 = llvm.mlir.addressof @str0 : !llvm.ptr
      %14 = llvm.mlir.addressof @str1 : !llvm.ptr
      %15 = llvm.mlir.addressof @str2 : !llvm.ptr
      %16 = "polygeist.pointer2memref"(%13) : (!llvm.ptr) -> memref<?xi8>
      %17 = "polygeist.pointer2memref"(%14) : (!llvm.ptr) -> memref<?xi8>
      %18 = "polygeist.pointer2memref"(%15) : (!llvm.ptr) -> memref<?xi8>
      func.call @__assert_fail(%16, %17, %c27_i32, %18) : (memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) -> ()
    }
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_broadcast(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @__assert_fail(memref<?xi8>, memref<?xi8>, i32, memref<?xi8>) attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
}

