#!/bin/bash
clingo 
for enc in "EncodingsClean/Test"/*.lp
do
	for inst in "InstancesClean/Test"/*.lp
	do
		clingo $enc $inst --stats --time-limit=1800 >> results.txt
	done
done

for entry in "EncodingsClean/Assignments"/*.lp
do
	echo "$entry"
done

for entry in "EncodingsClean/Optimizations"/*.lp
do
	echo "$entry"
done


for entry in "InstancesClean/Assignments"/*.lp
do
	echo "$entry"
done
