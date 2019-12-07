#!/bin/bash
OUT="out"
NOTABLE="notable"

NOTABLE="notable/no_reps"
# Enumerate all industries with 0% women
cat ${OUT}/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $3}' | grep -e '\<0\>' | grep -v '\.' | awk '{print $1}' > ${NOTABLE}/women.txt

# Enumerate all industries with 0% white
cat ${OUT}/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $4}' | grep -e '\<0\>' | grep -v '\.' | awk '{print $1}' > ${NOTABLE}/white.txt

# Enumerate all industries with 0% black
cat ${OUT}/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $5}' | grep -e '\<0\>' | grep -v '\.' | awk '{print $1}' > ${NOTABLE}/black.txt

# Enumerate all industries with 0% asain
cat ${OUT}/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $6}' | grep -e '\<0\>' | grep -v '\.' | awk '{print $1}' > ${NOTABLE}/asian.txt

# Enumerate all industries with 0% hispanic
cat ${OUT}/input_file.txt | tr ',' '\t' | awk '{print $1 "\t" $7}' | grep -e '\<0\>' | grep -v '\.' | awk '{print $1}' > ${NOTABLE}/hispanic.txt

