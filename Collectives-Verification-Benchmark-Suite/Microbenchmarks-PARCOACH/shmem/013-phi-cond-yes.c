#include <stdio.h>
#include <shmem.h>


int main(int argc, char **argv){

  shmem_init();
  int r,size,v=0;
  r = shmem_my_pe();
  size = shmem_n_pes();

  if(size<2){
    printf("This test needs at least 2 shmem processes\n");
    shmem_finalize();
    return 1;
  }


	if(!r)
		v=1;
	else
		v=2;

	if(v == 2)
		shmem_sync_all();

	shmem_finalize();
	return 0;
}