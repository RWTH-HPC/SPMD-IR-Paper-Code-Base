#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>

int main(int argc, char *argv[]) {
  int rank, nRanks;
  int localData;
  int data = 42;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &nRanks);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *buff;
  int *localBuff;
  cudaStream_t stream;
  int myRank;
  
  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&buff, 1 * sizeof(int));
  cudaMemset(buff, 42, 1 * sizeof(int));
  cudaMalloc(&localBuff, 1 * sizeof(int));
  cudaMemset(localBuff, 8, 1 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, nRanks, id, rank);
  ncclCommUserRank(commWorld, &myRank);

  ncclAllReduce(buff, localBuff, 1, ncclInt, ncclSum, commWorld, stream);
  cudaMemcpy(&localData, localBuff, sizeof(int), cudaMemcpyDeviceToHost);
  if (myRank == 0) {
    //communicating using NCCL
    ncclBcast(buff, 1, ncclInt, /*ROOT_PROCESS=*/0, commWorld, stream);
  }
  else {
    if (localData == 21) {
      ncclBcast(buff, 1, ncclInt, /*ROOT_PROCESS=*/0, commWorld, stream);
    }
  }
  ncclAllGather(buff, buff, 0, ncclInt, commWorld, stream); //simulate barrier
  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(buff);
  cudaFree(localBuff);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  MPI_Finalize();
  return 0;
}