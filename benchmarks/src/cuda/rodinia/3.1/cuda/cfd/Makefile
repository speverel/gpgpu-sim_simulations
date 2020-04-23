include ../../common/make.config

CUDA_SDK_PATH := $(SDK_DIR)

# Determine the correct version of the cutil library
CUTIL_LIB = # -lcutil
ifeq ($(shell uname -m), x86_64)
     ifeq ($(shell if test -e $(SDK_DIR)/lib/libcutil_x86_64.a; then echo T; else echo F; fi), T)
        CUTIL_LIB = #-lcutil_x86_64
     endif
endif


all: euler3d euler3d_double  pre_euler3d  pre_euler3d_double 

euler3d.o: euler3d.cu
	nvcc $(KERNEL_DIM) -O2 -Xptxas -v -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 euler3d.cu -o euler3d.o -I$(CUDA_SDK_PATH)/common/inc  -L$(CUDA_SDK_PATH)/lib $(CUTIL_LIB)

euler3d_double.o: euler3d_double.cu
	nvcc -Xptxas -v -O3 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 euler3d_double.cu -o euler3d_double.o -I$(CUDA_SDK_PATH)/common/inc  -L$(CUDA_SDK_PATH)/lib $(CUTIL_LIB)


pre_euler3d.o: pre_euler3d.cu
	nvcc -Xptxas -v -O3 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 pre_euler3d.cu -o pre_euler3d.o -I$(CUDA_SDK_PATH)/common/inc  -L$(CUDA_SDK_PATH)/lib $(CUTIL_LIB)

pre_euler3d_double.o: pre_euler3d_double.cu
	nvcc -Xptxas -v -O3 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 pre_euler3d_double.cu -o pre_euler3d_double.o -I$(CUDA_SDK_PATH)/common/inc  -L$(CUDA_SDK_PATH)/lib $(CUTIL_LIB)

pre_euler3d: pre_euler3d.o
	g++ -fPIC -m64 -o pre_euler3d pre_euler3d.o  -L/home/vkz4947/cuda-9.1/lib64  -lcudart

pre_euler3d_double: pre_euler3d_double.o
	g++ -fPIC  -m64 -o pre_euler3d_double pre_euler3d_double.o  -L/home/vkz4947/cuda-9.1/lib64  -lcudart

euler3d_double: euler3d_double.o
	g++ -fPIC  -m64 -o euler3d_double euler3d_double.o  -L/home/vkz4947/cuda-9.1/lib64 -lcudart

euler3d: euler3d.o
	g++ -fPIC  -m64 -o euler3d euler3d.o  -L/home/vkz4947/cuda-9.1/lib64  -lcudart


clean:
	rm -f euler3d euler3d_double pre_euler3d pre_euler3d_double *.linkinfo
