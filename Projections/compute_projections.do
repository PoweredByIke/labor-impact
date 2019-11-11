******************************************************************
* THIS FILE COMPUTES FORWARD PROJECTIONS OF LABOR MARKET EFFECTS *
******************************************************************

clear all
set more off

* SET PARAMETERS *
local demand_elasticity = -3.657
local supply_elasticity = 2.7
local annual_miles = 89804
local sh_multiplier = 0.4
local max_miles = 481800

* BAND 1
local utilization = 0.3
local cost = -5
local year = 2023

use future_miles, clear
keep if year == `year'
local baseline_miles = total_miles1[1]
use future_miles, clear
keep if year == 2017
local 2017_miles = total_miles1[1]

local cf_supply = `baseline_miles'*(`cost'*`supply_elasticity' + 100)/100
local cf_demand = `baseline_miles'*(`cost'*`demand_elasticity' + 100)/100
local cf_robot = `cf_demand' - `cf_supply'

use distributions, clear
gen trips = `cf_robot'*dist_band1/distance
collapse (sum) trips
local robot_trips = trips[1]
local sh_miles = `robot_trips'*50

mat col1 = 1 \ `utilization' \ `cost' \ `baseline_miles' - `cf_supply' \ `sh_miles' \ `baseline_miles'/`annual_miles'
mat col1 = col1 \ `cf_robot' - `sh_miles' \ (`baseline_miles' - `cf_supply')/`annual_miles' \ `sh_miles' /(`annual_miles'*`sh_multiplier')
mat col1 = col1 \ 100*(`sh_miles' /(`annual_miles'*`sh_multiplier'))/((`baseline_miles' - `cf_supply')/`annual_miles') \  (`cf_robot' - `sh_miles')/(`max_miles'*`utilization')
mat col1 = col1 \ `cf_demand' \ `cf_demand' - `baseline_miles'
mat col1 = col1 \ `2017_miles'/`annual_miles' \ (`sh_miles' + `cf_supply')/`annual_miles'

matlist col1



* BAND 2
local utilization = 0.4
local cost = -8
local year = 2025

use future_miles, clear
keep if year == `year'
local baseline_miles = total_miles2[1]
use future_miles, clear
keep if year == 2017
local 2017_miles = total_miles2[1]

local cf_supply = `baseline_miles'*(`cost'*`supply_elasticity' + 100)/100
local cf_demand = `baseline_miles'*(`cost'*`demand_elasticity' + 100)/100
local cf_robot = `cf_demand' - `cf_supply'

use distributions, clear
gen trips = `cf_robot'*dist_band2/distance
collapse (sum) trips
local robot_trips = trips[1]
local sh_miles = `robot_trips'*50

mat col2 = 2 \ `utilization' \ `cost' \ `baseline_miles' - `cf_supply' \ `sh_miles' \ `baseline_miles'/`annual_miles'
mat col2 = col2 \ `cf_robot' - `sh_miles' \ (`baseline_miles' - `cf_supply')/`annual_miles' \ `sh_miles' /(`annual_miles'*`sh_multiplier')
mat col2 = col2 \ 100*(`sh_miles' /(`annual_miles'*`sh_multiplier'))/((`baseline_miles' - `cf_supply')/`annual_miles') \  (`cf_robot' - `sh_miles')/(`max_miles'*`utilization')
mat col2 = col2 \ `cf_demand' \ `cf_demand' - `baseline_miles'
mat col2 = col2 \ `2017_miles'/`annual_miles' \ (`sh_miles' + `cf_supply')/`annual_miles'

matlist col2



* BAND 3
local utilization = 0.5
local cost = -12
local year = 2027

use future_miles, clear
keep if year == `year'
local baseline_miles = total_miles3[1]
use future_miles, clear
keep if year == 2017
local 2017_miles = total_miles3[1]

local cf_supply = `baseline_miles'*(`cost'*`supply_elasticity' + 100)/100
local cf_demand = `baseline_miles'*(`cost'*`demand_elasticity' + 100)/100
local cf_robot = `cf_demand' - `cf_supply'

use distributions, clear
gen trips = `cf_robot'*dist_band3/distance
collapse (sum) trips
local robot_trips = trips[1]
local sh_miles = `robot_trips'*50

mat col3 = 3 \ `utilization' \ `cost' \ `baseline_miles' - `cf_supply' \ `sh_miles' \ `baseline_miles'/`annual_miles'
mat col3 = col3 \ `cf_robot' - `sh_miles' \ (`baseline_miles' - `cf_supply')/`annual_miles' \ `sh_miles' /(`annual_miles'*`sh_multiplier')
mat col3 = col3 \ 100*(`sh_miles' /(`annual_miles'*`sh_multiplier'))/((`baseline_miles' - `cf_supply')/`annual_miles') \  (`cf_robot' - `sh_miles')/(`max_miles'*`utilization')
mat col3 = col3 \ `cf_demand' \ `cf_demand' - `baseline_miles'
mat col3 = col3 \ `2017_miles'/`annual_miles' \ (`sh_miles' + `cf_supply')/`annual_miles'

matlist col3



* BAND 4
local utilization = 0.6
local cost = -15
local year = 2029

use future_miles, clear
keep if year == `year'
local baseline_miles = total_miles4[1]
use future_miles, clear
keep if year == 2017
local 2017_miles = total_miles4[1]

local cf_supply = `baseline_miles'*(`cost'*`supply_elasticity' + 100)/100
local cf_demand = `baseline_miles'*(`cost'*`demand_elasticity' + 100)/100
local cf_robot = `cf_demand' - `cf_supply'

use distributions, clear
gen trips = `cf_robot'*dist_band4/distance
collapse (sum) trips
local robot_trips = trips[1]
local sh_miles = `robot_trips'*50

mat col4 = 4 \ `utilization' \ `cost' \ `baseline_miles' - `cf_supply' \ `sh_miles' \ `baseline_miles'/`annual_miles'
mat col4 = col4 \ `cf_robot' - `sh_miles' \ (`baseline_miles' - `cf_supply')/`annual_miles' \ `sh_miles' /(`annual_miles'*`sh_multiplier')
mat col4 = col4 \ 100*(`sh_miles' /(`annual_miles'*`sh_multiplier'))/((`baseline_miles' - `cf_supply')/`annual_miles') \  (`cf_robot' - `sh_miles')/(`max_miles'*`utilization')
mat col4 = col4 \ `cf_demand' \ `cf_demand' - `baseline_miles'
mat col4 = col4 \ `2017_miles'/`annual_miles' \ (`sh_miles' + `cf_supply')/`annual_miles'

matlist col4


mat out = col1, col2, col3, col4
putexcel set "base_projections_raw.xlsx", replace
putexcel A1=matrix(out)

