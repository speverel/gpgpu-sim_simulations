#!/bin/bash

#if [ $# = 2 ]; then
#	rate="$2"
#	gpu="$1"
#else if [ $# = 1 ]; then
#	rate=10
#	gpu="$1"
#else
#	echo "Usage: profile_all_power.sh <gpu_name> or profile_all_power.sh <gpu_name> <sampling_rate>"
#	exit 1
#fi
#if [ $# = 1 ]; then
#if [ $1 = "HW" ]; then
#MODE="HW"
#elif [ $1 = "SM" ]; then
#MODE="SM"
#else
#echo "Usage: profile_all_power.sh <HW/SM> for hardware or simulator runs respectively"
#exit 1
#fi
#else
#echo "Usage: profile_all_power.sh <HW/SM> for hardware or simulator runs respectively"
#echo "Usage: profile_all_power.sh <gpu_name> or profile_all_power.sh <gpu_name> <sampling_rate>"
#exit 1
#fi

rate=100
temp=65
samples=600
sleep_time=15
max_iter=2000000000
SCRIPT_DIR=`pwd`
BINDIR="$SCRIPT_DIR/../bin/linux/release"
PROFILER="$SCRIPT_DIR/../tools/profiler"
ITERATIONS_FILE="$SCRIPT_DIR/../iterations.cfg"
benchmarks=`cat $ITERATIONS_FILE`
#cd $PROF_DIR
#make
cd $BINDIR
rm -r ./power_reports/
mkdir ./power_reports/
#dir_contents=`ls`
for bm in $benchmarks
do
	bm_name=`echo $bm | cut -d "," -f 1`
	iterations=`echo $bm | cut -d "," -f 2`
	if [ -f $bm_name ] && [ -x $bm_name ]; then
		echo "Starting profiling of $bm_name"
		./$bm_name $max_iter &
		$PROFILER -t $temp -r $rate -n $samples -o ./power_reports/$bm_name"-power.rpt"
		pid=`nvidia-smi | grep $bm_name | sed -e 's/| \+[0-9] \+//' | sed -e 's/ \+.*//'`
		echo "Profiling concluded. Killing $bm_name"
		kill -9 $pid
		echo "Sleeping..."
		sleep $sleep_time
	fi	
done
