#!/bin/bash
OUT="out"
NOTABLE="notable"

# Print industry with fewest X
echo "-- Fewest total employed --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $2}' | grep '\<51\>'
echo "-- Fewest women --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $3}' | grep '\<5.9\>'
echo "-- Fewest whites --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $4}' | grep '\<42.6\>'
echo "-- Fewest blacks --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $5}' | grep '0.7'
echo "-- Fewest asains --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $6}' | grep '\<0.0\>'
echo "-- Fewest hispanics --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $7}' | grep '\<3.8\>'

printf "\n\n\n"

# Print industry with most X
echo "-- MOST total employed --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $2}' | grep '\<35043\>'
echo "-- MOST women --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $3}' | grep '\<93.8\>'
echo "-- MOST whites --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $4}' | grep '\<96.7\>'
echo "-- MOST blacks --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $5}' | grep '35.6'
echo "-- MOST asains --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $6}' | grep '\<47.2\>'
echo "-- MOST hispanics --"
cat out/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $7}' | grep '\<47.1\>'
