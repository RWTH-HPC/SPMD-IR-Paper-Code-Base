// even ranks go first in Reduce in Line 39 and since they constitute the whole splitComm they can finish the op and go to barrier
// odd ranks wait in Barrier in Line 43 and can move to Reduce Line 44 as soon as even ranks finishes their ReduceOp.
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
  ncclCommUserRank(commWorld, &myRank);

	ncclComm_t newComm;
	ncclCommSplit(commWorld, myRank%2, myRank, &newComm, NULL);

  if (myRank%2) {
    ncclReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, newComm, stream);
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
  }
  else {
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
    ncclReduce(sendBuff, recvBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, newComm, stream);
  }
  //completing NCCL operations by synchronizing on the CUDA stream
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