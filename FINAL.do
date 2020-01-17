/*======================================================================
========================================================================
Econ7100-01 Project Evaluation

				      Final Class Project
						
			
========================================================================
======================================================================*/

clear all
set more off

cd "F:\00_Project Evaluation_Final Project"
use "Raw_BabyBook_Data.dta", clear

capture log close
log using "FinalProject_Group2", replace

*Install package 
ssc install estout

*=======================================================================
*1.What is the intervention about?
*  Explain the study design, sample size, recruitment place and methodology.
*  Write down the results chain.
*=======================================================================

*Remove the Family IDs which is not in the FamilyID_Only.csv
drop if AWFamID==1081|AWFamID==1121|AWFamID==1136|AWFamID==1142|AWFamID==1271| ///
		AWFamID==1299|AWFamID==1303|AWFamID==1335|AWFamID==1351|AWFamID==1358| ///
		AWFamID==1359|AWFamID==1385|AWFamID==1401|AWFamID==1414|AWFamID==1419| ///
		AWFamID==1420|AWFamID==1427|AWFamID==1431|AWFamID==1433|AWFamID==1437| ///
		AWFamID==1467|AWFamID==1468|AWFamID==1503|AWFamID==1517|AWFamID==1532| ///
		AWFamID==1563|AWFamID==1577|AWFamID==1618|AWFamID==1643|AWFamID==1675| ///
		AWFamID==1680

		
*Identify variables of interest in use and Label them
describe AWFamID //FamilyID
codebook AWFamID

describe A1MomAge //Mom's age
codebook A1MomAge

describe WaveSort //Wave sorting order
label define WaveSort_value 1 "baseline" 2 "2 months" 3 "4 months" 4 "6 months" ///
	5 "9 months" 6 "12 months" 7 "18 months"
label value WaveSort WaveSort_value
codebook WaveSort

describe StudyGrp //Study group (experimental condition)
label define StudyGrp_value	1 "Baby book" 2	"Commercial book" 3	"No book" 
label values StudyGrp StudyGrp_value
codebook StudyGrp

describe awpsits //PSI Total Stress score: [36-180]
describe awcess //CES summary score: [0-30]

describe AWBQ02 //Mom's race/ethnicity
label define AWBQ02_value 1 "Afr. Amer./Black" 2 "Amer. Ind./AK Natv" 3 "Asian" ///
	4 "Caucasian/White" 5 "Ntv HI/Oth Pac Isl" 6 "Other" 7 "Skip"
label values AWBQ02 AWBQ02_value
codebook AWBQ02

describe AWBQ04 //Education: Highest grade completed in school
codebook AWBQ04

describe AWBQ05 //Current Maternal Health
label define AWBQ05_value 1 "Excellent" 2 "Very good" 3 "Good" 4 "Fair" 5 "Poor"
label values AWBQ05 AWBQ05_value
codebook AWBQ05

describe AWBQ06 //Current Maternal Status
label define AWBQ06_value 0 "Never married/ single" 1 "Now married" ///
	2 "Living as married" 3 "Widowed" 4 "Divorced" 5 "Separated"
label values AWBQ06 AWBQ06_value 
codebook AWBQ06 

describe AWBQ07 //Do you live alone?
codebook AWBQ07

describe AWBQ07S1 //Other adult in home
codebook AWBQ07S1

describe AWBQ09 //Current employment situation
label define AWBQ09_value 1 "Full-time job" 2 "Part-time job" ///
	3 "Working in home not for pay" 4 "Unemployed" 7 "Disabled/not working" ///
	8 "Other" 9 "Both full & part-time job"
label values AWBQ09 AWBQ09_value
codebook AWBQ09

describe AWBQ17 //Family Income: How much $ did your family make last yr
label define AWBQ17_value	1 "Less than $8,000" 2	"$8,000 - $12,000" ///
	3 "$12,001 - $16,000" 4 "$16,001 - $21,000" 5 "$21,001 - $26,000" ///
	6 "$26,001 - $30,000" 7 "$30,001 - $40,000" 8 "$40,001 - $50,000" 9 "over $50,000"
label values AWBQ17 AWBQ17_value
codebook AWBQ17

describe AWBQ18 //Mom receives public assistance: 1=y, 0=n
codebook AWBQ18

describe AWBQ19 //Financially dependent: On whom does family financially depend
label define AWBQ19_value 1 "Mostly on you" 2 "Equally on you & other person" ///
	3 "Mostly on someone else" 4 "Other"
label values AWBQ19 AWBQ19_value
codebook AWBQ19

describe AWBQ21a //Current tobacco use: cigarettes
codebook AWBQ21a

describe AWBQ26 //Currently, do you drink alcohol?
codebook AWBQ26

describe AWBQ40P //Parenting class now or prev.?	
codebook AWBQ40P

		
*Create new variable for babyage(in months) to check when was the stress and depression questionnaires were asked
gen babymonths = round(AWBAgeD/365*12)
replace babymonths = 0 if WaveSor==1
label var babymonths "Baby age in the unit of months"
order AWFamID StudyGrp WaveSort AWBAgeD babymonths
//WaveSort_value 1 "baseline" 2 "2 months" 3 "4 months" 4 "6 months" 5 "9 months" 6 "12 months" 7 "18 months"
sort babymonths WaveSort AWFamID

*Remove the Family IDs which have miss-matched variables between WaveSort and babymonths
keep if WaveSort==1&babymonths==0|WaveSort==2&babymonths==2|WaveSort==3&babymonths==4|WaveSort==4&babymonths==6|WaveSort==5&babymonths==9|WaveSort==6&babymonths==12|WaveSort==7&babymonths==18

*Create new variable in order to compare/analyse characteristics between groups
gen AWBQ02_bi = 1 if AWBQ02==4
replace AWBQ02_bi = 0 if AWBQ02==1|AWBQ02==2|AWBQ02==3|AWBQ02==5|AWBQ02==6
replace AWBQ02_bi = . if AWBQ02==7
label var AWBQ02_bi "Ethnicity, 1 for White, 0 Otherwise"
codebook AWBQ02 AWBQ02_bi

gen AWBQ06_bi = 1 if AWBQ06==1|AWBQ06==2
replace AWBQ06_bi = 0 if AWBQ06==0|AWBQ06==3|AWBQ06==4|AWBQ06==5
label var AWBQ06_bi "Marriage, 1 for Married, 0 Otherwise"
codebook AWBQ06 AWBQ06_bi

gen AWBQ19_bi = 1 if AWBQ19==1|AWBQ19==2
replace AWBQ19_bi = 0 if AWBQ19==3|AWBQ19==4
label var AWBQ19_bi "Financial Resources, 1 Mostly from mother or Equally from mother, 0 Other person"
codebook AWBQ19 AWBQ19_bi

*Define global variables
global keyvars AWFamID StudyGrp WaveSort AWBAgeD babymonths PartStat
global outcomes awpsits awcess
global controls A1MomAge AWBQ02 AWBQ02_bi AWBQ04 AWBQ05 AWBQ06 AWBQ06_bi AWBQ07 AWBQ07S1 AWBQ09 ///
	AWBQ17 AWBQ18 AWBQ19 AWBQ19_bi AWBQ21a AWBQ26 AWBQ40P
describe $keyvars $outcomes $controls

*Number of Obs and participants by each group
codebook AWFamID
egen AWFamID_tag = tag(AWFamID)
tab StudyGrp if AWFamID_tag==1
*Create table
#delimit;
eststo clear;
eststo: estpost tab StudyGrp if AWFamID_tag==1;
esttab using "Table-1_Sample size by treatment and control group.csv", replace
	cells("b(label(Count)) pct(fmt(2) label(Percent))")
	title(Sample size by treatment and control group)
	nomtitles nonumbers noobs;
eststo clear;
#delimit cr

*=======================================================================
*2.At baseline, describe the characteristics of each group.
*  Does the intervention have a valid counterfactual?
*  Explain why this step is important.
*=======================================================================

count if WaveSort==1 & babymonths!=0

*1)Compare the characteristics between babaybook and else at baseline
*Define new variables for babaybook and else
gen intv_Babybook = 1 if StudyGrp==1
replace intv_Babybook = 0 if StudyGrp==2|StudyGrp==3

*Number of Obs by babaybook and else
tab intv_Babybook if AWFamID_tag==1

*Characteristics by babaybook and else at baseline
preserve
keep if babymonths == 0
bys intv_Babybook: su awcess $controls
foreach var of varlist awcess $controls {
	de `var'
	ttest `var', by(intv_Babybook)
}
*Create table
#delimit;
eststo clear;
bys intv_Babybook: eststo: estpost su awcess $controls;
eststo: estpost ttest awcess $controls, by(intv_Babybook);
esttab using "Table-2_Characteristics between Babybook and Else at Baseline.csv", replace
	cells("mean(fmt(2) label(Mean) pattern(1 1 0)) b(fmt(2) label(Diff.) pattern(0 0 1)) p(fmt(4) label(p-value) pattern(0 0 1))")
	title(Characteristics btw Babybook & Else at Baseline)
	mtitles("Else" "Babybook" "t-test")
	nonumbers noobs;
eststo clear;
#delimit cr
restore

*2)Compare the characteristics between commercialbook and else
*Define new variables for commercialbook and else
gen intv_Commercialbook = 1 if StudyGrp==2
replace intv_Commercialbook = 0 if StudyGrp==1|StudyGrp==3

*Number of Obs by commercialbook and else
tab intv_Commercialbook if AWFamID_tag==1

*Characteristics by commercialbook and else at baseline
preserve
keep if babymonths == 0
bys intv_Commercialbook: su awcess $controls
foreach var of varlist awcess $controls {
	de `var'
	ttest `var', by(intv_Commercialbook)
}
*Create table
#delimit;
eststo clear;
bys intv_Commercialbook: eststo: estpost su awcess $controls;
eststo: estpost ttest awcess $controls, by(intv_Commercialbook);
esttab using "Table-3_Characteristics between Commercial and Else at Baseline.csv", replace
	cells("mean(fmt(2) label(Mean) pattern(1 1 0)) b(fmt(2) label(Diff.) pattern(0 0 1)) p(fmt(4) label(p-value) pattern(0 0 1))")
	title(Characteristics btw Commercialbook & Else at Baseline)
	mtitles("Else" "Commercialbook" "t-test")
	nonumbers noobs;
eststo clear;
#delimit cr
restore

*3)Compare the characteristics between nobook and else
*Define new variables for nobook and else
gen intv_Nobook = 1 if StudyGrp==3
replace intv_Nobook = 0 if StudyGrp==1|StudyGrp==2

*Number of Obs by nobook group and else
tab intv_Nobook if AWFamID_tag==1

*Characteristics by commercialbook and else at baseline
preserve
keep if babymonths == 0
bys intv_Nobook: su awcess $controls
foreach var of varlist awcess $controls {
	de `var'
	ttest `var', by(intv_Nobook)
}
*Create table
#delimit;
eststo clear;
bys intv_Nobook: eststo: estpost su awcess $controls;
eststo: estpost ttest awcess $controls, by(intv_Nobook);
esttab using "Table-4_Characteristics between Nobook and Else at Baseline.csv", replace
	cells("mean(fmt(2) label(Mean) pattern(1 1 0)) b(fmt(2) label(Diff.) pattern(0 0 1)) p(fmt(4) label(p-value) pattern(0 0 1))")
	title(Characteristics btw Nobook & Else at Baseline)
	mtitles("Else" "Nobook" "t-test")
	nonumbers noobs;
eststo clear;
#delimit cr
restore

*=======================================================================
*3.Estimate the coutcome by subject, group, and time.
*a.Identify all the variables and create two final dataset.
*  1)A wide cross-sectional dataset including individual information and
*    time fixed variables at baseline
*  2)A panal dataset including all time variant variables at base line 
*    and 2, 6, 9, 12, and 18 months.
*b.Determine the participation rates by group at 2, 6, 9, 12, and 18 months.
*  Explain concerns or strengths in terms of the internal and external valididy
*=======================================================================

*Keep the variables of interest which is used in analysis
keep $keyvars $outcomes $controls

*a-1) Make the wide cross-sectional dataset
preserve
keep if babymonths == 0
save "WideCrossSection.dta",replace
restore

*a-2) Making the Panel dataset
*Only use the variable the time matches between WaveSort and babymonths
preserve
keep if WaveSort==1&babymonths==0|WaveSort==2&babymonths==2|WaveSort==3&babymonths==4|WaveSort==4&babymonths==6|WaveSort==5&babymonths==9|WaveSort==6&babymonths==12|WaveSort==7&babymonths==18
save "PanelData.dta",replace
restore

*b)Determine the participation rates by group at 0, 2, 4, 6, 9, 12, and 18 months
*Calculate the participation rates
preserve
keep if WaveSort==1&babymonths==0|WaveSort==2&babymonths==2|WaveSort==3&babymonths==4|WaveSort==4&babymonths==6|WaveSort==5&babymonths==9|WaveSort==6&babymonths==12|WaveSort==7&babymonths==18
bys babymonths: tab StudyGrp
*Create table
#delimit;
eststo clear;
bys babymonths: eststo: estpost tab StudyGrp;
esttab using "Table-5_Participation Rates of Each Group by Months.csv", replace
	cells("b(label(Count))pct(fmt(2) label(Percent))")
	title(Participation Rates of Each Group by Months)
	nomtitles nonumbers noobs;
eststo clear;
#delimit cr
restore

log close
