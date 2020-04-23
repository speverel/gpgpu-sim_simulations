include ../../common/make.config

# C compiler
CC = gcc
CC_FLAGS = -g -fopenmp -O2 

# CUDA compiler
NVCC = /home/vkz4947/cuda-9.1/bin/nvcc
NVCC_FLAGS = -I/home/vkz4947/cuda-9.1/include 

# 'make dbg=1' enables NVCC debugging
ifeq ($(dbg),1)
	NVCC_FLAGS += -g -O0
else
	NVCC_FLAGS += -O2
endif

# 'make emu=1' compiles the CUDA kernels for emulation
ifeq ($(emu),1)
	NVCC_FLAGS += -deviceemu
endif


kmeans: cluster.o getopt.o kmeans.o kmeans_clustering.o kmeans_cuda.o rmse.o
	$(CC) $(CC_FLAGS) cluster.o getopt.o kmeans_clustering.o kmeans_cuda.o rmse.o kmeans.o -o kmeans -L/usr/lib64 -lstdc++ -L$(CUDA_LIB_DIR) -lcudart -lm

%.o: %.[ch]
	$(CC) $(CC_FLAGS) $< -c

kmeans.o: kmeans.c
	$(CC) $(CC_FLAGS) -c kmeans.c

kmeans_cuda.o: kmeans_cuda.cu 
	$(NVCC) -gencode=arch=compute_70,code=\"sm_70,compute_70\"  $(NVCC_FLAGS) -c kmeans_cuda.cu

clean:
	rm -f *.o *~ kmeans kmeans_cuda.linkinfo
