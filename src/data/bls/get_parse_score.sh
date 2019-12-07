#!/bin/bash
# This script:
# Raw html -> first parse html -> second pass csv on many lines -> csv
OUT_DIR='./out'
mkdir -p ${OUT_DIR}

STAGE_1="${OUT_DIR}/raw_bls.html"
STAGE_2="${OUT_DIR}/raw_bls.txt"
STAGE_3="${OUT_DIR}/raw_bls.csv"

# Get data and do first parse
curl 'https://www.bls.gov/cps/cpsaat18.htm' | sed 's/<[^>]*>//g;' | sed 's/\t//g; /^\s*$/d' > ${STAGE_1}

# Turn first parse into almost-csv
sed -n '/n.e.c. =/q;p' ${STAGE_1} | sed '/Numbers in thousands/,$!d' | tail -n +2 > ${STAGE_2}

# The shortened data file must be a csv that is broken into newlines for example:
# FIELD 1
# FIELD 2
# FIELD 3
# FIELD 4
# FIELD 5
# FIELD 6
# FIELD 7
# FIELD 1
# FIELD 2
# FIELD ...etc
# Will become proper CSV format in 'bls.csv':
# FIELD 1,FIELD 2,FIELD 3,FIELD 4,FIELD 5,FIELD 6,FIELD 7
# FIELD 1,FIELD 2,FIELD 3,FIELD 4,FIELD 5,FIELD 6,FIELD 7
# FIELD 1,FIELD 2,FIELD 3,FIELD 4,FIELD 5,FIELD 6,FIELD 7
C=-2		# Ignore first 2 lines
while read l; do
	[ $C -eq 0 ] && rm -f ${STAGE_3}
	if [ 0 -eq $(( C % 7 )) ]
	then
		printf "\n$l" | tr ',' ':' >> ${STAGE_3}
	else
		printf ", $(echo $l | tr -d ',')"  >> ${STAGE_3}
	fi
	let C++
done < ${STAGE_2}
#!/bin/bash
# This script reads a CSV with string industry names in the first column
# It replaces those industry/profession names with either a 0 or a 1 (boolean)
# 1 indicates that the profession name contained one of the physical labor keywords
# 0 indicates that the profession name did not, or contained one of the specifically non-physical keywords
# Generates a new scored csv 'scored.csv'
# A list of physical-labor professions 'physical.csv'
# A list of non-physical-labor professions 'non-physical.csv'

# Replace 'STRING' type industry column with a boolean 'PHYSICAL LABOR' category
#	0 - Not physical labor
#	1 - Physical labor

OUT_DIR='./out'
mkdir -p ${OUT_DIR}
INPUT_CSV="${OUT_DIR}/raw_bls.csv"
INPUT_FILE=${OUT_DIR}/input_file.txt
touch ${INPUT_FILE}


#sed 's/,\s\+/,/g' ${INPUT_CSV} | sed 's/ /_/g; s/-/0/; /^\s*$/d' > ${INPUT_FILE}

sed 's/,\s\+/,/g' ${INPUT_CSV} | sed '/,-,/d' | sed 's/ /_/g; /^\s*$/d' > ${INPUT_FILE}
C=0
mkdir -p ${OUT_DIR}
while IFS= read -r line; do
	IND=$(echo $line | tr ',' '\t' | awk '{print $1}')
	case "${IND,,}" in
	# No LABOR
	*"administration"* | *"support"* | *"sale"* | *"management"* | *"service"* | *"health"* | *"dealer"* | *"distribution"* | \
	*"transportation"*)
		echo "$IND" | tr '_' ' ' >> ${OUT_DIR}/non_physical.txt
		echo $line | sed "s/${IND}/0/" >> bls.csv
		;;

	# Yes LABOR
	*"landscaping"* | *"building"* | *"mining"* | *"milling"* | *"manufacturing"* | *"logging"* | *"hunting"* | \
	*"production"* | *"construction"* | *"forestry"* | \
	*"oil"* | *"coal"* | *"petroleum"* | *"wood"*)
		echo "$IND" | tr '_' ' ' >> ${OUT_DIR}/physical.txt
		echo $line | sed "s/${IND}/1/" >> bls.csv
		;;
	 *)
		echo "$IND" | tr '_' ' ' >> ${OUT_DIR}/non_physical.txt
		echo $line | sed "s/${IND}/0/" >> bls.csv
		;;
	esac

	# First line of file should not be scored (because it is the title bar)
	if [ $C -eq 0 ]
	then
		echo "PHYSICAL LABOR PROFESSIONS" > ${OUT_DIR}/physical.txt
		echo "NON - PHYSICAL LABOR PROFESSIONS" > ${OUT_DIR}/non_physical.txt
		echo $line > bls.csv
		C=1
	fi
done < "$INPUT_FILE"

# Add header
# Shorten field names for easier R scripting
sed -i 's/Totalemployed/phy_lbr/;
s/Percent_of_total_employed/tot_emp/;
s/Women/women/;
s/White/white/;
s/Black_orAfricanAmerican/black/;
s/Asian/asian/; s/Hispanicor_Latino/hispanic/' bls.csv
