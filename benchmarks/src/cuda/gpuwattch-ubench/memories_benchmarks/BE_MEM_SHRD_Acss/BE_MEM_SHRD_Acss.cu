// Includes
#include <stdio.h>
#include <stdlib.h>


// includes CUDA
#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 256
#define NUM_OF_BLOCKS 640

// Variables



// Functions

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




// Device code
__global__ void PowerKernal(int iterations)
{
    int i = threadIdx.x;
    //Do Some Computation
   __device__  __shared__ unsigned I1[THREADS_PER_BLOCK];
   __device__  __shared__ unsigned I2[THREADS_PER_BLOCK];
   __device__ __shared__ float I3[THREADS_PER_BLOCK];
   __device__  __shared__ float I4[THREADS_PER_BLOCK];
	
    I1[i]=i*2;
    I2[i]=i;
    I3[i]=i/2;
    I4[i]=i;

    __syncthreads();

    for(unsigned k=0; k<iterations ;k++) {
        		I1[i]=I2[(i+k)%THREADS_PER_BLOCK];
        		I2[i]=I1[(i+k+1)%THREADS_PER_BLOCK];
    }		
         
    for(unsigned k=0; k<iterations ;k++) {
    			I3[i]=I4[(i+k)%THREADS_PER_BLOCK];
    			I4[i]=I3[(i+k+1)%THREADS_PER_BLOCK];
    } 
    __syncthreads();

}


// Host code

int main(int argc, char** argv) 
{

 int iterations;
 if (argc != 2){
  fprintf(stderr,"usage: %s #iterations\n",argv[0]);
  exit(1);
 }
 else{
  iterations = atoi(argv[1]);
 }

 printf("Power Microbenchmark with %d iterations\n",iterations);


 // Allocate vectors in device memory

 cudaEvent_t start, stop;
 float elapsedTime = 0;
 checkCudaErrors(cudaEventCreate(&start));
 checkCudaErrors(cudaEventCreate(&stop));
  
 dim3 dimGrid(NUM_OF_BLOCKS,1);
 dim3 dimBlock(THREADS_PER_BLOCK,1);

 checkCudaErrors(cudaEventRecord(start));
 PowerKernal<<<dimGrid,dimBlock>>>(iterations);

 checkCudaErrors(cudaEventRecord(stop));

 checkCudaErrors(cudaEventSynchronize(stop));
 checkCudaErrors(cudaEventElapsedTime(&elapsedTime, start, stop));
 printf("gpu execution time = %.2f s\n", elapsedTime/1000);

 getLastCudaError("kernel launch failure");
 cudaThreadSynchronize();
 checkCudaErrors(cudaEventDestroy(start));
 checkCudaErrors(cudaEventDestroy(stop));

 return 0;
}








