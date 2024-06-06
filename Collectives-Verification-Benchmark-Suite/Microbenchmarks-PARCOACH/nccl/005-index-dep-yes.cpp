#include "cuda_runtime.h"
#include "nccl.h"
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void f(){
  int rank,size;
  MPI_Comm_size(MPI_COMM_WORLD,&size);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *buf_d;
  cudaStream_t stream;
  int r, s;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&buf_d, 0 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, size, id, rank);
  ncclCommUserRank(commWorld, &r);
  ncclCommCount(commWorld, &s);

  int *A = (int*)malloc(s);
  for(int i=0; i<s; i++)
    A[i] = i;

  if(A[r] > 10)
    ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier

  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(buf_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);
}


int main(int argc, char **argv){
  MPI_Init(&argc,&argv);
  f();
  MPI_Finalize();
  return 0;
}