#include <stdlib.h>
#include <stdio.h>
#include "mpi.h"


int main(int argc, char** argv){
  int rank, size;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD,&size);

  if(size<2){
    printf("This test needs at least 2 MPI processes\n");
    MPI_Finalize();
    return 1;
  }

  MPI_Comm newComm;
  MPI_Comm_split(MPI_COMM_WORLD,rank%2,rank,&newComm);

  if(rank%2)
    MPI_Barrier(MPI_COMM_WORLD);
  else
    MPI_Barrier(newComm);


  MPI_Finalize();
  return 0;
}
