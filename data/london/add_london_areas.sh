#!/bin/bash
COLS=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
while IFS= read -r line; do
	for i in {0..14}
	do
		Curr="${COLS[$i]}"
		Val=$(echo $line | tr ',' '\t' | cut -f $(($i + 1)))
		New=$(bc -l <<< "${Curr} + ${Val}" 2>1)
		[ ${#Val} -gt 3 ] && COLS[$i]=$New
	done
done < "women.csv"
echo ${COLS[@]}
