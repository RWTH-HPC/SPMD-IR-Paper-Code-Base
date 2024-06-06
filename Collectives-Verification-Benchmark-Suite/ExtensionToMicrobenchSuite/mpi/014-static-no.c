#include <mpi.h>
// This program shall be executed by 4 ranks, then no collective error is given

int main(int argc, char *argv[]) {
  int myRank, size;
  int sendData;
  int recvData;
  
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  if(size!=4){
    MPI_Finalize();
    return 1;
  }

  if (myRank == 0 || myRank == 1) {
    sendData = 10;
    MPI_Allreduce(&recvData, &sendData, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  }
  if (myRank == 2 || myRank == 3){
    sendData = 20;
    MPI_Allreduce(&recvData, &sendData, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  }
  MPI_Finalize();
  return 0;
}
