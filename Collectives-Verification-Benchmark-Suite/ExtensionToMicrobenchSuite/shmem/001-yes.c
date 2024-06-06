#include <shmem.h>

int main(int argc, char *argv[]) {
  int myRank, npes;
  shmem_init();
  npes = shmem_n_pes();
  int *data = shmem_malloc(1 * npes * sizeof(int));
  myRank = shmem_team_my_pe(SHMEM_TEAM_WORLD);
  if (myRank == 0) {
    *data = 42;
    shmem_int_broadcast(SHMEM_TEAM_WORLD, data, data, 2, /*ROOT_PROCESS=*/0);
  }
  shmem_team_sync(SHMEM_TEAM_WORLD);
  shmem_free(data);
  shmem_finalize();
  return 0;
}