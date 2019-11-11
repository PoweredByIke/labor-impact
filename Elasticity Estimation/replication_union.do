
clear all
set more off

*Open CPS data
use "data/cps_all.dta"
tabulate union, generate(union_status_)

*Label union status variables
label variable union_status_1 "Not in Universe"
label variable union_status_2 "No union coverage"
label variable union_status_3 "Member of labor union"
label variable union_status_4 "Covered by union but not a member"

*Use the earnings weights (recommended for union variable) from CPS
*Weights should help the CPS population better approximate actual population
generate earn_weight_recip = 1/earnwt

*Calculate number unionized (in union or covered by union in a state-year)
*Note we ignore union_status_1 since these people aren't in the universe asked this question

collapse union_status_* [pweight = earn_weight_recip], by(year state)
generate union = (union_status_3 + union_status_4) / (union_status_2 + union_status_3 + union_status_4)
keep year statefip union

save "intermediate/cps_state_union_year.dta", replace
