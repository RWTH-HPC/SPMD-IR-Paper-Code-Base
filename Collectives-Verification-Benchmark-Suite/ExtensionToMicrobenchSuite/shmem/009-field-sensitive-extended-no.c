// added additionally to the original test case from parcoach the printf below funcCall of f
// this necessate proper handling and transformation of the struct (memrefs) to values.
#include <stdio.h>
#include <shmem.h>

typedef struct _hydroparam {
  int mype;
  int nproc;
}hydroparam_t;


void f(hydroparam_t *H){
  H->mype  = shmem_my_pe();
  H->nproc = shmem_n_pes();
  if(H->nproc > 1)
	  shmem_sync_all();
}

int main(int argc, char **argv){
  shmem_init();
	hydroparam_t *H;
	f(H);		
	printf("process %d of %d processes\n", H->mype, H->nproc);
  shmem_finalize();
	return 0;
}