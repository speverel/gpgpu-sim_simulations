#!/bin/bash

rate=100
temp=65
samples=600
sleep_time=30
max_iter=2000000000
SCRIPT_DIR=`pwd`
BINDIR="$SCRIPT_DIR/../../../../bin/11.1/release/"
PROFILER="$SCRIPT_DIR/../tools/profiler"
ITERATIONS_FILE="$SCRIPT_DIR/../ubench.cfg"
benchmarks=`cat $ITERATIONS_FILE`

cd $BINDIR
if [ -d $SCRIPT_DIR/power_reports ]; then
	rm -r $SCRIPT_DIR/power_reports
fi
mkdir $SCRIPT_DIR/power_reports
mkdir -p $SCRIPT_DIR/profile_output
for run in {1..10}
do
	for num_cores in 1 16 32 48 64 80
	do
		bm_name="ACT_CORE"
		echo "Starting profiling of ACT_CORE_$num_cores"
		mkdir -p $SCRIPT_DIR/power_reports/${bm_name}_100_${num_cores}
		./ACT_CORE $max_iter $num_cores &
		pid=`nvidia-smi | grep $bm_name | awk '{ print $5 }'`
		$PROFILER -t $temp -r $rate -n $samples -o $SCRIPT_DIR/power_reports/${bm_name}_100_${num_cores}/power_run_$run.rpt >> $SCRIPT_DIR/profile_output/${bm_name}_100_${num_cores}.txt
		echo "Profiling concluded. Killing ACT_CORE_$num_cores"
		kill -9 $pid
		echo "Sleeping..."
		sleep 10
	done

	for bm in $benchmarks
	do
		bm_name=$bm
		echo "Starting profiling of $bm_name"
		mkdir -p $SCRIPT_DIR/power_reports/$bm_name				
		./$bm_name $max_iter &
		$PROFILER -t $temp -r $rate -n $samples -o $SCRIPT_DIR/power_reports/$bm_name/power_run_$run.rpt >> $SCRIPT_DIR/profile_output/$bm_name.txt
		pid=`nvidia-smi | grep $bm_name | awk '{ print $5 }'`
		echo "Profiling concluded. Killing $bm_name with pid: $pid"
		kill -9 $pid
		echo "Sleeping..."
		sleep $sleep_time
	done
done
