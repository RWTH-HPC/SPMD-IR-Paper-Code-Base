#include <mpi.h>

int main(int argc, char** argv){
  int rank, data;
  MPI_Request req;
  MPI_Status status;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);

  if (rank==0){
    data = 42;
  }

  if (rank%2){
    MPI_Bcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD);
  }
  else {
    MPI_Ibcast(&data, 1, MPI_INT, /*ROOT_PROCESS=*/0, MPI_COMM_WORLD, &req);
    MPI_Wait(&req, &status);
  }

  MPI_Request_free(&req);
  MPI_Finalize();
  return 0;
}
