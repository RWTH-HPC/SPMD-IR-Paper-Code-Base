/* A bad example shows how CIVL catches the misusage of MPI collective
   routines. In this example, even processes and odd processes calls
   different nccl collective routines. */
#include "cuda_runtime.h"
#include "nccl.h"
#include <mpi.h>
// #include <assert.h>

int main(int argc, char * argv[]) {
  int nprocs, rank;
  int num;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  ncclUniqueId id;
  //get NCCL unique ID at rank 0 and broadcast it to all others
  if (rank == 0) {
      ncclGetUniqueId(&id);
  }
  MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

  ncclComm_t commWorld;
  int *num_d;
  int *recv_d;
  cudaStream_t stream;
  int ncclRank;
  
  //picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
  cudaSetDevice(0);
  cudaMalloc(&num_d, sizeof(int));
  cudaMalloc(&recv_d, sizeof(int));
  cudaStreamCreate(&stream);

  //initializing NCCL
  ncclCommInitRank(&commWorld, nprocs, id, rank);
  ncclCommUserRank(commWorld, &ncclRank);

  if(ncclRank == 0) {
    num = 3;
    cudaMemset(num_d, num, sizeof(int));
  }
  ncclBroadcast(num_d, num_d, 1, ncclInt, /*ROOT_PROCESS=*/0, commWorld, stream);
  
  if(ncclRank%2 ==  0)
    ncclReduce(num_d, recv_d, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);
  else
    ncclBroadcast(num_d, num_d, 1, ncclInt, /*ROOT_PROCESS=*/0, commWorld, stream);
  if(ncclRank == 0) {
    cudaMemcpy(&num, recv_d, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemset(num_d, num, sizeof(int));
  }
  if(ncclRank%2 == 0)
    ncclBroadcast(num_d, num_d, 1, ncclInt, /*ROOT_PROCESS=*/0, commWorld, stream);
  else
    ncclReduce(num_d, recv_d, 1, ncclInt, ncclSum, /*ROOT_PROCESS=*/0, commWorld, stream);

  // cudaMemcpy(&num, num_d, sizeof(int), cudaMemcpyDeviceToHost);
  // assert(num == 3 * nprocs);

  //completing NCCL operations by synchronizing on the CUDA stream
  cudaStreamSynchronize(stream);

  //free device buffers
  cudaFree(num_d);
  cudaFree(recv_d);

  //finalizing NCCL
  ncclCommDestroy(commWorld);

  MPI_Finalize();
  return 0;
}