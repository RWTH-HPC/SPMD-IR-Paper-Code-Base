#include <stdio.h>
#include <shmem.h>



int main(int argc, char** argv){
  int rank, size;

  shmem_init();
  rank = shmem_my_pe();
  size = shmem_n_pes();

  if(size<2){
    printf("This test needs at least 2 MPI processes\n");
    shmem_finalize();
    return 1;
  }

  shmem_team_t newTeam;
    shmem_team_split_strided(SHMEM_TEAM_WORLD, 0, 2, size / 2, NULL, 0, &newTeam);

  if(rank%2)
    shmem_team_sync(SHMEM_TEAM_WORLD);
  else
    shmem_team_sync(newTeam);


  shmem_finalize();
  return 0;
}