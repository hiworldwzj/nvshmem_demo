#include <stdio.h>
#include <cuda.h>
#include <nvshmem.h>
#include <nvshmemx.h>
#include <mpi.h>

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
    MPI_Comm_connect(argv[1], MPI_INFO_NULL, 0, MPI_COMM_SELF, &server_comm);
    int rank;
    // MPI_Comm_rank(server_comm, &rank);

    // printf("%d rank", rank);

    // // 接收服务器消息
    // int data;
    // MPI_Recv(&data, 1, MPI_INT, 0, 0, server_comm, MPI_STATUS_IGNORE);
    // printf("Received: %d\n", data);

    MPI_Comm new_server_comm;
    MPI_Intercomm_merge(server_comm, 1, &new_server_comm);

    MPI_Comm_rank(new_server_comm, &rank);

    printf("%d rank\n", rank);

    printf("wzj4");


    MPI_Finalize();
    return 0;
}