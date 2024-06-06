/**
 * This program has an error because not all processes 
 * execute ncclAllReduce and ncclReduceScatter in the same order.
 */

#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]){
  int rank;
  int procs;
  
  MPI_Init(&argc,&argv);
  MPI_Comm_size(MPI_COMM_WORLD, &procs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  
  int *sendData = (int*)malloc(sizeof(int)*procs);
  int *recvData  = (int*)malloc(sizeof(int));

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
    ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *sendData_d;
  int *recvData_d;
  int *recvBuf2_d;
  cudaStream_t stream;
  int device, ncclRank;
  
  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&sendData_d, procs * sizeof(int));
  cudaMalloc(&recvData_d, procs * sizeof(int));
  cudaMalloc(&recvBuf2_d, sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, procs, id, rank);
  
  ncclCommUserRank(commWorld, &ncclRank);
  ncclCommCuDevice(commWorld, &device);

  if(ncclRank == 0)
  {
    for(int i=0; i<procs; i++){
      sendData[i] = procs - i;
    }
    cudaMemcpy(sendData_d, sendData, sizeof(int) * procs, cudaMemcpyHostToDevice);
    ncclAllReduce(sendData_d, recvData_d, procs, ncclInt, ncclSum, commWorld, stream);
    ncclReduceScatter(sendData_d, recvBuf2_d, procs, ncclInt, ncclSum, commWorld, stream);
  }else{
    ncclReduceScatter(sendData_d, recvBuf2_d, procs, ncclInt, ncclSum, commWorld, stream);
    ncclAllReduce(sendData_d, recvData_d, procs, ncclInt, ncclSum, commWorld, stream);
    cudaMemcpy(recvData, recvBuf2_d, sizeof(int), cudaMemcpyDeviceToHost);
    printf("process %d with device %d receives %d\n", ncclRank, device, *recvData);
  }
  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(sendData_d);
  cudaFree(recvData_d);
  cudaFree(recvBuf2_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  free(sendData);
  free(recvData);
  MPI_Finalize();
  return 0;
}