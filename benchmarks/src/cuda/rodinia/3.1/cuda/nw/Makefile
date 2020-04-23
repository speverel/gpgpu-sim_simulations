include ../../common/make.config

CC := $(CUDA_DIR)/bin/nvcc

INCLUDE := $(CUDA_DIR)/include

SRC = needle.cu

EXE = needle

release: $(SRC)
	#$(CC)  $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR)
	$(CC) -ccbin g++ ${KERNEL_DIM} -I/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/inc -m64 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o needle.o -c needle.cu
	g++ -fPIC -m64 -o needle  needle.o -L/home/vkz4947/cuda-9.1/lib64 -L/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/lib/linux  -lcudart


enum: $(SRC)
	$(CC) ${KERNEL_DIM} -deviceemu $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

debug: $(SRC)
	$(CC) ${KERNEL_DIM} -g $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

debugenum: $(SRC)
	$(CC) ${KERNEL_DIM} -g -deviceemu $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) 

clean: $(SRC)
	rm -f $(EXE) $(EXE).linkinfo result.txt
