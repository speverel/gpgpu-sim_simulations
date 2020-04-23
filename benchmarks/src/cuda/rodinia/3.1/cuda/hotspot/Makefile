include ../../common/make.config

CC = g++
CC_FLAGS = -g -fopenmp -O2 

NVCC = /home/vkz4947/cuda-9.1/bin/nvcc
NVCC_FLAGS = -I/home/vkz4947/cuda-9.1/include 

INCLUDE := $(CUDA_DIR)/include

SRC = hotspot.cu

EXE = hotspot
hotspot: hotspot.o
	g++ -fPIC  -m64 -o hotspot hotspot.o  -L/home/vkz4947/cuda-9.1/lib64   -lcudart
hotspot.o: hotspot.cu 
	$(NVCC) -gencode=arch=compute_70,code=\"sm_70,compute_70\"  $(NVCC_FLAGS) -c hotspot.cu
 





clean: $(SRC)
	rm -f $(EXE) $(EXE).o $(EXE).linkinfo result.txt
