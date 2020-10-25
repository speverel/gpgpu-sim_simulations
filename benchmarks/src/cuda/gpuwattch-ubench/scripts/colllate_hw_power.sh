#!/bin/bash

SCRIPT_DIR=`pwd`

output_folder=formatted_power
if [ -e "$SCRIPT_DIR/power_reports" ] && [ -d "$SCRIPT_DIR/power_reports" ]; then
	if [ -d "$output_folder" ]; then
		rm -r "$output_folder"
	fi
	mkdir $output_folder
	for bm in `ls $SCRIPT_DIR/power_reports`
	do	
		for data in `ls $SCRIPT_DIR/power_reports/$bm`
		do
			power=`cat $SCRIPT_DIR/power_reports/$bm/$data | awk -F'Power draw = ' '{print $2}' | awk -F' W' '{print $1}'`
			echo $power >> $output_folder/$bm.rpt
		done
	done
	python generateCSV.py
	rm -r $output_folder
else
	echo "Power reports directory not found"
	exit 1
fi


