include ../../common/make.config

CC = g++
CC_FLAGS = -g -fopenmp -O2 

NVCC = /home/vkz4947/cuda-10.1/bin/nvcc
NVCC_FLAGS = -I/home/vkz4947/cuda-10.1/include 




pathfinder: pathfinder.o
	g++ -fPIC -m64 -o pathfinder pathfinder.o  -L/home/vkz4947/cuda-10.1/lib64   -lcudart
pathfinder.o: pathfinder.cu 
	$(NVCC) -gencode=arch=compute_70,code=\"sm_70,compute_70\"  $(NVCC_FLAGS) -c pathfinder.cu
 


clean:
	rm -f pathfinder pathfinder.o