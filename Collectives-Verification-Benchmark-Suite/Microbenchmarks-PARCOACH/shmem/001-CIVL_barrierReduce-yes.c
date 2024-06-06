#define ORDER 1

/* An example shows the misusage of shmem collective routines. */
#include <shmem.h>
#include <stdio.h>

int main(int argc, char* argv[]){
  int rank;
  int procs;
  static int localsum, sum;
  
  shmem_init();
  procs = shmem_team_n_pes(SHMEM_TEAM_WORLD);
  rank = shmem_team_my_pe(SHMEM_TEAM_WORLD);
  
  localsum = 0;
  for(int i=0; i<=rank; i++){
      localsum += i;
  }
  printf("process %d has local sum of %d\n", rank, localsum);
#ifdef ORDER
  if(rank%2){
    printf("process %d enters barrier\n", rank);
    shmem_team_sync(SHMEM_TEAM_WORLD);
    printf("process %d exits barrier\n", rank);
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &sum, &localsum, 1);
  }else{
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &sum, &localsum, 1);
    printf("process %d enters barrier\n", rank);
    shmem_team_sync(SHMEM_TEAM_WORLD);
    printf("process %d exits barrier\n", rank);
  }
#else
  printf("process %d enters barrier\n", rank);
  shmem_team_sync(SHMEM_TEAM_WORLD);
  printf("process %d exits barrier\n", rank);
  shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &sum, &localsum, 1);
#endif
  if(rank == 0)
      printf("total sum is %d\n", sum);
  shmem_finalize();
  return 0;
}