// added additionally to the original test case from parcoach the printf below funcCall of f
// this necessate proper handling and transformation of the struct (memrefs) to values.
#include <stdio.h>
#include <mpi.h>

typedef struct _hydroparam {
  int mype;
  int nproc;
}hydroparam_t;


void f(hydroparam_t *H){
  MPI_Comm_rank(MPI_COMM_WORLD,&H->mype);
  MPI_Comm_size(MPI_COMM_WORLD,&H->nproc);
  if(H->nproc > 1)
    MPI_Barrier(MPI_COMM_WORLD);
}

int main(int argc, char **argv){
  MPI_Init(&argc,&argv);
  hydroparam_t *H;
  f(H);		
  printf("process %d of %d processes\n", H->mype, H->nproc);
  MPI_Finalize();
  return 0;
}