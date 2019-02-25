#include <stdio.h>
#include <stdlib.h>
#include <cutil.h>
#include <math.h>
// Includes
#include <stdio.h>
#include "../include/ContAcq-IntClk.h"
#include "../include/repeat2.h"
// includes, project
#include "../include/sdkHelper.h"  // helper for shared functions common to CUDA SDK samples
//#include <shrQATest.h>
//#include <shrUtils.h>

// includes CUDA
#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 256
#define NUM_OF_BLOCKS 60

#define LINE_SIZE 	128
#define SETS		64
#define ASSOC		6
#define SIMD_WIDTH	32
#define NUM_OF_THREADS 32
// Variables
int* h_A;
int* h_B;
int* h_C;
int* d_A;
int* d_B;
int* d_C;
bool noprompt = false;
unsigned int my_timer;

// Functions
void CleanupResources(void);
void RandomInit(int*, int);
void ParseArguments(int, char**);

////////////////////////////////////////////////////////////////////////////////
// These are CUDA Helper functions

// This will output the proper CUDA error strings in the event that a CUDA host call returns an error
#define checkCudaErrors(err)  __checkCudaErrors (err, __FILE__, __LINE__)

inline void __checkCudaErrors(cudaError err, const char *file, const int line ){
  if(cudaSuccess != err){
	fprintf(stderr, "%s(%i) : CUDA Runtime API error %d: %s.\n",file, line, (int)err, cudaGetErrorString( err ) );
	 exit(-1);
  }
}

// This will output the proper error string when calling cudaGetLastError
#define getLastCudaError(msg)      __getLastCudaError (msg, __FILE__, __LINE__)

inline void __getLastCudaError(const char *errorMessage, const char *file, const int line ){
  cudaError_t err = cudaGetLastError();
  if (cudaSuccess != err){
	fprintf(stderr, "%s(%i) : getLastCudaError() CUDA error : %s : (%d) %s.\n",file, line, errorMessage, (int)err, cudaGetErrorString( err ) );
	exit(-1);
  }
}

// end of CUDA Helper Functions


int gcf(int a, int b)
{
        if (a == 0) return b;
        return gcf(b % a, a);
}


// Device code
const int page_size = 4;        // Scale stride and arrays by page size.

__global__ void global_latency (unsigned int * my_array, int array_length, int iterations, unsigned * duration) {

    
        unsigned  sum_time = 0;
        duration[0] = 0;
	unsigned j=0;
	unsigned LINESIZE= 1;
	unsigned CACHESIZE= 4096;
	unsigned LIMIT=0;
	int m=0;
/*
	// fill L1/L2 cache
	for (int k=0; k<CACHESIZE; k+=LINESIZE){
		m=k%array_length;
		j+=my_array[m];
	} 
	       
	if (j>=array_length) j=0;
*/
	int tid = blockDim.x * blockIdx.x + threadIdx.x;
	j=tid;
        for (int k = 0; k < iterations; k++) {
               repeat1(j = my_array[j];)
                // repeat1024(j=*(unsigned int **)j
        }

        //my_array[array_length] = (unsigned int)j;
        //my_array[array_length+1] = (unsigned int) sum_time;
        duration[0] = j;
}



void parametric_measure_global(int N, int iterations, int stride) {


        int i;
	int j=0;
        unsigned int * h_a;
        unsigned int * d_a;


        unsigned * duration;

        unsigned long long * latency;
        unsigned long long latency_sum = 0;

        // Don't die if too much memory was requested.
        if (N > 650000000) { printf ("OOM.\n"); return; }

        // allocate arrays on CPU 
        h_a = (unsigned int *)malloc(sizeof(unsigned int) * (N+2+NUM_OF_THREADS));
        latency = (unsigned long long *)malloc(sizeof(unsigned long long));

        // allocate arrays on GPU 
        cudaMalloc ((void **) &d_a, sizeof(unsigned int) * (N+2+NUM_OF_THREADS));

        cudaMalloc ((void **) &duration, sizeof(unsigned long long));

        // initialize array elements on CPU with pointers into d_a. 

        int step = gcf (stride, N);     // Optimization: Initialize fewer elements.
        for (i = 0; i < N; i += step) {
                // Device pointers are 32-bit on GT200.
                for (j=0; j<NUM_OF_THREADS; j++)
			h_a[i+j] = ((i + j + stride) % N);

        }
	for (j=0; j<NUM_OF_THREADS; j++)
		h_a[N+j] = j;
        h_a[N+NUM_OF_THREADS] = 0;
	

        cudaThreadSynchronize ();

        // copy array elements from CPU to GPU 
       cudaMemcpy((void *)d_a, (void *)h_a, sizeof(unsigned int) * N, cudaMemcpyHostToDevice);

        cudaThreadSynchronize ();


        // Launch a multiple of 10 iterations of the same kernel and take the average to eliminate interconnect (TPCs) effects 

        for (int l=0; l <1; l++) {

                // launch kernel
                dim3 Db = dim3(NUM_OF_THREADS);
                dim3 Dg = dim3(1,1,1);

                //printf("Launch kernel with parameters: %d, N: %d, stride: %d\n", iterations, N, stride); 
 
                global_latency <<<Dg, Db>>>(d_a,N, iterations, duration);

		//global_latency <<<Dg, Db>>> ();

                cudaThreadSynchronize ();

                cudaError_t error_id = cudaGetLastError();
                if (error_id != cudaSuccess) {
                        printf("Error is %s\n", cudaGetErrorString(error_id));
                }
		
                // copy results from GPU to CPU 
                cudaThreadSynchronize ();

                //cudaMemcpy((void *)h_a, (void *)d_a, sizeof(unsigned int) * (N+2), cudaMemcpyDeviceToHost);
                cudaMemcpy((void *)latency, (void *)duration, sizeof(unsigned long long), cudaMemcpyDeviceToHost);

                cudaThreadSynchronize ();
                latency_sum+=latency[0];

        }

        // free memory on GPU 
        cudaFree(d_a);

        cudaFree(duration);

        cudaThreadSynchronize ();

        // free memory on CPU 
        free(h_a);
        free(latency);


//	return 0;

}


	





// Host code
int main() {

 
	 printf("Assuming page size is %d KB\n", page_size);
        // we will measure latency of global memory
        // One thread that accesses an array.
        // loads are dependent on the previously loaded values

        int N, iterations, stride;

        // initialize upper bounds here
        int stride_upper_bound;

        printf("Global1: Global memory latency for 1 KB array and varying strides.\n");
        printf("   stride (bytes), latency (clocks)\n");


N= 536870912;
iterations = 40;
        stride_upper_bound = N;
stride= 2048;
	//for (stride = 1; stride <= (stride_upper_bound) ; stride+=1) {
        //        printf ("  %5d, ", stride*4);
          parametric_measure_global(N, iterations, stride);
        //}
    

        return 0;
}







