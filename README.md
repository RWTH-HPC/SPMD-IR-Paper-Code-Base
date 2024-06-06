# SPMD-IR-Paper-Code-Base
This repository includes the code base of the paper "SPMD IR: Unifying SPMD and Multi-value IR Showcased for Static Verification of Collectives" by Semih Burak, Ivan R. Ivanov, Jens Domke, and Matthias Müller accepted at EuroMPI2024.

## Directory Structure
- The directory "Collectives-Verification-Benchmark-Suite" contains all codes used for the evaluation in the paper, including the ports and newly created test cases.
- The directory "SPMD-IR-and-Transformations-and-Analyses" contains the implementation of the SPMD IR, the necessary transformations, and the ported collectives verification analysis in MLIR. It contains a single sub-directory "spmd" that tries to resemble the structure of https://github.com/llvm/Polygeist and generally adviced in https://mlir.llvm.org/docs/Tutorials/CreatingADialect/.

## Building Hints
- Please refer to the paper for details of which software and versions were used
- This setup assumes that you build the project as part of a monolithic LLVM build via the `LLVM_EXTERNAL_PROJECTS` mechanism.
- It is advised to build first Polygeist (https://github.com/llvm/Polygeist) along with the llvm-project in a sibling directory via the `LLVM_EXTERNAL_PROJECTS` mechanism too.
- An exemplary cmake building command for the SPMD dialect could look like:
```sh
mkdir build && cd build
cmake -G Ninja ../Polygeist/llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD=host \
    -DLLVM_ENABLE_PROJECTS="mlir" \
    -DLLVM_EXTERNAL_PROJECTS=spmd-dialect \
    -DLLVM_EXTERNAL_SPMD_DIALECT_SOURCE_DIR=../spmd 
cmake --build .
```

## Usage Hints
For reproducing results in the paper, one might want to reuse the shell script "completePipeFile.sh" for getting a collective verification report for one file (do not forget to replace "ABSOLUTEPATHTO" places). It takes a C/C++ program as input, applies cgeist/polygeist first, and then it applies "convert-apiCalls-to-spmd" (Unification Pass), "multi-value-analysis" (MV-Analysis Pass), "check-collectives" (Collectives Verification Pass) passes of the SPMD dialect onto it. The result will be either that no collective communication error is present or a report specifying the found error.


## License
This software project is available under the Apache License v2.0 with LLVM Exceptions license. See the LICENSE file for more info.
