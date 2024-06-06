// 1/4 of ranks wait in Barrier in Line 15, remaining 3/4 wait in Reduce in Line 19 => deadlock
#include <mpi.h>

int main(int argc, char *argv[]) {
  int myRank;
  int sendData = 13;
  int recvData;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);

  MPI_Comm splitComm;
  MPI_Comm_split(MPI_COMM_WORLD, myRank%2, myRank, &splitComm);

  if (myRank%4) {
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, splitComm);
  }
  else {
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, splitComm);
    MPI_Barrier(MPI_COMM_WORLD);
  }

  MPI_Comm_free(&splitComm);
  MPI_Finalize();
  return 0;
}
