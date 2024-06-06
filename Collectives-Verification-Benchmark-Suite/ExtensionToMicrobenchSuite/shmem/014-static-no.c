#include <shmem.h>
// This program shall be executed by 4 ranks, then no collective error is given

int main(int argc, char *argv[]) {
  int myRank,size;
  static int sendData;
  static int recvData;

  shmem_init();
	myRank = shmem_my_pe();
 	size = shmem_n_pes();

  if(size!=4){
    shmem_finalize();
    return 1;
  }

  if (myRank == 0 || myRank == 1) {
    sendData = 10;
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  if (myRank == 2 || myRank == 3){
    sendData = 20;
    shmem_int_sum_reduce(SHMEM_TEAM_WORLD, &recvData, &sendData, 1);
  }
  shmem_finalize();
  return 0;
}
