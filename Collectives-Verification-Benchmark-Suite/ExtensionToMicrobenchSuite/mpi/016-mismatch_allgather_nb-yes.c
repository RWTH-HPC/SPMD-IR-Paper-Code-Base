#include <mpi.h>
#include <stdlib.h>

int main(int argc, char** argv){
  int rank, size;
  int sendData = 42;

  MPI_Request req;
  MPI_Status status;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  int recvBuf[size];

  if (rank%2){
    MPI_Allgather(&sendData, 1, MPI_INT, recvBuf, size, MPI_INT, MPI_COMM_WORLD);
  }
  else {
    MPI_Iallgather(&sendData, 1, MPI_INT, recvBuf, size, MPI_INT, MPI_COMM_WORLD, &req);
    MPI_Wait(&req, &status);
  }

  MPI_Finalize();
  return 0;
}
