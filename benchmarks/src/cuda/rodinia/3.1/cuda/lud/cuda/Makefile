CC = gcc
NVCC = nvcc

DEFS += \
		-DGPU_TIMER \
		$(SPACE)

NVCCFLAGS += -I../common \
			 -O3 \
			 -use_fast_math \
			 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70  \
			 -lm \
			 $(SPACE)

CFLAGS += -I../common \
					-I/home/vkz4947/cuda9/cuda-9.1 \
		  -O3 \
		  -Wall \
		  $(SPACE)

# Add source files here
EXECUTABLE  := lud_cuda
# Cuda source files (compiled with cudacc)
CUFILES     := lud_kernel.cu
# C/C++ source files (compiled with gcc / c++)
CCFILES     := lud.c lud_cuda.c ../common/common.c

OBJS = ../common/common.o lud.o lud_kernel.o

.PHONY: all clean 
all : $(EXECUTABLE)

.c.o : 
	$(NVCC) $(KERNEL_DIM) $(NVCCFLAGS) $(DEFS) -o $@ -c $<

%.o:	%.cu 
	$(NVCC) $(KERNEL_DIM) $(NVCCFLAGS) $(DEFS) -o $@ -c $<


$(EXECUTABLE) : $(OBJS)
	$(CC) $(CFLAGS) -fPIC -use_fast_math -lm -L/home/vkz4947/cuda-9.1/lib64 -L/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/lib/linux  -lcudart -o $@  $?

clean:
	rm -f $(EXECUTABLE) $(OBJS) *.linkinfo
