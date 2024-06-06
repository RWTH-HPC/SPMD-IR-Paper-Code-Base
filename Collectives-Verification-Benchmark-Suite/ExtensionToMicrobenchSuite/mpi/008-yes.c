#include <mpi.h>

int main(int argc, char *argv[]) {
  int myRank;
  int localData = 8;
  int data;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
  MPI_Allreduce(&data, &localData, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  if (myRank == 0) {
    data = 42;
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    if (localData == 21) {
      MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    }
  }
  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();
  return 0;
}
