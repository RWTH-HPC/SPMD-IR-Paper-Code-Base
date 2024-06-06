module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic"} {
  llvm.mlir.global internal constant @str0("process %d of %d processes\0A\00") {addr_space = 0 : i32}
  llvm.func @printf(!llvm.ptr, ...) -> i32
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> : () -> !spmd.comm
    %alloca = memref.alloca() : memref<memref<?x2xi32>>
    %1 = "spmd.init"() <{usedModel = 0 : i32}> : () -> !spmd.error
    %2 = memref.load %alloca[] : memref<memref<?x2xi32>>
    %rank, %error = "spmd.getRankInComm"(%0) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    memref.store %rank, %2[%c0, %c0] : memref<?x2xi32>
    %size, %error_0 = "spmd.getSizeOfComm"(%0) <{usedModel = 0 : i32}> : (!spmd.comm) -> (i32, !spmd.error)
    memref.store %size, %2[%c0, %c1] : memref<?x2xi32>
    %3 = arith.cmpi sgt, %size, %c1_i32 : i32
    scf.if %3 {
      %error_1 = "spmd.barrier"(%0) <{isBlocking = true, usedModel = 0 : i32}> : (!spmd.comm) -> !spmd.error
    }
    %4 = llvm.mlir.addressof @str0 : !llvm.ptr
    %5 = llvm.getelementptr %4[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<28 x i8>
    %6 = memref.load %2[%c0, %c0] : memref<?x2xi32>
    %7 = memref.load %2[%c0, %c1] : memref<?x2xi32>
    %8 = llvm.call @printf(%5, %6, %7) vararg(!llvm.func<i32 (ptr, ...)>) : (!llvm.ptr, i32, i32) -> i32
    %9 = "spmd.finalize"() <{usedModel = 0 : i32}> : () -> !spmd.error
    return %c0_i32 : i32
  }
}

