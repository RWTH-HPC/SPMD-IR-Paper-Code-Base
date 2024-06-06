#define ORDER 1

/* An example shows the misusage of nccl collective routines. */
#include "cuda_runtime.h"
#include "nccl.h"
#include<mpi.h>
#include <stdio.h>

int main(int argc, char* argv[]){
  int rank;
  int procs;
  int localsum, sum;
  
  MPI_Init(&argc,&argv);
  MPI_Comm_size(MPI_COMM_WORLD, &procs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  
  localsum = 0;
  for(int i=0; i<=rank; i++){
    localsum += i;
  }
  printf("process %d has local sum of %d\n", rank, localsum);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *localsum_d;
  int *sumBuf;
  int *recvBuf2;
  cudaStream_t stream;
  int ncclRank;
  
  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&localsum_d, sizeof(int));
  cudaMemset(localsum_d, localsum, sizeof(int));
  cudaMalloc(&sumBuf, sizeof(int));
  cudaMalloc(&recvBuf2, procs * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, procs, id, rank);
  ncclCommUserRank(commWorld, &ncclRank);

#ifdef ORDER
  if(ncclRank%2){
    printf("process %d enters allgather\n", ncclRank);
    ncclAllGather(localsum_d, recvBuf2, 1, ncclInt, commWorld, stream);
    printf("process %d exits allgather\n", ncclRank);
    ncclReduce(localsum_d, sumBuf, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
  }else{
    ncclReduce(localsum_d, sumBuf, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
    printf("process %d enters allgather\n", ncclRank);
    ncclAllGather(localsum_d, recvBuf2, 1, ncclInt, commWorld, stream);
    printf("process %d exits allgather\n", ncclRank);
  }
#else
  printf("process %d enters allgather\n", ncclRank);
  ncclAllGather(localsum_d, recvBuf2, 1, ncclInt, commWorld, stream);
  printf("process %d exits allgather\n", ncclRank);
  ncclReduce(localsum_d, sumBuff, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
#endif
  if(ncclRank == 0) {
    cudaMemcpy(&sum, sumBuf, sizeof(int), cudaMemcpyDeviceToHost);
    printf("total sum is %d\n", sum);
  }

  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(localsum_d);
  cudaFree(sumBuf);
  cudaFree(recvBuf2);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  MPI_Finalize();
  return 0;
}