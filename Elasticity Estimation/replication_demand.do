
clear all
set more off

*Long-Haul Elasticity
use "data/wage_state_year_occ.dta", clear
drop if substr(occ_code,4,4) == "0000"

*Generate total employment in each state-year
bysort st year: egen total_employment_state = sum(tot_emp)

*Keep desired long-haul trucking occupation and states
keep if occ_code == "53-3032"
drop if inlist(st,"PR","GU","VI","HI")

rename tot_emp total_employment_sector

keep st year total_employment_state a_mean total_employment_sector

*Generate "market shares" / insert state numbers for merging with other dataset
generate share_total_employment = total_employment_sector / total_employment_state
generate state = .
	replace state = 1 if st == "AL"
	replace state = 2 if st == "AK"
	replace state = 4 if st == "AZ"
	replace state = 5 if st == "AR"
	replace state = 6 if st == "CA"
	replace state = 8 if st == "CO"
	replace state = 9 if st == "CT"
	replace state = 10 if st == "DE"
	replace state = 11 if st == "DC"
	replace state = 12 if st == "FL"
	replace state = 13 if st == "GA"
	replace state = 15 if st == "HI"
	replace state = 16 if st == "ID"
	replace state = 17 if st == "IL"
	replace state = 18 if st == "IN"
	replace state = 19 if st == "IA"
	replace state = 20 if st == "KS"
	replace state = 21 if st == "KY"
	replace state = 22 if st == "LA"
	replace state = 23 if st == "ME"
	replace state = 24 if st == "MD"
	replace state = 25 if st == "MA"
	replace state = 26 if st == "MI"
	replace state = 27 if st == "MN"
	replace state = 28 if st == "MS"
	replace state = 29 if st == "MO"
	replace state = 30 if st == "MT"
	replace state = 31 if st == "NE"
	replace state = 32 if st == "NV"
	replace state = 33 if st == "NH"
	replace state = 34 if st == "NJ"
	replace state = 35 if st == "NM"
	replace state = 36 if st == "NY"
	replace state = 37 if st == "NC"
	replace state = 38 if st == "ND"
	replace state = 39 if st == "OH"
	replace state = 40 if st == "OK"
	replace state = 41 if st == "OR"
	replace state = 42 if st == "PA"
	replace state = 44 if st == "RI"
	replace state = 45 if st == "SC"
	replace state = 46 if st == "SD"
	replace state = 47 if st == "TN"
	replace state = 48 if st == "TX"
	replace state = 49 if st == "UT"
	replace state = 50 if st == "VT"
	replace state = 51 if st == "VA"
	replace state = 53 if st == "WA"
	replace state = 54 if st == "WV"
	replace state = 55 if st == "WI"
	replace state = 56 if st == "WY"
	drop if state == .

rename state state_id
*drop more recent years/incomplete years
drop if year == 2016 | year == 2000

*Merge in median incomes
merge 1:1 state_id year using "data/state_incomes.dta", keep(3) assert(2 3) nogenerate keepusing(median)

*Generate log shares and log wages for elasticities
generate log_share = log(share)
generate log_wage_foruse = log(a_mean)

rename state_id statefip
drop if year == 2016
*Merge in the union instrument
merge m:1 statefip year using "intermediate/cps_state_union_year.dta", nogenerate assert(2 3) keep(3)

*Need CPI to deflate incomes so they are all on the same monetary level
generate cpi = .
replace cpi = 1.37 if year == 2000
replace cpi = 1.34 if year == 2001
replace cpi = 1.32 if year == 2002
replace cpi = 1.29 if year == 2003
replace cpi = 1.25 if year == 2004
replace cpi = 1.21 if year == 2005
replace cpi = 1.17 if year == 2006
replace cpi = 1.14 if year == 2007
replace cpi = 1.10 if year == 2008
replace cpi = 1.10 if year == 2009
replace cpi = 1.09 if year == 2010
replace cpi = 1.05 if year == 2011
replace cpi = 1.03 if year == 2012
replace cpi = 1.02 if year == 2013
replace cpi = 1.00 if year == 2014
replace cpi = 1.00 if year == 2015
replace cpi = 0.99 if year == 2016
generate mediandeflated = median / cpi


ivregress 2sls log_share mediandeflated i.year  (log_wage_foruse = union), robust
regress log_wage_foruse union median i.year, robust
