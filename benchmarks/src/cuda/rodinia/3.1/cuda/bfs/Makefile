include ../../common/make.config

CC := $(CUDA_DIR)/bin/nvcc

INCLUDE := $(CUDA_DIR)/include

SRC = bfs.cu

EXE = bfs

release: $(SRC)
	/home/vkz4947/cuda-9.1/bin/nvcc -ccbin g++ -I../../common/inc -m64 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o bfs.o -c bfs.cu
	g++ -fPIC  -m64 -o bfs  bfs.o  -L/home/vkz4947/cuda-9.1/lib64 -L../../common/lib/linux  -lcudart

enum: $(SRC)
	$(CC) -deviceemu $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

debug: $(SRC)
	$(CC) -g $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

debugenum: $(SRC)
	$(CC) -g -deviceemu $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

clean: $(SRC)
	rm -f $(EXE) $(EXE).linkinfo result.txt
