#include "cuda_runtime.h"
#include "nccl.h"
#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>


int main(int argc, char** argv){
  int rank, size, i=1, j=1;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD,&size);

  if(size<2){
    printf("This test needs at least 2 MPI processes\n");
    MPI_Finalize();
    return 1;
  }

  ncclUniqueId id;
	//get NCCL unique ID at rank 0 and broadcast it to all others
	if (rank == 0) {
		ncclGetUniqueId(&id);
	}
	MPI_Bcast(&id, sizeof(id), MPI_BYTE, 0, MPI_COMM_WORLD);

	ncclComm_t commWorld;
	int *buf_d;
	cudaStream_t stream;
  int myRank;

	//picking a GPU based on mpiRank (assuming one mpi rank per node with one gpu), allocate device buffers
	cudaSetDevice(0);
	cudaMalloc(&buf_d, 0 * sizeof(int));
	cudaStreamCreate(&stream);

	//initializing NCCL
	ncclCommInitRank(&commWorld, size, id, rank);
  ncclCommUserRank(commWorld, &myRank);

  if(myRank%2){
    while(i<10){
      ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
      i++;
    }
  }else{
    while(j<10){
      ncclAllGather(buf_d, buf_d, 0, ncclInt, commWorld, stream); //simulate barrier
      j++;
    }
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