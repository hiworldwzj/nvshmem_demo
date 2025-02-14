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

cmake ..
make