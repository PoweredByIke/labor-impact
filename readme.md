# The Job Impacts of Automated Trucking
## Overview

An economic analysis of the potential effects on the trucking labor market from automated trucks. This analysis uses publicly-available historical data on demographics, employment, income, and other freight industry inputs, as well as hypothetical scenarios of cost, geographic coverage, and utilization of automated trucks over the next ten years, to estimate supply and demand curves and equilibrium employment for truck driving. The output of the analysis is an estimate of equilibrium employment in long haul and short haul in two year buckets from 2020 to 2030.

Summaries of the analysis can be found here:
 * Blog post: [How Automated Trucks Could Create Better Truck Driving Jobs](https://medium.com/ike-robotics/how-automated-trucks-could-create-better-truck-driving-jobs-e817b524c5fd)
 * Story map: [The Job Impact of Automated Trucks](https://www.ikerobotics.com/impact)

 Input and feedback, including pull requests, are welcome. 

 This analysis was developed by Dr. Charles Hodgson in a personal capacity as a consultant to Ike.

## 1: Data

Current Population Survey
The CPS data cannot be directly posted due to the data usage agreement. The CPS data that is used in this analysis can be freely downloaded from the Integrated Public Use Microdata Series website (https://cps.ipums.org/cps/)
Slight differences in results may occur due to changes in weights and reclassification of occupations that IPUMS updates to maintain data quality.

To obtain the data we use, download the "basic monthly data" for all month and year combinations from January 2000 through December 2016. The variables you will need to select (in addition to the preselected variables) include "union", "statefip", "earnwt", "occ2010", and "age". Documentation and codebooks are available from this website as well. Once the data is downloaded it should be converted to Stata format using the IPUMS-produced code and named cps_all.dta. It should be placed in the “/Elasticity Estimation/data” folder and the “Retirements/data” folder.

### Bureau of Labor Statistics Occupational Statistics

BLS data on occupational employment by state is available at https://www.bls.gov/oes/tables.htm. All state data files must be downloaded for each year from 2000 to 2016. These files should be converted into Stata .dta files with the same names as the .xls files supplied by the BLS.  These .dta files should be placed in the “/Elasticity Estimation/data” subdirectory.

Running occ_state_wage.do will then convert these files into ./data/wage_state_year_occdta. This is an input file used in the estimation described below.

### State Income Data

Data on state median incomes comes from the census. It can be downloaded here: http://www2.census.gov/programs-surveys/cps/tables/time-series/historical-income-households/h08.xls.

This excel file should be placed in the “/Elasticity Estimation/data/” subdirectory. Running state_median_incomes.do will then convert this file to ./data/state_incomes.dta, an input file for the estimation described below.


## 2: File Explanations/Instructions 

This section explains the file paths in the replication folder. There are three main folders corresponding to demand and supply estimation, retirements projections, and equilibrium jobs projections.
			
This code runs on Stata 15 (for .do files)

### 2.1: Demand and Supply Estimation

master_do_file.do
This file encompasses the three main .do files for estimating the union membership instrument (replication_union.do), and the demand (replication_demand.do) and supply (replication_labor_supply.do) specifications.

The union replication file generates statistics on union membership of workers within a state-year. This instrument is used in the estimation of the driver demand specification.

The demand specification do file estimates the elasticity of driver demand with respect to the wage rate using data on driver wages and employment at the state-year level. It estimates this parameter separately for long-haul and short-haul driving.

The supply specification do file estimates the elasticity of driver supply with respect to the wage rate using data on driver wages and employment at the state-year level.

### 2.2: Retirement Curve

Replication_retirement_curve.do creates projections of truck driver retirements until 2030 using data from the CPS. It also plots some diagrams highlighting the age distribution of working drivers and trends in retirement ages of drivers.


### 2.3: Running the Simulations
The estimated parameters are fed into simulation code, which projects equilibrium employment in the long-haul sectors for future years up to 2029 under different deployment scenarios.

compute_projections.do uses parameters set according to the estimated demand and supply estimates and generates projections for the number of long haul and short haul jobs and the number of automated trucks deployed under various scenarios. The file outputs a table called base_projections_raw.xlsx. A formatted version of this table can be found in base_projections.xlsx.
