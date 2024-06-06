#include <stdio.h>
#include <shmem.h>

int main(int argc, char **argv) {
  shmem_init();

  int a = 1;
  int *b = &a;

  if (a > 0)
    shmem_sync_all();

  *b = shmem_my_pe();

  if (a > 0)
    shmem_sync_all();

  shmem_finalize();
}