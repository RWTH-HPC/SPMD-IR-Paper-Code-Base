#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>

void c(ncclComm_t &commWorld, cudaStream_t &stream, int *buf_d){
  ncclGroupStart();
  ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
  ncclGroupEnd();
}

int main(int argc, char *argv[]) {
  int myRank, size;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (myRank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *buf_d;
  cudaStream_t stream;
  int ncclRank;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&buf_d, 0 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, size, id, myRank);
  ncclCommUserRank(commWorld, &ncclRank);

  if (ncclRank%2) {
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
  }
  else {
    c(commWorld, stream, buf_d);
  }

  //completing NCCL operation by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(buf_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  MPI_Finalize();
  return 0;
}