cmake_minimum_required(VERSION 3.18)  # 适用于 CUDA 支持的 CMake 版本
set(CMAKE_CUDA_ARCHITECTURES "90")
set(CMAKE_CUDA_COMPILER /usr/local/cuda-12.4/bin/nvcc)

project(DemoProject LANGUAGES CXX CUDA)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# 设置 CUDA 相关的选项
set(CMAKE_CUDA_STANDARD 14)  # 设置 CUDA 标准
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -rdc=true -gencode arch=compute_90,code=sm_90 -ccbin g++")

# 指定 CUDA 的编译器
set(CMAKE_CUDA_COMPILER /usr/local/cuda-12.4/bin/nvcc)

# 设置包含目录
include_directories(/usr/include/nvshmem_12/)

# 设置库目录
link_directories(/usr/lib64/nvshmem/12/)

include_directories(/usr/mpi/gcc/openmpi-4.1.5a1/include/)

link_directories(/usr/mpi/gcc/openmpi-4.1.5a1/lib64)

# 添加可执行目标
add_executable(demo.out demo1.cu)
set_target_properties(demo.out PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
add_executable(server server.cu)
set_target_properties(server PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)

# 链接库
target_link_libraries(demo.out nvshmem_host nvshmem_device mpi)
target_link_libraries(server nvshmem_host nvshmem_device mpi)

add_executable(client client.cu)
set_target_properties(client PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
target_link_libraries(client nvshmem_host nvshmem_device mpi)

add_executable(client1 client1.cu)
set_target_properties(client1 PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
target_link_libraries(client1 nvshmem_host nvshmem_device mpi)


add_executable(get_env get_env.cu)
set_target_properties(get_env PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
target_link_libraries(get_env nvshmem_host nvshmem_device mpi)


add_executable(server1 server1.cu)
set_target_properties(server1 PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
target_link_libraries(server1 nvshmem_host nvshmem_device mpi)