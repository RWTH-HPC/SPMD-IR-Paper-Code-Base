#include <stdio.h>
#include <shmem.h>


void f(){
  int r,s;
  s = shmem_n_pes();
  r = shmem_my_pe();

  int *A = shmem_malloc(sizeof(int)*s);;
  for(int i=0; i<s; i++)
    A[i] = i;

  if(A[r] > 10)
    shmem_sync_all();

  shmem_free(A);
}

int main(int argc, char **argv){

  shmem_init();

  f();

  shmem_finalize();
  return 0;
} 