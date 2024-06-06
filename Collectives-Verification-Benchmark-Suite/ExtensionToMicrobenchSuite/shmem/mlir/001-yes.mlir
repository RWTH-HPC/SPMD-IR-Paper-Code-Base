module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  memref.global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c4_i64 = arith.constant 4 : i64
    %c2_i64 = arith.constant 2 : i64
    %c42_i32 = arith.constant 42 : i32
    %c0_i32 = arith.constant 0 : i32
    call @shmem_init() : () -> ()
    %0 = call @shmem_n_pes() : () -> i32
    %1 = arith.extsi %0 : i32 to i64
    %2 = arith.muli %1, %c4_i64 : i64
    %3 = call @shmem_malloc(%2) : (i64) -> memref<?xi8>
    %4 = "polygeist.memref2pointer"(%3) : (memref<?xi8>) -> !llvm.ptr
    %5 = "polygeist.pointer2memref"(%4) : (!llvm.ptr) -> memref<?xi32>
    %6 = memref.get_global @SHMEM_TEAM_WORLD : memref<1xmemref<?x1xi32>>
    %7 = memref.load %6[%c0] : memref<1xmemref<?x1xi32>>
    %8 = call @shmem_team_my_pe(%7) : (memref<?x1xi32>) -> i32
    %9 = arith.cmpi eq, %8, %c0_i32 : i32
    scf.if %9 {
      llvm.store %c42_i32, %4 : i32, !llvm.ptr
      %12 = memref.load %6[%c0] : memref<1xmemref<?x1xi32>>
      %13 = func.call @shmem_int_broadcast(%12, %5, %5, %c2_i64, %c0_i32) : (memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32
    }
    %10 = memref.load %6[%c0] : memref<1xmemref<?x1xi32>>
    %11 = call @shmem_team_sync(%10) : (memref<?x1xi32>) -> i32
    call @shmem_free(%3) : (memref<?xi8>) -> ()
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_malloc(i64) -> memref<?xi8> attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_my_pe(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_int_broadcast(memref<?x1xi32>, memref<?xi32>, memref<?xi32>, i64, i32) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_team_sync(memref<?x1xi32>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_free(memref<?xi8>) attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
}

