include ../../common/make.config

LOCAL_CC = gcc -g -O3 -Wall
CC := $(CUDA_DIR)/bin/nvcc

all : nn hurricane_gen

clean :
	rm -rf *.o nn hurricane_gen

nn : nn_cuda.cu
	/home/vkz4947/cuda-9.1/bin/nvcc -ccbin g++ -I/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/inc -m64 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o nn_cuda.o -c nn_cuda.cu
	g++ -fPIC -m64 -o nn   nn_cuda.o -L/home/vkz4947/cuda-9.1/lib64 -L/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/lib/linux  -lcudart


hurricane_gen : hurricane_gen.c
	$(LOCAL_CC) -o $@ $< -lm

#data :
#	mkdir data
#	./gen_dataset.sh
