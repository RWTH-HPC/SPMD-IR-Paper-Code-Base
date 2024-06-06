//===- SPMDPasses.td - SPMD dialect passes -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SPMD_PASSES
#define SPMD_PASSES

include "mlir/Pass/PassBase.td"

def ConvertApiCallsToSPMD : Pass<"convert-apiCalls-to-spmd", "ModuleOp"> { 
  let summary = "Converts api calls related to collectives of different programming models such as MPI or OpenSHMEM to a so-called SPMD dialect.";
  let description = [{
    sample Text
  }];
  let dependentDialects = ["spmd::SPMDDialect"];
  let options = [Option<"usedModel", "used-model", "std::string", /*default=*/"\"mpi\"",
      "Specifies the programming model used in the application. Currently supported: mpi, shmem, nccl. Default=mpi">];
  let statistics = [];
}

def MultiValueAnalysis : Pass<"multi-value-analysis", "ModuleOp"> { 
  let summary = "Analyse IR and add attributes specifying multi-valuedness and executor behavior.";
  let description = [{
    sample Text
  }];
  let dependentDialects = [];
  let options = [];
  let statistics = [];
}

def CheckCollectives : Pass<"check-collectives", "ModuleOp"> { 
  let summary = "Checks statically if the given IR includes a collective communication error.";
  let description = [{
    sample Text
  }];
  let dependentDialects = [];
  let options = [
    Option<"numRanks", "num-ranks", "uint64_t",
           /*default=*/"0",
           "Set number of ranks with which the spmd programm shall be run (default: 0, meaning unspecified)">];
  let statistics = [];
}

#endif // SPMD_PASSES
