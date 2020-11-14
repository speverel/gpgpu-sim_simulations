//This code is a modification of L1 cache benchmark from 
//"Dissecting the NVIDIA Volta GPU Architecture via Microbenchmarking": https://arxiv.org/pdf/1804.06826.pdf

//This benchmark stresses the L1 cache

//This code have been tested on Volta V100 architecture

#include <stdio.h>   
#include <stdlib.h> 
#include <cuda.h>

#define THREADS_NUM 1024  
#define NUM_BLOCKS 160
#define WARP_SIZE 32

// GPU error check
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true){
        if (code != cudaSuccess) {
                fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
                if (abort) exit(code);
        }
}

__global__ void l1_pointers_init(uint64_t *posArray){

  uint32_t tid = blockIdx.x*blockDim.x + threadIdx.x;
  if(tid == 0){
    for(uint32_t blk = 0; blk <NUM_BLOCKS; blk++){
      for (uint32_t i=0; i<(THREADS_NUM-1); i++){
        posArray[(blk*THREADS_NUM)+i] = (uint64_t)(posArray + (blk*THREADS_NUM) + i + 1);
      }

      posArray[((blk+1)*THREADS_NUM)-1] = (uint64_t)(posArray + (blk*THREADS_NUM));
    }
  }
}

__global__ void l1_stress(uint64_t *posArray, uint64_t *dsink, uint64_t iterations){

  // thread index
  uint32_t tid = blockIdx.x*blockDim.x + threadIdx.x;

  if(tid < NUM_BLOCKS*THREADS_NUM){
  	// a register to avoid compiler optimization
  	uint64_t *ptr = posArray + tid;
  	uint64_t ptr1, ptr0;

  	// initialize the thread pointer with the start address of the array
  	// use ca modifier to cache the in L1
  	asm volatile ("{\t\n"
  	  "ld.global.ca.u64 %0, [%1];\n\t"
  	  "}" : "=l"(ptr1) : "l"(ptr) : "memory"
  	);

  	// synchronize all threads
  	asm volatile ("bar.sync 0;");

  	// pointer-chasing iterations times
  	// use ca modifier to cache the load in L1
  	#pragma unroll 100
  	for(uint64_t i=0; i<iterations; ++i) { 
  	  asm volatile ("{\t\n"
  	    "ld.global.ca.u64 %0, [%1];\n\t"
  	    "}" : "=l"(ptr0) : "l"((uint64_t*)ptr1) : "memory"
  	  );
  	  ptr1 = ptr0;    //swap the register for the next load

  	}

  	// write data back to memory
  	dsink[tid] = ptr1;
  }
}

int main(int argc, char** argv){
  uint64_t iterations;
  if (argc != 2){
    fprintf(stderr,"usage: %s #iterations #cores #ActiveThreadsperWarp\n",argv[0]);
    exit(1);
  }
  else {
    iterations = atoll(argv[1]);
  }
  int total_threads = THREADS_NUM*NUM_BLOCKS;
 printf("Power Microbenchmarks with iterations %lu\n",iterations);

  uint64_t *dsink = (uint64_t*) malloc(total_threads*sizeof(uint64_t));
  

  uint64_t *posArray_g;
  uint64_t *dsink_g;
  

  gpuErrchk( cudaMalloc(&posArray_g, total_threads*sizeof(uint64_t)) );
  gpuErrchk( cudaMalloc(&dsink_g, total_threads*sizeof(uint64_t)) );
  l1_pointers_init<<<1,1>>>(posArray_g);
  
  l1_stress<<<NUM_BLOCKS,THREADS_NUM>>>(posArray_g, dsink_g, iterations);
  gpuErrchk( cudaPeekAtLastError() );

  gpuErrchk( cudaMemcpy(dsink, dsink_g, total_threads*sizeof(uint64_t), cudaMemcpyDeviceToHost) );

  return 0;
} 