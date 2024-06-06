// added additionally to the original test case from parcoach the printf below funcCall of f
// this necessate proper handling and transformation of the struct (memrefs) to values.
#include "cuda_runtime.h"
#include "nccl.h"
#include <stdio.h>
#include <mpi.h>

typedef struct _hydroparam {
  int mype;
  int nproc;
}hydroparam_t;


void f(hydroparam_t *H){
  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *buf_d;
  cudaStream_t stream;

  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&buf_d, 0 * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, size, id, rank);
  ncclCommUserRank(commWorld, &H->mype);
  ncclCommCount(commWorld, &H->nproc);
  
  if(H->nproc > 1)
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
  hydroparam_t *H;
  f(H);	
  printf("process %d of %d processes\n", H->mype, H->nproc);
  MPI_Finalize();
  return 0;
}