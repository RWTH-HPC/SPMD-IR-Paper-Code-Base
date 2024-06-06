//===- utils.h - CACTS related utilities - Header -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This implements miscellaneous functionality  useful for the CACTS pass
// and related components that do not fit into one component. 
// Include several headers useful for multiple components.
//
//===----------------------------------------------------------------------===//

#ifndef UTILS_H
#define UTILS_H

#include "spmd/SPMDOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "llvm/Support/Debug.h"
#include "polygeist/Ops.h"

#define DEBUG_TYPE "convert-apiCalls-to-spmd"
#define PATTERN "main"
#define DBGS() ::llvm::dbgs() << "[" DEBUG_TYPE ":" << PATTERN << "] "

namespace mlir::spmd {
void removeUselessOpChainOfValue(Value val);

void removeUselessOpChainOfValue2(Operation *opr);

void removeMemref(Value memref);

void removeOpChainOfValue2(Value val);

void replaceMemrefByValue(Value memref, Value value);
} // namespace mlir::spmd

#endif // UTILS_H