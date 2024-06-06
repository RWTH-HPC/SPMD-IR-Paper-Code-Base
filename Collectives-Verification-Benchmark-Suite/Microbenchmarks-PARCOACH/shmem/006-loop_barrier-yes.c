#include <stdio.h>
#include <shmem.h>



int main(int argc, char** argv){
  int rank, size, i=1, j=10;

  shmem_init();
	rank = shmem_my_pe();
 	size = shmem_n_pes();

  if(size<2){
    printf("This test needs at least 2 SHMEM processes\n");
    shmem_finalize();
    return 1;
  }

  if(rank%2){
    while(i<10){
      shmem_sync_all();
      i++;
    }
  }else{
    while(j<20){
      shmem_sync_all();
      j++;
    }
  }


  shmem_finalize();
  return 0;
}