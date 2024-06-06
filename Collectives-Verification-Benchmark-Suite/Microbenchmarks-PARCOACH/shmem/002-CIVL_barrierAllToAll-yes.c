/**
 * This program has an error because not all processes 
 * execute shmem_team_sync and shmem_int_alltoall in the same order.
 */

#include <shmem.h>
#include <stdio.h>


int main(int argc, char* argv[]){
  int rank;
  int procs;
  int* sendbuf, *rcvbuf;
  
  shmem_init();
  procs = shmem_n_pes();
  rank = shmem_my_pe();
  
  sendbuf = shmem_malloc(sizeof(int)*procs);
  rcvbuf = shmem_malloc(sizeof(int)*procs);
  if(rank == 0)
  {
    for(int i=0; i<procs; i++){
        sendbuf[i] = procs - i;
    }
    shmem_int_alltoall(SHMEM_TEAM_WORLD, rcvbuf, sendbuf, 1);
    shmem_sync_all();
  }else{
    shmem_sync_all();
    shmem_int_alltoall(SHMEM_TEAM_WORLD, rcvbuf, sendbuf, 1);
    printf("process %d receives %d\n", rank, *rcvbuf);
  }
  shmem_free(sendbuf);
  shmem_free(rcvbuf);
  shmem_finalize();
  return 0;
}