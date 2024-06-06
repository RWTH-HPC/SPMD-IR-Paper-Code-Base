#include "cuda_runtime.h"
#include "nccl.h"
#include <shmem.h>

int main(int argc, char *argv[]) {
  shmem_init();
  int myPE = shmem_my_pe();
  int nPEs = shmem_n_pes();
  
  static int data;
  static ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (myPE == 0) {
    ncclGetUniqueId(&id);
  }
  shmem_broadcastmem(SHMEM_TEAM_WORLD, &id, &id, sizeof(id), /*ROOT_PROCESS=*/0);

  int size = 1;
  ncclComm_t commWorld;
  int *sendBuff;
  int *recvBuff;
  cudaStream_t stream;
  
  //picking a GPU based on shmemPE (assuming one shmem pe per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&sendBuff, size * sizeof(int));
  cudaMemset(sendBuff, 13, size * sizeof(int));
  cudaMalloc(&recvBuff, size * sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, nPEs, id, myPE);

  if (myPE == 0) {
    data = 42;
    ncclReduce(sendBuff, recvBuff, size, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
  }
  else {
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
    ncclReduce(sendBuff, recvBuff, size, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
  }
  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);
  shmem_sync_all();

  //free device buffers
  cudaFree(sendBuff);
  cudaFree(recvBuff);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  shmem_finalize();
  return 0;
}