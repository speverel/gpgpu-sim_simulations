#makefile

include ../../common/make.config

CC := $(CUDA_DIR)/bin/nvcc

INCLUDE := $(CUDA_DIR)/include

all: naive float

naive: ex_particle_CUDA_naive_seq.cu
	/home/vkz4947/cuda-9.1/bin/nvcc -I$(INCLUDE) -L$(CUDA_LIB_DIR) -ccbin g++ -I/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/inc -L/home/vkz4947/cuda-9.1/lib64 -use_fast_math -L/usr/lib64 -lstdc++ -g -lm -O3 -m64 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o particlefilter_naive.o -c ex_particle_CUDA_naive_seq.cu
	g++ -fPIC  -m64 -o particlefilter_naive   particlefilter_naive.o -L/home/vkz4947/cuda-9.1/lib64 -L/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/lib/linux  -lcudart

float: ex_particle_CUDA_float_seq.cu
	/home/vkz4947/cuda-9.1/bin/nvcc -I$(INCLUDE) -L$(CUDA_LIB_DIR) -ccbin g++ -I/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/inc -L/home/vkz4947/cuda-9.1/lib64  -use_fast_math -L/usr/lib64 -lstdc++ -g -lm -O3 -m64 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o particlefilter_float.o -c ex_particle_CUDA_float_seq.cu
	g++ -fPIC -m64 -o particlefilter_float   particlefilter_float.o -L/home/vkz4947/cuda-9.1/lib64 -L/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/lib/linux  -lcudart

clean:
	rm particlefilter_naive particlefilter_float
