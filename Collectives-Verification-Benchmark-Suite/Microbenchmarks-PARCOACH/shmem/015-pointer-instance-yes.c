#include <stdio.h>
#include <shmem.h>

void g(int s){
	if(s)
		shmem_sync_all();
}


int main(int argc, char **argv) {
  int r,s=1;

  shmem_init();
  r = shmem_my_pe();
 
  shmem_sync_all();

  g(s);
  s=r%2;

  if (s)
    shmem_sync_all();

  shmem_finalize();
  return 0;
}