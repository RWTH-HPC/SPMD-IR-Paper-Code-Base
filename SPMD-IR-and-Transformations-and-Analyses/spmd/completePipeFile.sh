#!/bin/bash

inputFile=$2
inputDir="$(dirname "${inputFile}")"
outputFile="${inputDir}/../tmp.mlir"

debug=true
numRanks=$3
if [[ -z $3 ]]; then
    numRanks=0
fi

if [ $# -lt 2 ]; then
   echo 'Too few arguments specified, there should be atleast two. (filepath and programming model)'
   exit
elif [ $# -gt 3 ]; then
    echo 'Too many arguments specified, there should be maximum three. (filepath and programming model and numRanks)'
    exit
fi

if [ $1 == "mpi" ]; then
    ml mpich/4.1.2
elif [ $1 == "shmem" ]; then
    CPATH=ABSOLUTEPATHTO/SOS/build/include:$CPATH
elif [[ $1 == "nccl" || $1 == "mpi+nccl" ]]; then
    ml mpich/4.1.2
    CPATH=ABSOLUTEPATHTO/nccl/build/include:$CPATH
elif [ $1 == "mpi+shmem" ]; then
    ml use /home/ja664344/.modules/rl8 &&  ml mpich/4.1.2
    CPATH=ABSOLUTEPATHTO/SOS/build/include:$CPATH
elif [ $1 == "shmem+nccl" ]; then
    CPATH=ABSOLUTEPATHTO/SOS/build/include:$CPATH
    CPATH=ABSOLUTEPATHTO/nccl/build/include:$CPATH
else
    echo 'Unkown second argument. Expecting "mpi", "shmem", "nccl.", "shmem+nccl", "mpi+shmem", or "mpi+nccl".'
    exit
fi

if [ $debug = true ]; then
    polygeistBinDir=ABSOLUTEPATHTO/polygeist-debug-build/bin
    spmdOpt=ABSOLUTEPATHTO/spmd-debug-build/bin/spmd-opt 
    echo "Toolchain in debug mode"
else
    polygeistBinDir=ABSOLUTEPATHTO/Polygeist/build/bin
    spmdOpt=ABSOLUTEPATHTO/spmd/build/bin/spmd-opt 
    echo "Toolchain in release mode"
fi


polygeistOpt="${polygeistBinDir}/polygeist-opt"
polygeistFlags="-lower-affine -inline -canonicalize -mlir-print-debuginfo"

cgeist="${polygeistBinDir}/cgeist"
cgeistFlags="-S -I$CPATH -print-debug-info"

spmdFlags="-convert-apiCalls-to-spmd="used-model=$1" -multi-value-analysis -check-collectives="num-ranks=$numRanks" " 

$cgeist $cgeistFlags $inputFile  | $polygeistOpt  $polygeistFlags  | $spmdOpt $spmdFlags -o $outputFile
