module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str3("total sum is %d\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str2("process %d exits barrier\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str1("process %d enters barrier\0A\00") {addr_space = 0 : i32}
  llvm.mlir.global internal constant @str0("process %d has local sum of %d\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  memref.global "private" @"main@static@sum" : memref<1xi32> = uninitialized
  memref.global "private" @"main@static@localsum" : memref<1xi32> = uninitialized
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1_i32 = arith.constant 1 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1_i64 = arith.constant 1 : i64
    %c2_i32 = arith.constant 2 : i32
    %c0_i32 = arith.constant 0 : i32
    %0 = memref.get_global @"main@static@sum" : memref<1xi32>
    %1 = memref.get_global @"main@static@localsum" : memref<1xi32>
    call @shmem_init() : () -> ()
    %2 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %3 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
    %4 = call @shmem_team_n_pes(%3) : (memref<?x1xi32>) -> i32
    %5 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
    %6 = call @shmem_team_my_pe(%5) : (memref<?x1xi32>) -> i32
    memref.store %c0_i32, %1[%c0] : memref<1xi32>
    %7 = arith.addi %6, %c1_i32 : i32
    %8 = arith.index_cast %7 : i32 to index
    %9 = scf.for %arg2 = %c0 to %8 step %c1 iter_args(%arg3 = %c0_i32) -> (i32) {
      %16 = arith.index_cast %arg2 : index to i32
      %17 = arith.addi %arg3, %16 : i32
      memref.store %17, %1[%c0] : memref<1xi32>
      scf.yield %17 : i32
    }
    %10 = llvm.mlir.addressof @str0 : !llvm.ptr
    %11 = llvm.getelementptr %10[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<32 x i8>
    %12 = llvm.call @printf(%11, %6, %9) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32) -> i32
    %13 = arith.remsi %6, %c2_i32 : i32
    %14 = arith.cmpi ne, %13, %c0_i32 : i32
    scf.if %14 {
      %16 = llvm.mlir.addressof @str1 : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %18 = llvm.call @printf(%17, %6) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %19 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
      %20 = func.call @shmem_team_sync(%19) : (memref<?x1xi32>) -> i32
      %21 = llvm.mlir.addressof @str2 : !llvm.ptr
      %22 = llvm.getelementptr %21[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %23 = llvm.call @printf(%22, %6) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %24 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
      %cast = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %cast_0 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %25 = func.call @shmem_int_sum_reduce(%24, %cast, %cast_0, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
    } else {
      %16 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
      %cast = memref.cast %0 : memref<1xi32> to memref<?xi32>
      %cast_0 = memref.cast %1 : memref<1xi32> to memref<?xi32>
      %17 = func.call @shmem_int_sum_reduce(%16, %cast, %cast_0, %c1_i64) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32
      %18 = llvm.mlir.addressof @str1 : !llvm.ptr
      %19 = llvm.getelementptr %18[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<27 x i8>
      %20 = llvm.call @printf(%19, %6) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
      %21 = memref.load %2[%c0] : memref<1xmemref<?x1xi32>>
      %22 = func.call @shmem_team_sync(%21) : (memref<?x1xi32>) -> i32
      %23 = llvm.mlir.addressof @str2 : !llvm.ptr
      %24 = llvm.getelementptr %23[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<26 x i8>
      %25 = llvm.call @printf(%24, %6) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    %15 = arith.cmpi eq, %6, %c0_i32 : i32
    scf.if %15 {
      %16 = llvm.mlir.addressof @str3 : !llvm.ptr
      %17 = llvm.getelementptr %16[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<17 x i8>
      %18 = memref.load %0[%c0] : memref<1xi32>
      %19 = llvm.call @printf(%17, %18) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32) -> i32
    }
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_n_pes(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_my_pe(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_sync(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_sum_reduce(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
}

