module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c1_i32 = arith.constant {spmd.executionKind = "All"} 1 : i32
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c4_i32 = arith.constant {spmd.executionKind = "All"} 4 : i32
    %0 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %alloca = memref.alloca() {spmd.executionKind = "All"} : memref<1x!spmd.status>
    %alloca_0 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!spmd.status>
    %alloca_1 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!spmd.req>
    %alloca_2 = memref.alloca() {spmd.executionKind = "All"} : memref<1x!spmd.req>
    %1 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%0) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %2 = arith.remsi %rank, %c4_i32 {spmd.executionKind = "All"} : i32
    %newComm, %error_3 = "spmd.commSplit"(%0, %2, %rank) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm, i32, i32) -> (!spmd.comm, !spmd.error)
    %req, %error_4 = "spmd.barrier"(%0) <{isBlocking = false, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (!spmd.req, !spmd.error)
    memref.store %req, %alloca_2[%c0] {spmd.executionKind = "All"} : memref<1x!spmd.req>
    %req_5, %error_6 = "spmd.barrier"(%newComm) <{isBlocking = false, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (!spmd.req, !spmd.error)
    memref.store %req_5, %alloca_1[%c0] {spmd.executionKind = "All"} : memref<1x!spmd.req>
    %3 = arith.remsi %rank, %c2_i32 {spmd.executionKind = "All"} : i32
    %4 = arith.cmpi ne, %3, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %4 {
      %6 = "spmd.waitAll"(%c1_i32, %alloca_2, %alloca_0) <{usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (i32, memref<1x!spmd.req>, memref<1x!spmd.status>) -> !spmd.error
    } else {
      %6 = "spmd.waitAll"(%c1_i32, %alloca_1, %alloca) <{usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (i32, memref<1x!spmd.req>, memref<1x!spmd.status>) -> !spmd.error
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %5 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

