// 1/4 of ranks wait in Barrier in Line 38, remaining 3/4 wait in Reduce in Line 42 => deadlock
#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>

int main(int argc, char *argv[]) {
  int rank, size;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *buf_d, *sendBuff, *recvBuff;
  cudaStream_t stream;
  int myRank;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&sendBuff, 1 * sizeof(int));
  cudaMemset(sendBuff, 13, 1 * sizeof(int));
  cudaMalloc(&recvBuff, 1 * sizeof(int));
  cudaMalloc(&buf_d, 0 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, size, id, rank);

  ncclComm_t newComm;
  ncclCommUserRank(commWorld, &myRank);
  ncclCommSplit(commWorld, myRank%2, myRank, &newComm, NULL);

  if (myRank%4) {
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
    ncclReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, newComm, stream);
  }
  else {
    ncclReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, newComm, stream);
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
  }

  //completing NCCL operation by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(sendBuff);
  cudaFree(recvBuff);
  cudaFree(buf_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);
  ncclCommDestroy(newComm);

  MPI_Finalize();
  return 0; 
}