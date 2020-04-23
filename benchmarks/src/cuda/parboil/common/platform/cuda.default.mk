# (c) 2007 The Board of Trustees of the University of Illinois.

# Cuda-related definitions common to all benchmarks

########################################
# Variables
########################################

# c.default is the base along with CUDA configuration in this setting
include $(PARBOIL_ROOT)/common/platform/c.default.mk

# Paths
CUDAHOME=/home/vkz4947/cuda-9.1

# Programs
CUDACC=$(CUDAHOME)/bin/nvcc
CUDALINK=gcc

# Flags
PLATFORM_CUDACFLAGS=-gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70  -O3
PLATFORM_CUDALDFLAGS=-lm -lpthread  -fPIC -m64 -L/home/vkz4947/cuda-9.1/lib64 -L/home/vkz4947/NVIDIA_CUDA-9.1_Samples/common/lib/linux  -lcudart



