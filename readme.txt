/usr/include/nvshmem_12

# 这条编译无法执行成功
/usr/local/cuda-12.4/bin/nvcc -rdc=true -gencode arch=compute_90,code=sm_90 -ccbin g++ -I /usr/include/nvshmem_12 demo.cu -o demo.out -L /usr/lib64/nvshmem/12/ -lnvshmem -lnvidia-ml -lcuda -lcudart

# 下面这个可以成功执行
/usr/local/cuda-12.4/bin/nvcc -rdc=true  -gencode arch=compute_90,code=sm_90 -ccbin g++ -I /usr/include/nvshmem_12/ demo.cu -o demo.out -L /usr/lib64/nvshmem/12/ -lnvshmem_host -lnvshmem_device

/usr/bin/nvshmem_12/nvshmrun.hydra

/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun


/usr/local/cuda-12.4/bin/nvcc -rdc=true  -gencode arch=compute_90,code=sm_90 -ccbin g++ -I /usr/include/nvshmem_12/ -I /usr/mpi/gcc/openmpi-4.1.5a1/include/ demo1.cu -o demo1.out -L /usr/lib64/nvshmem/12/ -lnvshmem_host -lnvshmem_device \
-L /usr/mpi/gcc/openmpi-4.1.5a1/lib64 -lmpi

/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun -n 2 demo.out

# build
mkdir build
cd build
cmake ..
make

# 启动 pmix server
/usr/mpi/gcc/openmpi-4.1.5a1/bin/ompi-server --no-daemonize -r +

# export PMIX_SERVER_URI="tcp://<server_ip>:<port>"
# export PMIX_SERVER_URI="tcp://10.121.4.14,172.17.0.1:44261"
# 用环境变量暴露 pmix server
export OMPI_MCA_pmix_server_uri="3612409856.0;tcp://10.121.4.14,172.17.0.1:44261"

# 在 server 和 client 的运行环境中，先设置 export OMPI_MCA_pmix_server_uri 环境变量，然后进行运行。
/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun -np 1 --ompi-server "3612409856.0;tcp://10.121.4.14,172.17.0.1:44261" ./server
/usr/mpi/gcc/openmpi-4.1.5a1/bin/mpirun -np 1 --ompi-server "3612409856.0;tcp://10.121.4.14,172.17.0.1:44261" ./client "767492097.0:811985642"