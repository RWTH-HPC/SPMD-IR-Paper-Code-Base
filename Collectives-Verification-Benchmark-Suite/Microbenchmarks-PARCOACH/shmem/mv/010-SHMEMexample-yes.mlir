module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr, dense<64> : vector<4xi32>>, #dlti.dl_entry<f80, dense<128> : vector<2xi32>>, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<!llvm.ptr<272>, dense<64> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<271>, dense<32> : vector<4xi32>>, #dlti.dl_entry<!llvm.ptr<270>, dense<32> : vector<4xi32>>, #dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<"dlti.stack_alignment", 128 : i32>>, llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = "+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87", "polygeist.tune-cpu" = "generic", spmd.executionKind = "All"} {
  memref.global "private" @"g@static@i" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  memref.global "private" @"g@static@res" : memref<1xi32> = uninitialized {spmd.executionKind = "All"}
  func.func @main(%arg0: i32, %arg1: memref<?xmemref<?xi8>>) -> i32 attributes {llvm.linkage = #llvm.linkage<external>, spmd.executionKind = "All"} {
    %c0_i32 = arith.constant {spmd.executionKind = "All"} 0 : i32
    %c2_i32 = arith.constant {spmd.executionKind = "All"} 2 : i32
    %c0 = arith.constant {spmd.executionKind = "All"} 0 : index
    %c1_i64 = arith.constant {spmd.executionKind = "All"} 1 : i64
    %c256_i32 = arith.constant {spmd.executionKind = "All"} 256 : i32
    %c12_i32 = arith.constant {spmd.executionKind = "All"} 12 : i32
    %0 = "spmd.constReduceOp"() <{stringAttr = "SUM", usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.reduceOp
    %1 = "spmd.constDatatype"() <{typeAttr = i32, usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.datatype
    %2 = "spmd.commWorld"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.comm
    %3 = "spmd.init"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    %rank, %error = "spmd.getRankInComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %size, %error_0 = "spmd.getSizeOfComm"(%2) <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> (i32, !spmd.error)
    %4 = arith.remsi %rank, %c2_i32 {spmd.executionKind = "All"} : i32
    %5 = arith.cmpi ne, %4, %c0_i32 {spmd.executionKind = "All"} : i32
    scf.if %5 {
      %7 = memref.get_global @"g@static@i" : memref<1xi32> {spmd.executionKind = "Dynamic"}
      %8 = memref.get_global @"g@static@res" : memref<1xi32> {spmd.executionKind = "Dynamic"}
      memref.store %c0_i32, %8[%c0] {spmd.executionKind = "Dynamic"} : memref<1xi32>
      memref.store %c12_i32, %7[%c0] {spmd.executionKind = "Dynamic"} : memref<1xi32>
      %9 = arith.cmpi sgt, %size, %c256_i32 {spmd.executionKind = "Dynamic"} : i32
      scf.if %9 {
        %cast = memref.cast %8 {spmd.executionKind = "Dynamic"} : memref<1xi32> to memref<?xi32>
        %cast_2 = memref.cast %7 {spmd.executionKind = "Dynamic"} : memref<1xi32> to memref<?xi32>
        %error_3 = "spmd.allreduce"(%2, %cast_2, %cast, %c1_i64, %1, %0) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "Dynamic"} : (!spmd.comm, memref<?xi32>, memref<?xi32>, i64, !spmd.datatype, !spmd.reduceOp) -> !spmd.error
      } {spmd.executionKind = "Dynamic", spmd.isMultiValued = false}
    } {spmd.executionKind = "All", spmd.isMultiValued = true}
    %error_1 = "spmd.barrier"(%2) <{isBlocking = true, usedModel = 0 : i32}> {spmd.executionKind = "All"} : (!spmd.comm) -> !spmd.error
    %6 = "spmd.finalize"() <{usedModel = 0 : i32}> {spmd.executionKind = "All"} : () -> !spmd.error
    return {spmd.executionKind = "All"} %c0_i32 : i32
  }
}

