#include <mpi.h>
#include <stdlib.h>

int main(int argc, char** argv){
  int rank, size;

  MPI_Request req;
  MPI_Status status;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  int sendBuf[size];
  int recvBuf[size];
  for (size_t i=0; i<size;i++) {
    sendBuf[i] = i*rank;
  }

  if (rank%2) {
    MPI_Alltoall(sendBuf, size, MPI_INT, recvBuf, size, MPI_INT, MPI_COMM_WORLD);
  }
  else {
    MPI_Ialltoall(sendBuf, size, MPI_INT, recvBuf, size, MPI_INT, MPI_COMM_WORLD, &req);
    MPI_Wait(&req, &status);
  }

  MPI_Finalize();
  return 0;
}
