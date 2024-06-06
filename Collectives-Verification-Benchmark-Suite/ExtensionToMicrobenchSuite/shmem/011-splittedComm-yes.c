// 1/4 of ranks wait in Barrier in Line 15, half of remaining 3/4 wait in Reduce in Line 19 => deadlock
#include <shmem.h>

int main(int argc, char *argv[]) {
  int myRank, size;
  static int sendData = 13;
  static int recvData;
  shmem_init();
  myRank = shmem_my_pe();
  size = shmem_n_pes();

  shmem_team_t splitTeam;
  shmem_team_split_strided(SHMEM_TEAM_WORLD, myRank%2, 2, size / 2, NULL, 0, &splitTeam);

  if (myRank%4) {
    shmem_team_sync(SHMEM_TEAM_WORLD);
    shmem_int_sum_reduce(splitTeam, &recvData, &sendData, 1);
  }
  else {
    shmem_int_sum_reduce(splitTeam, &recvData, &sendData, 1);
    shmem_team_sync(SHMEM_TEAM_WORLD);
  }

  shmem_team_destroy(splitTeam);
  shmem_finalize();
  return 0;
}