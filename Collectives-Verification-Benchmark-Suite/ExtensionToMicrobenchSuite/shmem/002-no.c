#include <shmem.h>

int main(int argc, char *argv[]) {
  int myRank;
  static int data;
  shmem_init();
  myRank = shmem_team_my_pe(SHMEM_TEAM_WORLD);
  if (myRank == 0) {
    data = 42;
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
  }
  else {
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &data, &data, 1, /*ROOT_PROCESS=*/0);
  }
  shmem_sync_all();
  shmem_finalize();
  return 0;
}