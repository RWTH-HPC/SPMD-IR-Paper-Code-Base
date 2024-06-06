module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  llvm.mlir.global internal constant @str0("This test needs at least 2 MPI processes\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c2_i32 = arith.constant 2 : i32
    %c0_i64 = arith.constant 0 : i64
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %alloca = memref.alloca() : memref<1xmemref<?x1xi32>>
    %0 = llvm.mlir.undef : i32
    call @shmem_init() : () -> ()
    %1 = call @shmem_my_pe() : () -> i32
    %2 = call @shmem_n_pes() : () -> i32
    %3 = arith.cmpi sge, %2, %c2_i32 : i32
    %4 = arith.cmpi slt, %2, %c2_i32 : i32
    %5 = arith.select %4, %c1_i32, %0 : i32
    scf.if %4 {
      %7 = llvm.mlir.addressof @str0 : !llvm.ptr
      %8 = llvm.getelementptr %7[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<42 x i8>
      %9 = llvm.call @printf(%8) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr) -> i32
      func.call @shmem_finalize() : () -> ()
    }
    %6 = arith.select %3, %c0_i32, %5 : i32
    scf.if %3 {
      %7 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
      %8 = memref.load %7[%c0] : memref<1xmemref<?x1xi32>>
      %9 = arith.divsi %2, %c2_i32 : i32
      %10 = llvm.mlir.zero : !llvm.ptr
      %11 = "polygeist.pointer2memref"(%10) : (!llvm.ptr) -> memref<?x1xi32>
      %cast = memref.cast %alloca : memref<1xmemref<?x1xi32>> to memref<?xmemref<?x1xi32>>
      %12 = func.call @shmem_team_split_strided(%8, %c0_i32, %c2_i32, %9, %11, %c0_i64, %cast) : (memref<?x1xi32>, i32, i32, i32, memref<?x1xi32>, i64, memref<?xmemref<?x1xi32>>) -> i32
      %13 = arith.remsi %1, %c2_i32 : i32
      %14 = arith.cmpi ne, %13, %c0_i32 : i32
      scf.if %14 {
        %15 = memref.load %7[%c0] : memref<1xmemref<?x1xi32>>
        %16 = func.call @shmem_team_sync(%15) : (memref<?x1xi32>) -> i32
      } else {
        %15 = memref.load %alloca[%c0] : memref<1xmemref<?x1xi32>>
        %16 = func.call @shmem_team_sync(%15) : (memref<?x1xi32>) -> i32
      }
      func.call @shmem_finalize() : () -> ()
    }
    return %6 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_split_strided(memref<?x1xi32>, i32, i32, i32, memref<?x1xi32>, i64, memref<?xmemref<?x1xi32>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_sync(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
}

