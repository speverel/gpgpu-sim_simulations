#!/bin/bash

export data="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data"

#RODINIA
export heartwall_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/heartwall/heartwall /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/heartwall/test.avi 2"
export hotspot_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/hotspot/hotspot 512 2 2 /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/hotspot/temp_1024 /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/hotspot/power_1024 output.out"
export needle_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/nw/needle 16384 1"
export bfs_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/bfs/bfs /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/bfs/graph1MW_6.txt"
export sc_gpu_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/streamcluster/sc_gpu 8 16 16 8192 8192 512 none output.txt 1"
export particlefilter_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/particlefilter/particlefilter_float -x 128 -y 128 -z 2 -np 32768"
export pathfinder_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/pathfinder/pathfinder 100000 100 20"
export gaussian_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/gaussian/gaussian -s 368"
export myocyte_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/myocyte/myocyte.out 10 32768 1"
export tree_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/b+tree/b+tree.out file /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/b+tree/mil.txt command /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/b+tree/command.txt"
export dwt2d_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/dwt2d/dwt2d rgb.bmp -d 1024x1024 -f -5 -l 1"
export kmeans_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/kmeans/kmeans -o -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/kmeans/204800.txt" 
export lavaMD_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/lavaMD/lavaMD -boxes1d 5"
export backprop_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/backprop/backprop 65536"
export lud_cuda_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/lud/cuda/lud_cuda -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/data/lud/2048.dat"
export srad_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/rodinia/3.1/cuda/srad/srad_v1/srad 100 0.5 502 458"

#CUDASDK-9.1
export dct_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/dct8x8"
export radixSortThrust_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/radixSortThrust"
export dxtc_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/dxtc"
export BlackScholes_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/BlackScholes"
export vectorAdd_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/vectorAdd"
export binomialOptions_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/binomialOptions"
export fastWalshTransform_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/fastWalshTransform"
export scan_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/scan"
export transpose_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/transpose"
export histogram_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/histogram"
export mergeSort_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/mergeSort"
export quasirandomGenerator_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/quasirandomGenerator"
export SobolQRNG_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/SobolQRNG"
export sortingNetworks_r="/home/vkz4947/NVIDIA_CUDA-9.1_Samples/bin/x86_64/linux/release/sortingNetworks"

#PARBOIL
#export mri_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/mri-gridding/build/cuda_default/mri-gridding 32 0 -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/mri-gridding/small/input/small.uks"
export sgemm_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/sgemm/build/cuda_default/sgemm -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/sgemm/medium/input/matrix1.txt,/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/sgemm/medium/input/matrix2t.txt,/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/sgemm/medium/input/matrix2t.txt"
export sad_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/sad/build/cuda_default/sad -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/sad/large/input/frame.bin,/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/sad/large/input/reference.bin"
export cutcp_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/cutcp/build/cuda_default/cutcp -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/cutcp/large/input/watbox.sl100.pqr"
export mri_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/mri-q/build/cuda_default/mri-q -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/mri-q/large/input/64_64_64_dataset.bin"
export stencil_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/stencil/build/cuda_default/stencil -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/stencil/default/input/512x512x64x100.bin -- 512 512 64 100"
export lbm_r="/home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/benchmarks/lbm/build/cuda_default/lbm -i /home/vkz4947/gpgpu-sim_simulations/benchmarks/src/cuda/parboil/datasets/lbm/long/input/120_120_150_ldc.of -- 3000"

rate=100
sleep_time=15
temp=65
SCRIPT_DIR=`pwd`

PROFILER="$SCRIPT_DIR/../tools/profiler"
BENCHMARKS_FILE="$SCRIPT_DIR/../validation.cfg"
benchmarks=`cat $BENCHMARKS_FILE`
#cd $PROF_DIR
#make

rm -r $SCRIPT_DIR/power_reports
mkdir $SCRIPT_DIR/power_reports
#dir_contents=`ls`
cd $SCRIPT_DIR

for bm in $benchmarks
do
	if [ "${bm}" == "dct" ]
    then
		cp /home/vkz4947/NVIDIA_CUDA-9.1_Samples/3_Imaging/dct8x8/data/* .
	fi
	
	bm_name="${bm}_r"
	echo "Starting profiling of ${!bm_name} "
	${!bm_name} &
	$PROFILER -t $temp -r $rate -a $bm -o $SCRIPT_DIR/power_reports/$bm"-power.rpt"
	pid=`nvidia-smi | grep $bm | sed -e 's/| \+[0-9] \+//' | sed -e 's/ \+.*//'`
	echo "Profiling concluded. Killing $bm with pid: $pid"
	kill -9 $pid
	echo "Sleeping..."
	sleep $sleep_time

done
