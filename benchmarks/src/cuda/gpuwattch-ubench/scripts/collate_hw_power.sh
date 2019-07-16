#!/bin/bash

SCRIPT_DIR=`pwd`

output_file=collated_power.txt
if [ -e "$SCRIPT_DIR/power_reports" ] && [ -d "$SCRIPT_DIR/power_reports" ]; then
	cd "$SCRIPT_DIR/power_reports" 
	if [ -e "$output_file" ]; then
		rm "$output_file"
	fi
	touch "$output_file"
	benchmarks=`ls | grep power.rpt`
	for bm in $benchmarks
	do	
		bm_name=`echo $bm | sed 's/-power.rpt//'`
		power=`cat $bm | sed 's/Power draw = //' | cut -d ' ' -f 1`
		echo "$bm_name,$power," >> "$output_file"
	done
else
	echo "Power reports directory not found"
	exit 1
fi


