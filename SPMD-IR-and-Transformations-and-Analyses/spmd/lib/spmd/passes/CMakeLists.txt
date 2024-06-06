add_mlir_dialect_library(MLIRSPMDTransforms
        ConvertApiCallsToSPMD.cpp
        MultiValueAnalysis.cpp
        CheckCollectives.cpp

        DEPENDS
        MLIRSPMDOpsIncGen
        # MLIRSPMDAttributesIncGen
        MLIRSPMDPassesIncGen

        LINK_LIBS PUBLIC
        MLIRIR
        MLIRInferTypeOpInterface
        MLIRFuncDialect
        MLIRSPMDUtils
        MLIRSPMDAnalysis
)
add_subdirectory(CACTS)