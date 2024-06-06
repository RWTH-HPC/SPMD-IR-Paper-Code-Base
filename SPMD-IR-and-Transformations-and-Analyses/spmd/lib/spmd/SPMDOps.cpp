//===- SPMDOps.cpp - SPMD dialect ops ---------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "spmd/SPMDOps.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "spmd/SPMDDialect.h"
// #include "mlir/IR/OpImplementation.h"

#define GET_OP_CLASSES
#include "spmd/SPMDOps.cpp.inc"

using namespace mlir;
using namespace spmd;

void RecvOp::getEffects(SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
    // Add a write effect, but not tied to any operand
    effects.emplace_back(MemoryEffects::Write::get());
    // Add a read effect on operand "sendBuf"
    for (Value value : getODSOperands(1))
        effects.emplace_back(MemoryEffects::Read::get(), value);
    // Add a read and write effect on operand "stream"
    for (Value value : getODSOperands(6)) {
        effects.emplace_back(MemoryEffects::Read::get(), value);
        effects.emplace_back(MemoryEffects::Write::get(), value);
    }
}

void SendOp::getEffects(SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
    // Add a write effect, but not tied to any operand
    effects.emplace_back(MemoryEffects::Write::get());
    // Add a read effect on operand "sendBuf"
    for (Value value : getODSOperands(1))
        effects.emplace_back(MemoryEffects::Read::get(), value);
    // Add a read and write effect on operand "stream"
    for (Value value : getODSOperands(6)) {
        effects.emplace_back(MemoryEffects::Read::get(), value);
        effects.emplace_back(MemoryEffects::Write::get(), value);
    }
}
