#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>

int main(int argc, char *argv[]) {
  int rank, nRanks;
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
  int *sendBuff;
  int *recvBuff;
  cudaStream_t stream;
  int myRank, size;
  
  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&sendBuff, 1 * sizeof(int));
  cudaMalloc(&recvBuff, 1 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, nRanks, id, rank);
  ncclCommUserRank(commWorld, &myRank);
  ncclCommCount(commWorld, &size);

  if(size!=4){
    cudaFree(sendBuff);
    cudaFree(recvBuff);
    ncclCommDestroy(commWorld);
    MPI_Finalize();
    return 1;
  }

  if (myRank == 0 || myRank == 1) {
    cudaMemset(sendBuff, 10, 1 * sizeof(int));
    ncclAllReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, commWorld, stream);
  }
  if (myRank == 2 || myRank == 3) {
    cudaMemset(sendBuff, 20, 1 * sizeof(int));
    ncclAllReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, commWorld, stream);
  }
  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(sendBuff);
  cudaFree(recvBuff);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  MPI_Finalize();
  return 0;
}