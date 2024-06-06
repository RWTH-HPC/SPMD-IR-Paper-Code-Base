#include <stdio.h>
#include <shmem.h>

// No deadlock

int main(int argc, char **argv){

  shmem_init();
  int size;
  size = shmem_n_pes();

  if(size<256)
    shmem_sync_all();

  shmem_finalize();
  return 0;
}