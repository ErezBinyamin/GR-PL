# GR-PL
Econometric study of Gender Race &amp; Physical Labor

## TLDR;
    • If the percentage of women working in an industry is high, that is a good predictor that the industry would not be classified as “physical labor”
    • The percentage of Whites, Blacks, Hispanics, Asians, and the total number of people employed in an industry are irrelevant in predicting if the industry will be classified as “physical labor”.
    • Women are more likely to work in industries with larger populations.

## Study
Analysis of a data set from [US dept of labor Bureau of Labor Statistics](https://www.bls.gov/cps/cpsaat18.htm) to reveal undelying connection between gender, race, and physical labor  
This repo contains several interesting things:
  1. [Bash] Web parse data set into csv
  2. [Bash] Score qualitative industry names into Physical/Non-physical booleans
  3. [R] Generate linear regreasion models to summarize interesting relationships
  
## Replicate results
```
git clone GR-PL
cd ./GR-PL/src/data/bls
bash get_parse_score.sh
cd ../../
Rscript code.r
```

## Other
A london data set exists in the GR-PL/src/data/london folder. It is yet to be made sense of.  
Additional regressions are calculated in GR-PL/src/code.r and their summaries are simply commented out.  
