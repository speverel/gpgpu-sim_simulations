#include <stdio.h>
#include <stdlib.h>
//#include <cutil.h>
//#include <mgp.h>
// Includes
//#include <stdio.h>
//#include "../include/ContAcq-IntClk.h"

// includes, project
//#include "../include/sdkHelper.h"  // helper for shared functions common to CUDA SDK samples
//#include <shrQATest.h>
//#include <shrUtils.h>

// includes CUDA
#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 2048
#define NUM_OF_BLOCKS 80
#define NUM_SM 80
#define LINE_SIZE 	128
#define SETS		4
#define ASSOC		256


// Variables
unsigned* h_A;
unsigned* h_B;
unsigned* h_C;
unsigned* d_A;
unsigned* d_B;
unsigned* d_C;
//bool noprompt = false;
//unsigned int my_timer;

// Functions
void CleanupResources(void);
void RandomInit(unsigned*, int);
//void ParseArguments(int, char**);

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



__global__ void PowerKernal2( unsigned* A, unsigned* B, int N)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;

    // unsigned loadAddr = A+ i;
    // unsigned storeAddr = B+ i;
    unsigned load_value;
	//unsigned sum_value = 0;
	#pragma unroll 100

    for(unsigned k=0; k<N;k++) {
    	__asm volatile(
    		"ld.global.ca.u32 %0, [%1];" 
    		: "=r"(load_value) : "l"((unsigned long)(A+i))
    	);
    	//__asm volatile("add.u32 %0, %0, %1;" : "+r"(sum_value) : "r"(load_value));
    	__asm volatile(
    		"st.global.wb.u32 [%0], %1;"
    		: : "l"((unsigned long)(B+i)), "r"(load_value) 
    	);

    }
    //B[i] = sum_value;
    __syncthreads();

}


int main(int argc, char** argv)
{
 int iterations;
 if(argc!=2) {
   fprintf(stderr,"usage: %s #iterations\n",argv[0]);
   exit(1);
 }
 else {
   iterations = atoi(argv[1]);
 }
 
 printf("Power Microbenchmarks with iterations %d\n",iterations);
 int size_per_sm = (LINE_SIZE*ASSOC*SETS); //131072
 int N = THREADS_PER_BLOCK*NUM_OF_BLOCKS;

 size_t size = size_per_sm*NUM_SM < N * sizeof(int) ? size_per_sm*NUM_OF_BLOCKS : N * sizeof(int);
 // Allocate input vectors h_A and h_B in host memory
 h_A = (unsigned*)malloc(size);
 if (h_A == 0) CleanupResources();
 h_B = (unsigned*)malloc(size);
 if (h_B == 0) CleanupResources();


 // Initialize input vectors
 RandomInit(h_A, N);


 // Allocate vectors in device memory
 checkCudaErrors( cudaMalloc((void**)&d_A, size) );
 checkCudaErrors( cudaMalloc((void**)&d_B, size) );


 // Copy vectors from host memory to device memory
 checkCudaErrors( cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice) );


 cudaEvent_t start, stop;                   
 float elapsedTime = 0;                     
 checkCudaErrors(cudaEventCreate(&start));  
 checkCudaErrors(cudaEventCreate(&stop));

 //VecAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);
 dim3 dimGrid(NUM_OF_BLOCKS,1);
 dim3 dimBlock(THREADS_PER_BLOCK,1);
 dim3 dimGrid2(1,1);
 dim3 dimBlock2(1,1);

 checkCudaErrors(cudaEventRecord(start));              
 PowerKernal2<<<dimGrid,dimBlock>>>(d_A, d_B,iterations);  
 checkCudaErrors(cudaEventRecord(stop));               
 
 checkCudaErrors(cudaEventSynchronize(stop));           
 checkCudaErrors(cudaEventElapsedTime(&elapsedTime, start, stop));  
 printf("execution time = %.2f s\n", elapsedTime/1000);  
 getLastCudaError("kernel launch failure");              
 cudaThreadSynchronize(); 

/* CUT_SAFE_CALL(cutCreateTimer(&my_timer)); 
 TaskHandle taskhandle = LaunchDAQ();
 CUT_SAFE_CALL(cutStartTimer(my_timer)); 
 printf("execution time = %f\n", cutGetTimerValue(my_timer));

profileKernel("BE_SP_INT_ADD", "PowerKernal2");
for (int i = 0; i < 1000; i++)
{
	PowerKernal2<<<dimGrid,dimBlock>>>(d_A, d_B, d_C, N);
	CUDA_SAFE_CALL( cudaThreadSynchronize() );
}
haltProfiling();
printf("execution time = %f\n", cutGetTimerValue(my_timer));

getLastCudaError("kernel launch failure");
CUDA_SAFE_CALL( cudaThreadSynchronize() );
CUT_SAFE_CALL(cutStopTimer(my_timer));
TurnOffDAQ(taskhandle, cutGetTimerValue(my_timer));
printf("execution time = %f\n", cutGetTimerValue(my_timer));
CUT_SAFE_CALL(cutDeleteTimer(my_timer)); 

#ifdef _DEBUG
 checkCudaErrors( cudaDeviceSynchronize() );
#endif*/

 // Copy result from device memory to host memory
 // h_C contains the result in host memory
 checkCudaErrors( cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost) );
  checkCudaErrors(cudaEventDestroy(start));
 checkCudaErrors(cudaEventDestroy(stop));
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

  // Free host memory
  if (h_A)
	free(h_A);
  if (h_B)
	free(h_B);

}

// Allocates an array with random float entries.
void RandomInit(unsigned* data, int n)
{
  for (int i = 0; i < n; ++i){
	srand((unsigned)time(0));  
	data[i] = rand() / RAND_MAX;
  }
}