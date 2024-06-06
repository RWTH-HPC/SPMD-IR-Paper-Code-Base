#include <mpi.h>
#include <stdlib.h>

int main(int argc, char** argv){
  int rank, size;
  int recvData;

  MPI_Request req;
  MPI_Status status;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  int sendBuf[size];
  if (rank == 0){
    for (int i=0; i<size;i++) {
      sendBuf[i] = i;
    }
  }

  if (rank%2){
    MPI_Scatter(sendBuf, size, MPI_INT, &recvData, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    MPI_Iscatter(sendBuf, size, MPI_INT, &recvData, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD, &req);
    MPI_Wait(&req, &status);
  }

  MPI_Finalize();
  return 0;
}
