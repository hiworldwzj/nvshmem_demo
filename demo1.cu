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
    extern char **environ; // 声明外部变量 environ

    int rank, ndevices;
    
    nvshmemx_init_attr_t attr;
    MPI_Comm comm = MPI_COMM_WORLD;
    attr.mpi_comm = &comm;

    // 遍历并打印所有环境变量
    for (char **env = environ; *env != 0; env++) {
        printf("%s\n", *env);
    };
    printf("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n");
    
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // 遍历并打印所有环境变量
    for (char **env = environ; *env != 0; env++) {
        printf("%s\n", *env);
    };

    char port_name[MPI_MAX_PORT_NAME];
    MPI_Open_port(MPI_INFO_NULL, port_name);
    printf("Port: %s\n", port_name);  // 例如输出 "192.168.1.100:5000"


     
    int msg;
    cudaStream_t stream;

    cudaGetDeviceCount(&ndevices);
    cudaSetDevice(rank % ndevices);
    nvshmemx_init_attr(NVSHMEMX_INIT_WITH_MPI_COMM, &attr);
    cudaStreamCreate(&stream);

    int *destination = (int *) nvshmem_malloc(sizeof(int));

    simple_shift<<<1, 1, 0, stream>>>(destination);
    nvshmemx_barrier_all_on_stream(stream);
    cudaMemcpyAsync(&msg, destination, sizeof(int), cudaMemcpyDeviceToHost, stream);

    cudaStreamSynchronize(stream);
    printf("%d: received message %d\n", nvshmem_my_pe(), msg);

    nvshmem_free(destination);
    nvshmem_finalize();
    while(true) {

    };
    MPI_Finalize();
    return 0;
}