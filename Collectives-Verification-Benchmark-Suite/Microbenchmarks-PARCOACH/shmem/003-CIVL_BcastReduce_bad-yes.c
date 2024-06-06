/* A bad example shows how CIVL catches the misusage of shmem collective
   routines. In this example, even processes and odd processes calls
   different shmem collective routines. */
#include <shmem.h>
#include <assert.h>

int main(int argc, char * argv[]) {
  int nprocs, rank;
  static int num;
  static int recv;

  shmem_init();
  nprocs = shmem_n_pes();
  rank = shmem_my_pe();
  if(rank == 0) num = 3;
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &num, &num, 1, /*ROOT_PROCESS=*/0);
  
  if(rank%2 ==  0)
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recv, &num, 1);
  else
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &num, &num, 1, /*ROOT_PROCESS=*/0);
  if(rank == 0) num = recv;
  if(rank%2 == 0)
    shmem_int_broadcast(SHMEM_TEAM_WORLD, &num, &num, 1, /*ROOT_PROCESS=*/0);
  else
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recv, &num, 1);
  assert(num == 3 * nprocs);
  shmem_finalize();
  return 0;
}