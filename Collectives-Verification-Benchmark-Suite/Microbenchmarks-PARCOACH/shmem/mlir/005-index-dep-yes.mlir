module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  func.func @f() attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c4_i64 = arith.constant 4 : i64
    %c10_i32 = arith.constant 10 : i32
    %0 = call @shmem_n_pes() : () -> i32
    %1 = call @shmem_my_pe() : () -> i32
    %2 = arith.extsi %0 : i32 to i64
    %3 = arith.muli %2, %c4_i64 : i64
    %4 = call @shmem_malloc(%3) : (i64) -> memref<?xi8>
    %5 = "polygeist.memref2pointer"(%4) : (memref<?xi8>) -> !llvm.ptr
    %6 = arith.index_cast %0 : i32 to index
    scf.for %arg0 = %c0 to %6 step %c1 {
      %10 = arith.index_cast %arg0 : index to i32
      %11 = llvm.getelementptr %5[%10] : (!llvm.ptr, i32) -> !llvm.ptr, i32
      llvm.store %10, %11 : i32, !llvm.ptr
    }
    %7 = llvm.getelementptr %5[%1] : (!llvm.ptr, i32) -> !llvm.ptr, i32
    %8 = llvm.load %7 : !llvm.ptr -> i32
    %9 = arith.cmpi sgt, %8, %c10_i32 : i32
    scf.if %9 {
      func.call @shmem_sync_all() : () -> ()
    }
    call @shmem_free(%4) : (memref<?xi8>) -> ()
    return
  }
  func.func private @shmem_n_pes() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_my_pe() -> i32 attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_malloc(i64) -> memref<?xi8> attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_sync_all() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_free(memref<?xi8>) attributes {llvm.linkage = #llvm.linkage<external>}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c10_i32 = arith.constant 10 : i32
    %c4_i64 = arith.constant 4 : i64
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    call @shmem_init() : () -> ()
    %0 = call @shmem_n_pes() : () -> i32
    %1 = call @shmem_my_pe() : () -> i32
    %2 = arith.extsi %0 : i32 to i64
    %3 = arith.muli %2, %c4_i64 : i64
    %4 = call @shmem_malloc(%3) : (i64) -> memref<?xi8>
    %5 = "polygeist.memref2pointer"(%4) : (memref<?xi8>) -> !llvm.ptr
    %6 = arith.index_cast %0 : i32 to index
    scf.for %arg2 = %c0 to %6 step %c1 {
      %10 = arith.index_cast %arg2 : index to i32
      %11 = llvm.getelementptr %5[%10] : (!llvm.ptr, i32) -> !llvm.ptr, i32
      llvm.store %10, %11 : i32, !llvm.ptr
    }
    %7 = llvm.getelementptr %5[%1] : (!llvm.ptr, i32) -> !llvm.ptr, i32
    %8 = llvm.load %7 : !llvm.ptr -> i32
    %9 = arith.cmpi sgt, %8, %c10_i32 : i32
    scf.if %9 {
      func.call @shmem_sync_all() : () -> ()
    }
    call @shmem_free(%4) : (memref<?xi8>) -> ()
    call @shmem_finalize() : () -> ()
    return %c0_i32 : i32
  }
  func.func private @shmem_init() attributes {llvm.linkage = #llvm.linkage<external>}
  func.func private @shmem_finalize() attributes {llvm.linkage = #llvm.linkage<external>}
}

