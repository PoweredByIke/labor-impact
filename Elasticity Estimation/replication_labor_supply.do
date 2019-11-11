
clear all
set more off

use "data/wage_state_year_occ.dta", clear

* Keep driving occupations only
keep if strpos(occ_code, "53-30")
drop if strpos(occ_code, "0000")
sort st year
by st year: egen tot = sum(tot_emp)

* Labor Force in each state is highest past employment level
by st: egen lforce = max(tot)

* Get job-level shares
gen share = tot_emp/(lforce + 1)
egen oc = group(occ_code)
gen wage = a_mean*tot_emp

gen lh =  oc == 5
gen sh =  oc == 6

* Collapse jobs to long haul, short haul, and other driving
collapse (sum) wage share tot_emp (mean) lforce tot, by(year st lh sh)
replace wage = wage/tot_emp


* Log share minus log outside job share
gen rel_share = log(share) - log((lforce-tot+1)/(lforce+1))


replace wage = log(wage)
egen sty = group(st year)
egen state = group(st)

* Drop islands
drop if st == "GU" | st == "PR" | st == "VI" | st == "HI"

preserve

* Get Instruments

use "data/wage_state_year_occ.dta", clear
keep if strpos(occ_code, "51-")
collapse (sum) tot_emp, by(area year)
destring area, replace
rename tot_emp mfct_emp
save "intermediate/temp", replace

restore

rename state state_id
mmerge state_id year using "data/state_incomes.dta", type(n:1)
rename state_id area
mmerge area year using "intermediate/temp", type(n:1)

replace mfct_emp = mfct_emp/ lforce
gen other = !lh &!sh

* MAIN REGRESSION *
cap drop d a
ivreghdfe rel_share  sh lh (wage =   lh#c.median  sh#c.median other#c.median lh#c.mfct_emp  sh#c.mfct_emp other#c.mfct_emp), absorb(a=sty)

* COMPUTE AVERAGE LONG HAUL ELASTICITY *
keep if lh == 1
gen elast = (1-share)*_b[wage]
sum elast if year == 2016
