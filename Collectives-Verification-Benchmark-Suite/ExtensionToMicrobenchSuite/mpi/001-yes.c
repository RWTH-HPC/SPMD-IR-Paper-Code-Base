#include <mpi.h>

int main(int argc, char *argv[]) {
  int myRank;
  int *data;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
  MPI_Alloc_mem(sizeof(int), MPI_INFO_NULL, data);
  if (myRank == 0) {
    *data = 42;
    MPI_Bcast(data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Free_mem(data);
  MPI_Finalize();
  return 0;
}
