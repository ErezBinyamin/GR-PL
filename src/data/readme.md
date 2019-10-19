From: Beaurau of labor statistics
bls.csv: https://www.bls.gov/cps/cpsaat18.html

From: London.gov
london.csv: https://data.london.gov.uk/dataset/differences-in-employment-by-gender-in-london-report

## Script used to retrieve data set and parse into CSV file:

```
curl 'https://www.bls.gov/cps/cpsaat18.htm' | sed 's/<[^>]*>//g;' | sed 's/ //g; s/\t//g; /^\s*$/d' > curl.html
sed -n '/n.e.c. /q;p' data.html | sed '/HOUSEHOLD/,$!d' > shortend.html

C=-2		# Ignore first 2 lines
while read l; do
	[ $C -eq 0 ] && rm -f bls.csv
	if [ 0 -eq $(( C % 7 )) ]
	then
		printf "\n$l" | tr ',' ':' >> bls.csv
	else
		printf ", $(echo $l | tr -d ',')"  >> bls.csv
	fi
	let C++
done < shortend.html
```
## Script used to score Physical Labor boolean
