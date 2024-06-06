#include <mpi.h>
#include <stdlib.h>

int main(int argc, char** argv){
  int rank;
  int sendData = 42;
  int recvData;

  MPI_Request req;
  MPI_Status status;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);

  if (rank%2) {
    MPI_Allreduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  } 
  else {
    MPI_Iallreduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD, &req);
    MPI_Wait(&req, &status);
  }

  MPI_Finalize();
  return 0;
}
