#include <mpi.h>
#include <shmem.h>

int main(int argc, char *argv[]) {
  static int myRank;
  int data = 42;
  static int recvData;
  static int sendData = 13;

  MPI_Init(&argc, &argv);
  shmem_init();
  
  MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
  int myPE = shmem_my_pe();
  int size = shmem_team_n_pes(SHMEM_TEAM_WORLD);

  int *mpiRanks = (int*)shmem_malloc(sizeof(int)*size);
  shmem_int_fcollect(SHMEM_TEAM_WORLD, mpiRanks, &myRank, 1);

  if (myPE == 0 || mpiRanks[myPE] == 0) {
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  MPI_Barrier(MPI_COMM_WORLD);
  shmem_sync_all();

  shmem_finalize();
  MPI_Finalize();
  return 0;
}