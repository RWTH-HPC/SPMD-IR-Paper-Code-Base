module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str0("This test needs at least 2 shmem processes\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2_i32 = arith.constant 2 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %0 = llvm.mlir.undef : i32
    call @shmem_init() : () -> ()
    %1 = call @shmem_my_pe() : () -> i32
    %2 = arith.cmpi ne, %1, %c0_i32 : i32
    %3 = call @shmem_n_pes() : () -> i32
    %4 = arith.cmpi sge, %3, %c2_i32 : i32
    %5 = arith.cmpi slt, %3, %c2_i32 : i32
    %6 = arith.select %5, %c1_i32, %0 : i32
    scf.if %5 {
      %8 = llvm.mlir.addressof @str0 : !llvm.ptr
      %9 = llvm.getelementptr %8[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<44 x i8>
      %10 = llvm.call @printf(%9) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr) -> i32
      func.call @shmem_finalize() : () -> ()
    }
    %7 = arith.select %4, %c0_i32, %6 : i32
    scf.if %4 {
      %8 = arith.select %2, %c2_i32, %c1_i32 : i32
      %9 = arith.cmpi eq, %8, %c2_i32 : i32
      scf.if %9 {
        func.call @shmem_sync_all() : () -> ()
      }
      func.call @shmem_finalize() : () -> ()
    }
    return %7 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_sync_all() attributes {llvm.linkage = #llvm.linkage<external>}
}

