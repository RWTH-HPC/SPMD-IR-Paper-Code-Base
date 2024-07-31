//===- mpiTransformations.h - Convert mpi api calls to spmd dialect - Header -----------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This declares functions for converting mpi func call operations to the spmd dialect
//
//===----------------------------------------------------------------------===//

#include "utils.h"

#ifndef MPI_TRANSFORMATIONS_H
#define MPI_TRANSFORMATIONS_H

namespace mlir::spmd {
// Entry function for the mpi transformation component that replaces func.CallOps by spmd.ops
void convertApiCallMPI(func::CallOp callOp, int modelGroup);

// Deletes Function Callees of MPI calls replaces by spmd
void deleteApiCalleesMPI(ModuleOp moduleOp);
}  // namespace mlir::spmd

#endif // MPI_TRANSFORMATIONS_H