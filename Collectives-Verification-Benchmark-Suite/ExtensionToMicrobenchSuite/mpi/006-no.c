#include <mpi.h>

int main(int argc, char *argv[]) {
  int localData = 8;
  int data = 42;
  int sendData = 13;
  int recvData;
  MPI_Init(&argc, &argv);
  MPI_Allreduce(&data, &localData, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  if (localData == 21) {
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    MPI_Reduce(&sendData, &recvData, 1, MPI_INT, MPI_SUM, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();
  return 0;
}
