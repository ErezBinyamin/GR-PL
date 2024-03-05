import pandas
from pdb import set_trace as bp
from numpy import log

# Stats models function naming
import statsmodels.formula.api as smf
import statsmodels.stats.api as sms
from statsmodels.compat import lzip
lm      = smf.ols

BLS_CSV = "./data/bls/bls.csv"

def bptest(olsModelData):
    # Define toString value for bptest result
    class Bpresult:
        def __init__(self, olsModelData):
            self.olsModelData = olsModelData
            self.fieldnames   = ['Lagrange multiplier statistic', 'p-value', 'f-value', 'p-value']
            self.bpvalues     = sms.het_breuschpagan(olsModelData.resid, olsModelData.model.exog)
            #self.result     = lzip(self.fieldnames, self.smsbp)
            self.result = {}
            for i in range(len(self.fieldnames)):
                key   = self.fieldnames[i]
                value = self.bpvalues[i]
                self.result[key] = value
        def __str__(self):
            rep = '\n\t-- studentized Breusch-Pagan test --\n'
            rep += f"formula = {olsModelData.model.formula}\n"
            rep += f"BP      = {self.result['Lagrange multiplier statistic']}\n"
            rep += f"df      = {olsModelData.df_model}\n"
            if (self.result['p-value'] < (2.2 * (10**-16))):
                rep += f"p-value < 2.2e-16\n"
            else:
                rep += f"p-value = {self.result['p-value']}\n"
            rep +='\n'
            return rep
    res = Bpresult(olsModelData)
    return res

#	phy_lbr:	Boolean is profession "Physical Labor"
#	tot_emp:	Total employed(Thousands)
#	women:		Women(%)
#	white:		White(%)
#	black:		Black(%)
#	asian:		Asian(%)
#	hispanic:	Hispanic(%)
bls_df = pandas.read_csv(BLS_CSV)
print(bls_df.describe())

# M1
# Use R code get the OLS estimates of the parameters of the following regression model, where u i is
# the regression error:
# phy_lbr(i) = β_0 + β_1 ln(tot_emp(i)) + β_2 women(i) + β_3 white(i) + β_4 black(i) + β_5 asian(i) + β_6 hispanic(i) + u(i)
bls_ols_phylbr = lm(formula = "phy_lbr ~ log(tot_emp) + women + white + black + asian + hispanic", data=bls_df).fit()
print(bls_ols_phylbr.summary())

# F test: INSIGNIFICANT VARIABLES: tot_emp white black asian and hispanic
#ftest_1 <- linearHypothesis(bls_ols_phylbr, c("log(tot_emp)=0", "white=0", "black=0", "asian=0", "hispanic=0"))
#TODO

# Testing homoskedasticity
print(bptest(bls_ols_phylbr))

# T-Test of coefficients: heteroskedasticity-corrected
#TODO

# M2
# the regression error:
# women(i) = β_0 + β_1 ln(tot_emp(i)) + β_2 phy_lbr + β_3 white(i) + β_4 black(i) + β_5 asian(i) + β_6 hispanic(i) + u(i)
bls_ols_women = lm(formula = "women ~ log(tot_emp) + phy_lbr + white + black + asian + hispanic", data=bls_df).fit()
print(bls_ols_women.summary())

# F test: asain=1
#ftest_2 <- linearHypothesis(bls_ols_phylbr, c("asian=1"))
#TODO

# Testing homoskedasticity
print(bptest(bls_ols_women))

# T-Test of coefficients: heteroskedasticity-corrected
#TODO

#################################################################################################################
# Extra fun stuff :)
#################################################################################################################
# M1: Ignoring insignificant variables
# Exasterbate M1 findings
#bls_ols_phylbr_clean = lm(formula = "phy_lbr ~ women", data=bls_df).fit()
#print(bls_ols_phylbr_clean.summary())

# M2: Ignoring insignificant variables
# Exasterbate M2 findings
#bls_ols_women_clean = lm(formula = "women ~ log(tot_emp) + phy_lbr + white + black + asian", data=bls_df).fit()
#print(bls_ols_phylbr_clean.summary())

# Actual numbers of things
# women variable is % of workforce that is women
# tot_emp is the number of people in the workforce
# women * tot_emp is the number of WOMEN in the workforce
#bls_ols_num = lm(formula = "I(women*tot_emp) ~ phy_lbr + I(white*tot_emp) + I(black*tot_emp) + I(asian*tot_emp) + I(hispanic*tot_emp)", data = bls_df).fit()
#bls_ols_num = lm(formula = "phy_lbr ~ I(women*tot_emp) + I(white*tot_emp) + I(black*tot_emp) + I(asian*tot_emp) + I(hispanic*tot_emp)", data = bls_df).fit()
#print(bls_ols_phylbr_clean.summary())

# Percent increase in population as a function of demographics
# Which demographics are indicators of labor force growth
#bls_ols_totemp = lm(formula = "log(tot_emp) ~ phy_lbr + women + white + black + asian + hispanic", data = bls_df).fit()
#print(bls_ols_totemp.summary())
