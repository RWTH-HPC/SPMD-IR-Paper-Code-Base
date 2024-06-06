#include <shmem.h>

int main(int argc, char *argv[]) {
  int myRank;
  int localData = 8;
  static int data;
  shmem_init();
  myRank = shmem_my_pe();
  shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &localData, &data, 1);
  if (myRank == 0) {
    data = 42;
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
  }
  else {
    if (localData == 21) {
      shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
    }
  }
  shmem_sync_all();
  shmem_finalize();
  return 0;
}