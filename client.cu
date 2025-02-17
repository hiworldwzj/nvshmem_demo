#include <stdio.h>
#include <cuda.h>
#include <nvshmem.h>
#include <nvshmemx.h>
#include <mpi.h>
#include <stdlib.h>
#include <string.h>

__global__ void simple_shift(int *destination) {
    int mype = nvshmem_my_pe();
    int npes = nvshmem_n_pes();
    int peer = (mype + 1) % npes;

    nvshmem_int_p(destination, mype, peer);
}

int main(int argc, char *argv[]) {

    char port_name[MPI_MAX_PORT_NAME];
    FILE* fp = fopen("port_info.txt", "r");
    fgets(port_name, MPI_MAX_PORT_NAME, fp);
    fclose(fp);

    MPI_Init(NULL, NULL);
    MPI_Comm server_comm;
    MPI_Comm_connect(port_name, MPI_INFO_NULL, 0, MPI_COMM_SELF, &server_comm);
    int rank;

    MPI_Comm new_server_comm;
    MPI_Intercomm_merge(server_comm, 1, &new_server_comm);

    MPI_Comm_rank(new_server_comm, &rank);

    printf("%d rank\n", rank);

    double local_value, global_sum;
    local_value = 130.0;
    MPI_Allreduce(&local_value, &global_sum, 1, MPI_DOUBLE, MPI_SUM, new_server_comm);

    printf("%f", global_sum);
    printf("wzj4");


    MPI_Finalize();
    return 0;
}