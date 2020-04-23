include ../../common/make.config
CC := $(CUDA_DIR)/bin/nvcc

CC_FLAGS = -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -I/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/inc

ifdef VERIFY
override VERIFY = -DVERIFY
endif

ifdef OUTPUT
override OUTPUT = -DOUTPUT
endif

ifdef TIMER
override TIMER = -DTIMER
endif

hybridsort.o: main.cu  bucketsort.cu bucketsort.cuh bucketsort_kernel.cu histogram1024_kernel.cu  mergesort.cu mergesort.cuh mergesort_kernel.cu
	$(CC) $(CC_FLAGS) $(VERIFY) $(OUTPUT) $(TIMER) $(HISTO_WG_SIZE_0) $(BUCKET_WG_SIZE_0) $(BUCKET_WG_SIZE_1) $(MERGE_WG_SIZE_0) $(MERGE_WG_SIZE_1) bucketsort.cu mergesort.cu main.cu -o hybridsort.o
 
hybridsort: hybridsort.o
	g++ -fPIC -m64 -o hybridsort   hybridsort.o  -L/home/vkz4947/cuda-9.1/lib64 -L../../common/lib/linux  -lcudart


clean:
	rm	*.o hybridsort
