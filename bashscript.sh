#!/bin/bash
plain="EncodingsClean/SokobanPlainEncoding.lp"
inc="EncodingsClean/SokobanIncEncoding.lp"
split="EncodingsClean/SokobanSplitEncodingB.lp"
splitinc="EncodingsClean/SokobanSplitIncEncoding.lp"
plainass="EncodingsClean/Assignments/SokobanPlainEncodingAssignments.lp"
incass="EncodingsClean/Assignments/SokobanIncEncodingAssignments.lp"
splitass="EncodingsClean/Assignments/SokobanSplitEncodingAssignments.lp"
splitincass="EncodingsClean/Assignments/SokobanSplitIncEncodingAssignments.lp"

clutter="EncodingsClean/Optimizations/Clutter.optimization.lp"
forfie="EncodingsClean/Optimizations/ForbiddenFields.optimization.lp"
moob="EncodingsClean/Optimizations/MovesOutOfBounds.optimization.lp"
ntb="EncodingsClean/Optimizations/NoTakebacks.optimization.lp"
wbtc="EncodingsClean/Optimizations/WallBoxTargetCheck.optimization.lp"

spclutter="EncodingsClean/OptimizationsSplit/SplitClutter.optimization.lp"
spforfie="EncodingsClean/OptimizationsSplit/SplitForbiddenFields.optimization.lp"
spmoob="EncodingsClean/OptimizationsSplit/SplitMovesOutOfBounds.optimization.lp"
spntb="EncodingsClean/OptimizationsSplit/SplitNoTakebacks.optimization.lp"
spwbtc="EncodingsClean/OptimizationsSplit/SplitWallBoxTargetCheck.optimization.lp"

index=0

for inst in "InstancesClean"/Inst-A-Z*.lp
do
	index=${inst: -20}
	clingo $plain $inst --stats -q2 --time-limit=900 >> Results/results${index}.txt
	echo $index
	#clingo $plain $inst $clutter --stats -q2 --time-limit=900 >> resultsC${index}.txt
	#clingo $plain $inst $forfie --stats -q2 --time-limit=900 >> resultsFF${index}.txt
	#clingo $plain $inst $moob --stats -q2 --time-limit=900 >> resultsMOOB${index}.txt
	#clingo $plain $inst $ntb --stats -q2 --time-limit=900 >> resultsNTB${index}.txt
	#clingo $plain $inst $wbtc --stats -q2 --time-limit=900 >> resultsWBTC${index}.txt
	#clingo $plain $inst $clutter $moob $ntb --stats -q2 --time-limit=900 >> resultsType1${index}.txt
	#clingo $plain $inst $clutter $moob $ntb $wbtc --stats -q2 --time-limit=900 >> resultsType2${index}.txt
#	clingo $split $inst $spclutter --stats -q2 --time-limit=900 >> resultsSplitC${index}.txt
#	clingo $split $inst $spforfie --stats -q2 --time-limit=900 >> resultsSplitFF${index}.txt
##	clingo $split $inst $spmoob --stats -q2 --time-limit=900 >> resultsSplitMOOB${index}.txt
#	clingo $split $inst $spntb --stats -q2 --time-limit=900 >> resultsSplitNTB${index}.txt
#	clingo $split $inst $spwbtc --stats -q2 --time-limit=900 >> resultsSplitWBTC${index}.txt
#	clingo $split $inst $spclutter $spmoob $spntb --stats -q2 --time-limit=900 >> resultsSplitType1${index}.txt
#	clingo $split $inst $spclutter $spmoob $spntb $spwbtc --stats -q2 --time-limit=900 >> resultsSplitType2${index}.txt
done

#for entry in "EncodingsClean/Assignments"/*.lp
#do
#	echo "$entry"
#done
#
#for entry in "EncodingsClean/Optimizations"/*.lp
#do
#	echo "$entry"
#done


#for entry in "InstancesClean/Assignments"/*.lp
#do
#	echo "$entry"
#done
