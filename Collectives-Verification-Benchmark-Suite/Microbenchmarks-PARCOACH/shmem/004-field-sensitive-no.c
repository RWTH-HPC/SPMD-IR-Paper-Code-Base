#include <stdio.h>
#include <shmem.h>

typedef struct _hydroparam {
 int mype;
 int nproc;
}hydroparam_t;


void f(hydroparam_t *H){
  int rank, procs;
  
  rank = shmem_my_pe();
  procs = shmem_n_pes();
  H->mype = rank;
  H->nproc = procs;

 if(H->nproc > 1)
	shmem_sync_all();

}

int main(int argc, char **argv){

  shmem_init();

	hydroparam_t *H;
	f(H);		

  shmem_finalize();
	return 0;
}