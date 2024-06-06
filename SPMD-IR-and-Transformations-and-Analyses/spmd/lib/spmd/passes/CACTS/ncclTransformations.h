//===- ncclTransformations.h - Convert nccl api calls to spmd dialect - Header -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This declares functions for converting nccl func call operations to the spmd dialect
//
//===----------------------------------------------------------------------===//

#include "utils.h"

#ifndef NCCL_TRANSFORMATIONS_H
#define NCCL_TRANSFORMATIONS_H

namespace mlir::spmd {
// Entry function for the nccl transformation component that replaces func.CallOps by spmd.ops
void convertApiCallNCCL(func::CallOp callOp, int modelGroup);

// Deletes Function Callees of nccl calls replaces by spmd
void deleteApiCalleesNCCL(ModuleOp moduleOp);
} // namespace mlir::spmd

#endif // NCCL_TRANSFORMATIONS_H