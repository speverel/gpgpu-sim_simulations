#include <stdio.h>
#include <stdlib.h>
//#include <cutil.h>
// Includes
#include <stdio.h>
#include<cuda.h>
// includes, project
//#include "../include/sdkHelper.h"  // helper for shared functions common to CUDA SDK samples
//#include <shrQATest.h>
//#include <shrUtils.h>

// includes CUDA
#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 1024

// Variables
uint32_t* h_A;
uint32_t* h_B;
uint32_t* h_C;
uint32_t* d_A;
uint32_t* d_B;
uint32_t* d_C;
bool noprompt = false;
unsigned int my_timer;

// Functions
void CleanupResources(void);
void RandomInit(uint32_t*, int);
void ParseArguments(int, char**);

////////////////////////////////////////////////////////////////////////////////
// These are CUDA Helper functions

// This will output the proper CUDA error strings in the event that a CUDA host call returns an error
#define checkCudaErrors(err)  __checkCudaErrors (err, __FILE__, __LINE__)

inline void __checkCudaErrors(cudaError err, const char *file, const int line )
{
  if(cudaSuccess != err){
	fprintf(stderr, "%s(%i) : CUDA Runtime API error %d: %s.\n",file, line, (int)err, cudaGetErrorString( err ) );
	 exit(-1);
  }
}

// This will output the proper error string when calling cudaGetLastError
#define getLastCudaError(msg)      __getLastCudaError (msg, __FILE__, __LINE__)

inline void __getLastCudaError(const char *errorMessage, const char *file, const int line )
{
  cudaError_t err = cudaGetLastError();
  if (cudaSuccess != err){
	fprintf(stderr, "%s(%i) : getLastCudaError() CUDA error : %s : (%d) %s.\n",file, line, errorMessage, (int)err, cudaGetErrorString( err ) );
	exit(-1);
  }
}

// end of CUDA Helper Functions
__global__ void PowerKernal2(const uint32_t* A, const uint32_t* B, uint32_t* C, int N, uint64_t iterations, int div)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    //Do Some Computation
    uint32_t Value1=1;
    uint32_t Value2=A[i];
    uint32_t Value3=B[i];
    uint32_t Value;
    uint32_t I1=A[i];
    uint32_t I2=B[i];
    
    // Excessive Addition access
//    if(((i%32)<=31))
if((i%2)==0){    
    #pragma unroll 1000
    for(uint64_t k=0; k<iterations;k++) {
	Value1=I1*A[i];
	Value3=I2*B[i];
	Value1*=Value2;
	Value1*=Value2;
	Value2=Value3*Value1;
	Value1=Value2*Value3;
    }
}
    __syncthreads();

    Value=Value1;
    C[i]=Value*Value2;

}

int main(int argc, char** argv)
{
  uint64_t iterations;
  unsigned blocks;
  int div;
  if (argc != 4){
	  fprintf(stderr,"usage: %s #iterations #cores\n",argv[0]);
	  exit(1);
  }
  else {
    iterations = atoll(argv[1]);
    blocks = atoi(argv[2]);
    div = atoi(argv[3]);
  }

 printf("Power Microbenchmarks with %llu iterations \n", iterations);
 int N = THREADS_PER_BLOCK*blocks;
 size_t size = N * sizeof(uint32_t);
 // Allocate input vectors h_A and h_B in host memory
 h_A = (uint32_t*)malloc(size);
 if (h_A == 0) CleanupResources();
 h_B = (uint32_t*)malloc(size);
 if (h_B == 0) CleanupResources();
 h_C = (uint32_t*)malloc(size);
 if (h_C == 0) CleanupResources();

 // Initialize input vectors
 RandomInit(h_A, N);
 RandomInit(h_B, N);

 // Allocate vectors in device memory
printf("before\n");
 checkCudaErrors( cudaMalloc((void**)&d_A, size) );
 checkCudaErrors( cudaMalloc((void**)&d_B, size) );
 checkCudaErrors( cudaMalloc((void**)&d_C, size) );
printf("after\n");

 // Copy vectors from host memory to device memory
 checkCudaErrors( cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice) );
 checkCudaErrors( cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice) );

 //VecAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);
 dim3 dimGrid(blocks,1);
 dim3 dimBlock(THREADS_PER_BLOCK,1);
 dim3 dimGrid2(1,1);
 dim3 dimBlock2(1,1);



PowerKernal2<<<dimGrid,dimBlock>>>(d_A, d_B, d_C, N, iterations,div);
cudaThreadSynchronize();


getLastCudaError("kernel launch failure");
cudaThreadSynchronize();

#ifdef _DEBUG
 checkCudaErrors( cudaDeviceSynchronize() );
#endif

 // Copy result from device memory to host memory
 // h_C contains the result in host memory
 checkCudaErrors( cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost) );
 
 CleanupResources();

 return 0;
}

void CleanupResources(void)
{
  // Free device memory
  if (d_A)
	cudaFree(d_A);
  if (d_B)
	cudaFree(d_B);
  if (d_C)
	cudaFree(d_C);

  // Free host memory
  if (h_A)
	free(h_A);
  if (h_B)
	free(h_B);
  if (h_C)
	free(h_C);

}

// Allocates an array with random uint32_t entries.
void RandomInit(uint32_t* data, int n)
{
  for (int i = 0; i < n; ++i){ 
	data[i] = rand() / RAND_MAX;
  }
}






