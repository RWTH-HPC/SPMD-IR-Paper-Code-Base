#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>

int main(int argc, char *argv[]) {
  int rank, nRanks;
  int data;
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
  int myRank;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&sendBuff, 1 * sizeof(int));
  cudaMemset(sendBuff, 13, 1 * sizeof(int));
  cudaMalloc(&recvBuff, 1 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, nRanks, id, rank);
  ncclCommUserRank(commWorld, &myRank);

  if (myRank == 0) {
    data = 42;
    ncclReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    ncclReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
  }
  ncclReduceScatter(sendBuff, recvBuff, 0, ncclInt, ncclSum, commWorld, stream); //simulate barrier
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