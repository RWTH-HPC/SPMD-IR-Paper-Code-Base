//===- SPMDAttributes.td - SPMD dialect attributes -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SPMD_ATTRIBUTES
#define SPMD_ATTRIBUTES

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"
include "spmd/SPMDDialect.td"

//===----------------------------------------------------------------------===//
// SPMD type definitions
//===----------------------------------------------------------------------===//

class SPMD_Attribute<string attrName, string attrMnemonic, list<Trait> traits = []>
    : TypeDef<SPMD_Dialect, attrName, traits> {
  let mnemonic = attrMnemonic;
}

#endif // SPMD_ATTRIBUTES
