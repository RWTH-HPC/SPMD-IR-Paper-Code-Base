#include <mpi.h>
#include <shmem.h>

int main(int argc, char *argv[]) {
  int myRank, myPE;
  int data = 42;
  static int recvData;
  static int sendData = 13;

  MPI_Init(&argc, &argv);
  shmem_init();

  myPE = shmem_my_pe();
  MPI_Comm shmem_comm;
  MPI_Comm_split(MPI_COMM_WORLD, 0, myPE, &shmem_comm);
  MPI_Comm_rank(shmem_comm, &myRank);

  if (myRank == 0) {
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, shmem_comm);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  else {
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, shmem_comm);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }

  MPI_Barrier(shmem_comm);
  shmem_sync_all();

  shmem_finalize();
  MPI_Finalize();
  return 0;
}