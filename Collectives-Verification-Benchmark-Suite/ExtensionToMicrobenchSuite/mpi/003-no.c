#include <mpi.h>

int main(int argc, char *argv[]) {
  int myRank;
  int sendData = 13;
  int recvData, data;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
  if (myRank == 0) {
    data = 42;
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();
  return 0;
}
