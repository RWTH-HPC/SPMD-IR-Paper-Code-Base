// Line 21 is called for all even ranks in commWorld. Line 23 is called for all odd ranks
// since not all processes are executing the respective waits it can lead to non-execution of comm. ops
// as the processes would run into mpi_finalize before executing the non-blocking communication ops

#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv){
  int rank;
  MPI_Request req1, req2;
  MPI_Status status1, status2;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm newcom;
  MPI_Comm_split(MPI_COMM_WORLD, rank%4, rank, &newcom);

  MPI_Ibarrier(MPI_COMM_WORLD,&req1);
  MPI_Ibarrier(newcom,&req2);
  if(rank%2){
    MPI_Wait(&req1, &status1);
  }else{
    MPI_Wait(&req2, &status2);
  }

  MPI_Comm_free(&newcom);
  MPI_Finalize();
  return 0;
}
