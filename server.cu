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
    MPI_Init(NULL, NULL);
    char port_name[MPI_MAX_PORT_NAME];
    MPI_Open_port(MPI_INFO_NULL, port_name);
    printf("Port: %s\n", port_name);  // 例如输出 "192.168.1.100:5000"

    // 将端口信息写入文件供Clients读取
    FILE* fp = fopen("port_info.txt", "w");
    fprintf(fp, "%s", port_name);
    fclose(fp);

           
    MPI_Comm client_comm;
    MPI_Comm new_client_comm;
    for (int i = 0; i < 2; i++) {
        MPI_Comm_accept(port_name, MPI_INFO_NULL, 0, MPI_COMM_SELF, &client_comm);
        printf("Accepted connection from client %d\n", i);
        // 这里可以进行数据交换或其他操作

        printf("wzj1\n");
        MPI_Intercomm_merge(client_comm, 0, &new_client_comm);
        printf("wzj2\n");
        int rank;
        MPI_Comm_rank(new_client_comm, &rank);
        printf("wzj3\n");
        printf("%d rank", rank);
    }



    double local_value, global_sum;
    local_value = 100.0;
    MPI_Allreduce(&local_value, &global_sum, 1, MPI_DOUBLE, MPI_SUM, new_client_comm);

    printf("%f", global_sum);

    MPI_Close_port(port_name);
    MPI_Finalize();
    return 0;
}