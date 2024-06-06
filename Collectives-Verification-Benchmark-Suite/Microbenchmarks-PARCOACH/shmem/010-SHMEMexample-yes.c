#include <stdio.h>
#include <shmem.h>




void g(int s){
  static int res, i;
  res=0; i=12;

  if(s>256)
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &res, &i, 1);
}

void f(){
  int s,r,n;

  r = shmem_my_pe();
  s = shmem_n_pes();

  if(r%2)
    n=1;
  else
    n=2;

  if(n==1)
    g(s);

  shmem_sync_all();
}


int main(int argc, char** argv){
	
  shmem_init();
  f();
  shmem_finalize();

  return 0;
}