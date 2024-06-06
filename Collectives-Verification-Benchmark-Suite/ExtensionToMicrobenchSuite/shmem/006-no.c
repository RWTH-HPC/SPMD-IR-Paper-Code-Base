#include <shmem.h>

int main(int argc, char *argv[]) {
  int localData = 8;
  static int data = 42;
  static int sendData = 13;
  static int recvData;
  shmem_init();
  shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &localData, &data, 1);
  if (localData == 21) {
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
  }
  else {
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  shmem_sync_all();
  shmem_finalize();
  return 0;
}