#include <shmem.h>

int main(int argc, char *argv[]) {
  int myRank;
  static int sendData = 13;
  static int recvData, data;
  shmem_init();
  myRank = shmem_my_pe();
  if (myRank == 0) {
    data = 42;
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  else {
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  shmem_sync_all();
  shmem_finalize();
  return 0;
}