#include "cuda_runtime.h"
#include "nccl.h"
#include <stdio.h>
#include <mpi.h>

void g(int s, int *buf_d, ncclComm_t &comm, cudaStream_t &stream){
	if(s)
		ncclAllGather(buf_d, buf_d, 0, ncclInt, comm, stream); //simulate barrier
}


int main(int argc, char **argv) {
  int size, rank,s=1;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD,&size);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *buf_d;
  cudaStream_t stream;
  int r;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&buf_d, 0 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, size, id, r);
  ncclCommUserRank(commWorld, &r);

  ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier

  g(s, buf_d, commWorld, stream);
  s=r%2;

  if(s)
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier

  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(buf_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  MPI_Finalize();
  return 0;
}