#include "cuda_runtime.h"
#include "nccl.h"
#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>



void g(int s, ncclComm_t &comm, cudaStream_t &stream){
  int *i, *res;
  cudaMalloc(&i, 1 * sizeof(int));
  cudaMalloc(&res, 1 * sizeof(int));
  cudaMemset(i, 0, sizeof(int));
  cudaMemset(res, 12, sizeof(int));

  if(s>256)
    ncclReduce(&i, &res, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, comm, stream);

  cudaFree(i);
  cudaFree(res);
  }

void f(){
  int size,rank,n;

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
  int s, r;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&buf_d, 0 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, size, id, rank);
  ncclCommUserRank(commWorld, &r);
  ncclCommCount(commWorld, &s);

  if(r%2)
    n=1;
  else
    n=2;

  if(n==1)
    g(s, commWorld, stream);

  ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier

  //completing NCCL operation by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(buf_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);
}


int main(int argc, char** argv){
  MPI_Init(&argc,&argv);
  f();
  MPI_Finalize();
  return 0;
}