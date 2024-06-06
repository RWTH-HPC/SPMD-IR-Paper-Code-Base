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

  if(rank%2)
    shmem_sync_all();

  shmem_finalize();
  return 0;
}