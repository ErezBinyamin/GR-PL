# Prepare Enviroment and download missing package
# install.package("pastecs")
getwd()
library(pastecs)

#	phy_lbr:	Boolean is profession "Physical Labor"
#	tot_emp:	Total employed(Thousands)
#	women:		Women(%)
#	white:		White(%)
#	black:		Black(%)
#	asian:		Asian(%)
#	hispanic:	Hispanic(%)
#bls <- read.csv("./bls.csv")
bls <- read.csv("./data/bls.csv")
summary(bls)

# M1
# Use R code get the OLS estimates of the parameters of the following regression model, where u i is
# the regression error:
# phy_lbr(i) = β_0 + β_1 ln(tot_emp(i)) + β_2 women(i) + β_3 white(i) + β_4 black(i) + β_5 asian(i) + β_6 hispanic(i) + u(i)
bls_ols_phylbr <- lm(formula = phy_lbr ~ log(tot_emp) + women + white + black + asian + hispanic, data = bls)
summary(bls_ols_phylbr)

# M2
# the regression error:
# women(i) = β_0 + β_1 ln(tot_emp(i)) + β_2 phy_lbr + β_3 white(i) + β_4 black(i) + β_5 asian(i) + β_6 hispanic(i) + u(i)
bls_ols_women <- lm(formula = women ~ log(tot_emp) + phy_lbr + white + black + asian + hispanic, data = bls)
summary(bls_ols_women)

# Extra fun stuff :)

# M1: Ignoring insignificant variables
# Exasterbate M1 findings
bls_ols_phylbr_clean <- lm(formula = phy_lbr ~ women, data = bls)
#summary(bls_ols_phylbr_clean)

# M2: Ignoring insignificant variables
# Exasterbate M2 findings
bls_ols_women_clean <- lm(formula = women ~ log(tot_emp) + phy_lbr + white + black + asian, data = bls)
#summary(bls_ols_women_clean)

# Actual numbers of things
# women variable is % of workforce that is women
# tot_emp is the number of people in the workforce
# women * tot_emp is the number of WOMEN in the workforce
bls_ols_num <- lm(formula = I(women*tot_emp) ~ phy_lbr + I(white*tot_emp) + I(black*tot_emp) + I(asian*tot_emp) + I(hispanic*tot_emp), data = bls)
bls_ols_num <- lm(formula = phy_lbr ~ I(women*tot_emp) + I(white*tot_emp) + I(black*tot_emp) + I(asian*tot_emp) + I(hispanic*tot_emp), data = bls)
summary(bls_ols_num)

# Percent increase in population as a function of demographics
# Which demographics are indicators of labor force growth
bls_ols_totemp <- lm(formula = log(tot_emp) ~ phy_lbr + women + white + black + asian + hispanic, data = bls)
#summary(bls_ols_totemp)
