//===- SPMDTypes.td - SPMD dialect types -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SPMD_TYPES
#define SPMD_TYPES

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinTypeInterfaces.td"
include "spmd/SPMDDialect.td"

//===----------------------------------------------------------------------===//
// SPMD type definitions
//===----------------------------------------------------------------------===//

class SPMD_Type<string typeName, string typeMnemonic, list<Trait> traits = []>
    : TypeDef<SPMD_Dialect, typeName, traits> {
  let mnemonic = typeMnemonic;
}

def SPMD_CommType : SPMD_Type<"Comm", "comm"> {
    let summary = "spmd communicator type";
    let description = [{
      `!spmd.comm` is a type returned by commuicator creating operations
       or as input for communicator using operations.

      Example:

      ```mlir
      !spmd.comm
      ```
    }];
    // let parameters = (ins StringRefParameter<"the custom value">:$value);
    // let assemblyFormat = "`<` $value `>`";
}

def SPMD_CommConfigType : SPMD_Type<"CommConfig", "commConfig"> {
    let summary = "spmd communicator/team config type";
    let description = [{
      `!spmd.commConfig` is a type of the optional config argument for creating comms.

      Example:

      ```mlir
      !spmd.commConfig
      ```
    }];
}

def SPMD_ErrorType : SPMD_Type<"Error", "error"> {
    let summary = "spmd error type";
    let description = [{
      `!spmd.error` is a type of the last return value returned by the most spmd operations.

      Example:

      ```mlir
      !spmd.error
      ```
    }];
}

def SPMD_ReqType : SPMD_Type<"Req", "req", [DeclareTypeInterfaceMethods<MemRefElementTypeInterface, []>]> {
    let summary = "spmd req type";
    let description = [{
      `!spmd.req` is returned by non-blocking communication operations

      Example:

      ```mlir
      !spmd.req
      ```
    }];
}

def SPMD_StatusType : SPMD_Type<"Status", "status", [DeclareTypeInterfaceMethods<MemRefElementTypeInterface, []>]> {
    let summary = "spmd status type";
    let description = [{
      `!spmd.status` is a type of the returned values of many spmd query operations.

      Example:

      ```mlir
      !spmd.status
      ```
    }];
}

def SPMD_StreamType : SPMD_Type<"Stream", "stream"> {
    let summary = "spmd stream type";
    let description = [{
      `!spmd.stream` is a type of a stream that is used by gpu programming models.

      Example:

      ```mlir
      !spmd.stream
      ```
    }];
}

def SPMD_DatatypeType : SPMD_Type<"Datatype", "datatype"> {
    let summary = "spmd datatype type";
    let description = [{
      `!spmd.datatype` is a type for specifying the datatype of an spmd operations.

      Example:

      ```mlir
      !spmd.datatype
      ```
    }];
}

def SPMD_ReduceOpType : SPMD_Type<"ReduceOp", "reduceOp"> {
    let summary = "spmd reduceOp type";
    let description = [{
      `!spmd.reduceOp` is a type for specifying the operation of an spmd reduce.

      Example:

      ```mlir
      !spmd.reduceOp
      ```
    }];
}
#endif // SPMD_TYPES
