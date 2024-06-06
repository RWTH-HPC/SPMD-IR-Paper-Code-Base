module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>, #dlti.dl_entry<"dlti.endianness", "little">>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  llvm.mlir.global internal constant @str0("This test needs at least 2 MPI processes\0A\00") {addr_space = 0 : i32, spmd.executionKind = "All"}
  llvm.func @printf(!llvm.ptr, ...) -> i32 attributes {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %1 = llvm.mlir.undef {spmd.executionKind = "All"} : i32
    %2 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%0) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %size, %error_0 = "spmd.getSizeOfComm"(%0) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %3 = arith.cmpi slt, %size, %c2_i32 {spmd.executionKind = "All"} : i32
    %4 = arith.cmpi sge, %size, %c2_i32 {spmd.executionKind = "All"} : i32
    %5 = arith.select %3, %c1_i32, %1 {spmd.executionKind = "All"} : i32
    scf.if %3 {
      %7 = llvm.mlir.addressof @str0 {spmd.executionKind = "All"} : !llvm.ptr
      %8 = llvm.getelementptr %7[0, 0] {spmd.executionKind = "All"} : (!llvm.ptr) -> !llvm.ptr, !llvm.array<42 x i8>
      %9 = llvm.call @printf(%8) vararg(!llvm.func<i32 (ptr, ...)>) {spmd.executionKind = "All"} : (!llvm.ptr) -> i32
      %10 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    %6 = arith.select %4, %c0_i32, %5 {spmd.executionKind = "All"} : i32
    scf.if %4 {
      %7 = arith.remsi %rank, %c2_i32 {spmd.executionKind = "All"} : i32
      %newComm, %error_1 = "spmd.commSplit"(%0, %7, %rank) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, i32, i32) -> (!spmd.comm, !spmd.error)
      %8 = arith.remsi %rank, %c2_i32 {spmd.executionKind = "All"} : i32
      %9 = arith.cmpi ne, %8, %c0_i32 {spmd.executionKind = "All"} : i32
      scf.if %9 {
        %error_2 = "spmd.barrier"(%0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
      } else {
        %error_2 = "spmd.barrier"(%newComm) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm) -> !spmd.error
      } {spmd.executionKind = "All", spmd.isMultiValued = true}
      %10 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = false}
    return {spmd.executionKind = "All"} %6 : i32
  }
}

