// even ranks go first in Reduce in Line 16 and since they constitute the whole splitComm they can finish the op and go to barrier
// odd ranks wait in Barrier in Line 20 and can move to Reduce Line 21 as soon as even ranks finishes their ReduceOp.
#include <mpi.h>

int main(int argc, char *argv[]) {
  int myRank;
  int sendData = 13;
  int recvData;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);

  MPI_Comm splitComm;
  MPI_Comm_split(MPI_COMM_WORLD, myRank%2, myRank, &splitComm);

  if (myRank%2) {
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, splitComm);
    MPI_Barrier(MPI_COMM_WORLD);
  }
  else {
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, splitComm);
  }

  MPI_Comm_free(&splitComm);
  MPI_Finalize();
  return 0;
}
