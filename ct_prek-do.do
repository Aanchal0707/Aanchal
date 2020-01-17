clear
set more off
use "C:\Users\aanch\Desktop\Prof. Shaun\Full New Master 2019.dta" 

*reshaping the data from long to wide
drop if f_s ==.
drop in 1393
reshape wide sex round iep racenumber pdg_any ol_c pv_ss oc_ss br_c math_c lwid_ss ap_ss calc_ss wa_ss trs_basc3_asi_t trs_basc3_bsi_t trs_basc3_epi_t trs_basc3_ipi_t prs_basc3_asi_t prs_basc3_bsi_t prs_basc3_epi_t prs_basc3_ipi_t funding hispanic fundingtype spacetype hsehsa oecfeeschedule care4kids noaddlfunding fundingtypenum spacetypenum pdg_fed pdg_state , i(id) j(f_s)

*Cleaning of the data by dropping some variables
drop if round1 ==2
drop if round2 == 1
drop funding1 funding2
drop if ol_c1 ==888
drop if ol_c2 ==888
drop if pv_ss2 ==888
drop if pv_ss2 ==888
drop if sex1 ==2

*generating one variable for PDG funding combining the spring and fall results 
egen pdg_funding = rowmax ( pdg_any1 pdg_any2)

*Generating one variable for round combining fall and spring results
gen round =.
replace round =1 if round1 ==1
replace round =2 if round2 ==2
replace round =3 if round1 ==3 & round2 ==3
replace round =4 if round1 ==4
replace round =5 if round2 ==5
replace round =6 if round1 ==6 & round2 ==6
replace round =7 if round1 ==7
replace round =8 if round2 ==8
replace round =9 if round1 ==9 & round2 ==9

*This variable is only for rounds 3,6 and 9 which is assessed only in fall and spring
gen round_369 =.
replace round_369 =3 if round1 ==3 & round2 ==3
replace round_369 =6 if round1 ==6 & round2 ==6
replace round_369 =9 if round1 ==9 & round2 ==9

*generating one variable for sex combining with fall and spring
gen sex =.
replace sex = 0 if sex1 ==0 & sex2 ==0
replace sex = 1 if sex1 ==1 & sex2 ==1
replace sex =1 if sex1 ==. & sex2 ==1
replace sex =0 if sex1 ==. & sex2 ==0
replace sex =0 if sex1 ==0 & sex2 ==.
replace sex =1 if sex1 ==1 & sex2 ==.


*These variables are string varibales, hence encoding them to be in numeric form
encode ecis_white, gen(white)
encode ecis_amindianoralask , gen(americanindian)
encode ecis_black , gen(black)
encode ecis_hawaiianorpacificisl , gen(hawaiian)
encode ecis_asian, gen(asian)
encode ecis_ethnicity, gen(ec_eth)
encode hispanic1, gen(hisp1)
encode hispanic2, gen(hisp2)
encode fundingtype1, gen(funding1)
encode fundingtype2, gen(funding2)

*Generating one variable for all the races
gen racenumber =.
replace racenumber =0 if racenumber1 ==0 & racenumber2 ==0
replace racenumber =1 if racenumber1 ==1 & racenumber2 ==1
replace racenumber =2 if racenumber1 ==2 & racenumber2 ==2
replace racenumber =3 if racenumber1 ==3 & racenumber2 ==3
replace racenumber =4 if racenumber1 ==4 & racenumber2 ==4
replace racenumber =5 if racenumber1 ==5 & racenumber2 ==5
replace racenumber =0 if (racenumber1 ==. & racenumber2 ==0) | (racenumber1 ==0 & racenumber2 ==.)
replace racenumber =1 if (racenumber1 ==. & racenumber2 ==1) | (racenumber1 ==1 & racenumber2 ==.)
replace racenumber =2 if (racenumber1 ==. & racenumber2 ==2) | (racenumber1 ==2 & racenumber2 ==.)
replace racenumber =3 if (racenumber1 ==. & racenumber2 ==3) | (racenumber1 ==3 & racenumber2 ==.)
replace racenumber =4 if (racenumber1 ==. & racenumber2 ==4) | (racenumber1 ==4 & racenumber2 ==.)
replace racenumber =5 if (racenumber1 ==. & racenumber2 ==5) | (racenumber1 ==5 & racenumber2 ==.)
replace racenumber = 1 if (white ==1 & black ==1 & americanindian==2 & hawaiian ==1 & asian ==1)
replace racenumber = 2 if (white ==1 & black ==1 & americanindian==1 & hawaiian ==1 & asian ==2)
replace racenumber = 3 if (white ==1 & black ==2 & americanindian==1 & hawaiian ==1 & asian ==1)
replace racenumber = 4 if (white ==1 & black ==1 & americanindian==1 & hawaiian ==2 & asian ==1)
tab racenumber, mis
label define race 0 "white" 1 "American Indian or Native American" 2 "Asian" 3" Black or African American" 4 " Hawaiian" 5 "Mixed Race"
label values racenumber race


*Generating one varaible for ethnicity_Hispanic or Not hispanic
gen ethnic =.
replace ethnic = 1 if (ethnicity ==1 | hisp1 ==3 | hisp2 ==3 | ec_eth ==2)
replace ethnic = 0 if (ethnicity ==0 | hisp1 ==2 | hisp2 ==2 | ec_eth ==1)
tab ethnic, mis

*Generating one variabtale for funding type and then labeling the variable
gen fundingtype =.
replace fundingtype = 2 if (funding1 ==2 & funding2 ==2)
replace fundingtype = 3 if (funding1 ==3 & funding2 ==3)
replace fundingtype = 4 if (funding1 ==4 & funding2 ==4)
replace fundingtype = 5 if (funding1 ==5 & funding2 ==5)
replace fundingtype = 6 if (funding1 ==6 & funding2 ==6)
replace fundingtype = 7 if (funding1 ==7 & funding2 ==7)
replace fundingtype = 8 if (funding1 ==8 & funding2 ==8)
replace fundingtype = 9 if (funding1 ==9 & funding2 ==9)
replace fundingtype = 10 if (funding1 ==10 & funding2 ==10)
replace fundingtype = 11 if (funding1 ==11 & funding2 ==11)
replace fundingtype = 12 if (funding1 ==12 & funding2 ==12)
replace fundingtype = 2 if (funding1 ==2 & funding2 ==.) | (funding1 ==. & funding2 ==2)
replace fundingtype = 3 if (funding1 ==3 & funding2 ==.) | (funding1 ==. & funding2 ==3)
replace fundingtype = 4 if (funding1 ==4 & funding2 ==.) | (funding1 ==. & funding2 ==4)
replace fundingtype = 5 if (funding1 ==5 & funding2 ==.) | (funding1 ==. & funding2 ==5)
replace fundingtype = 6 if (funding1 ==6 & funding2 ==.) | (funding1 ==. & funding2 ==6)
replace fundingtype = 7 if (funding1 ==7 & funding2 ==.) | (funding1 ==. & funding2 ==7)
replace fundingtype = 8 if (funding1 ==8 & funding2 ==.) | (funding1 ==. & funding2 ==8)
replace fundingtype = 9 if (funding1 ==9 & funding2 ==.) | (funding1 ==. & funding2 ==9)
replace fundingtype = 10 if (funding1 ==10 & funding2 ==.) | (funding1 ==. & funding2 ==10)
replace fundingtype = 11 if (funding1 ==11 & funding2 ==.) | (funding1 ==. & funding2 ==11)
replace fundingtype = 12 if (funding1 ==12 & funding2 ==.) | (funding1 ==. & funding2 ==12)
replace fundingtype = 2 if (funding1 ==2 & funding2 ==1) | (funding1 ==1 & funding2 ==2)
replace fundingtype = 3 if (funding1 ==3 & funding2 ==1) | (funding1 ==1 & funding2 ==3)
replace fundingtype = 4 if (funding1 ==4 & funding2 ==1) | (funding1 ==1 & funding2 ==4)
replace fundingtype = 5 if (funding1 ==5 & funding2 ==1) | (funding1 ==1 & funding2 ==5)
replace fundingtype = 6 if (funding1 ==6 & funding2 ==1) | (funding1 ==1 & funding2 ==6)
replace fundingtype = 7 if (funding1 ==7 & funding2 ==1) | (funding1 ==1 & funding2 ==7)
replace fundingtype = 8 if (funding1 ==8 & funding2 ==1) | (funding1 ==1 & funding2 ==8)
replace fundingtype = 9 if (funding1 ==9 & funding2 ==1) | (funding1 ==1 & funding2 ==9)
replace fundingtype = 10 if (funding1 ==10 & funding2 ==1) | (funding1 ==1 & funding2 ==10)
replace fundingtype = 11 if (funding1 ==11 & funding2 ==1) | (funding1 ==1 & funding2 ==11)
replace fundingtype = 12 if (funding1 ==12 & funding2 ==1) | (funding1 ==1 & funding2 ==12)
label define fund 2 "Child Day Care" 3 " Head Start- State Supplement" 4 "Head Start/Early Head Start" 5 "PDG-Federal" 6 "PDG-State" 7 "Private Pay" 8 "School Readiness Competitive" 9 "School Readiness Priority" 10"School Readiness – Competitive" 11 "School Readiness – Priority" 12 "Smart Start (SS)"
label values fundingtype fund


**************************************************************************************************************************************************
*generating variables for different race
gen whiterace =.
replace whiterace =1 if (racenumber ==0 | white ==2)

gen americanindianrace =.
replace americanindianrace =1 if (racenumber ==1 | americanindian ==2)

gen asianrace =.
replace asianrace =1 if (racenumber ==2 | asian ==2)

gen blackrace =.
replace blackrace =1 if (racenumber ==3 | black ==2)

gen hawaiianrace =.
replace hawaiianrace =1 if (racenumber ==4 | hawaiian ==2)

gen mixedrace =.
replace mixedrace =1 if racenumber ==5

***************************************************************************************************************************************************
*********VARIBLES FROM MISSING FLAG**************************************************

***** Variable for sex
gen missingsex = missing(sex)
replace sex =0 if sex ==.

**********variables for racenumber
gen missingwhite = missing(whiterace)
replace whiterace =0 if whiterace ==.

gen missingasian = missing(asianrace)
replace asianrace =0 if asianrace ==.

gen missingamericanindian = missing(americanindianrace)
replace americanindianrace =0 if americanindianrace ==.

gen missingblack = missing(blackrace)
replace blackrace =0 if blackrace ==.

gen missinghawaiian = missing(hawaiianrace)
replace hawaiianrace =0 if hawaiianrace ==.

gen missingmixedrace = missing(mixedrace)
replace mixedrace =0 if mixedrace ==.

***************variables for Ethnicity
gen missingethnic = missing(ethnic)
replace ethnic =0 if ethnic ==.

***************variable for PDG Funding
gen missingpdg = missing(pdg_funding)
replace pdg_funding =0 if pdg_funding ==.

******************************FUNDINGTYPE********************************************
gen missingfunding = missing(fundingtype)
tab missingfunding
replace fundingtype =0 if fundingtype ==.

*********************Different fundingtypes
gen childcare =.
replace childcare =1 if fundingtype ==2

gen headstart =.
replace headstart =1 if fundingtype ==3

gen headstartearly =.
replace headstartearly =1 if fundingtype ==4

gen pdgfederal =.
replace pdgfederal =1 if fundingtype ==5

gen pdgstate =.
replace pdgstate =1 if fundingtype ==6

gen privatepay =.
replace privatepay =1 if fundingtype ==7

gen schoolreadinesscompetitive =.
replace schoolreadinesscompetitive =1 if (fundingtype ==8 | fundingtype ==10)

gen schoolreadinesspriority =.
replace schoolreadinesspriority =1 if (fundingtype ==9 | fundingtype ==11)

gen smartstart =.
replace smartstart =1 if fundingtype ==12

*****************MissingFlags****************************************************
gen missingchildcare = missing(childcare)
replace childcare =0 if childcare ==.

gen missingheadstart = missing(headstart)
replace headstart =0 if headstart ==.

gen missingheadstartearly = missing(headstartearly)
replace headstartearly =0 if headstartearly ==.

gen missingpdgfederal = missing(pdgfederal)
replace pdgfederal =0 if pdgfederal ==.

gen missingpdgstate = missing(pdgstate)
replace pdgstate =0 if pdgstate ==.

gen missingprivatepay = missing(privatepay)
replace privatepay =0 if privatepay ==.

gen missingschoolreadinesscomp = missing(schoolreadinesscompetitive)
replace schoolreadinesscompetitive =0 if schoolreadinesscompetitive ==.

gen missingschoolreadinessprio = missing(schoolreadinesspriority)
replace schoolreadinesspriority =0 if schoolreadinesspriority ==.

gen missingsmartstart = missing(smartstart)
replace smartstart =0 if smartstart==.

save "C:\Users\aanch\Desktop\Prof. Shaun\ct_prek_clean.dta"

*********************************************************************************************************
*Overall descriptive statistics by year, rounds-3,6,9 and site
*******************************TABLES IN THE BOX FOLDER*********************************************
global list1 sex ethnic pdg_funding whiterace asianrace americanindianrace blackrace hawaiianrace mixedrace ///
missingwhite missingasian missingamericanindian missingblack missinghawaiian missingmixed missingethnic missingsex missingpdg

asdoc tabstat $list1, by(year) stat(N mean sd)
asdoc tabstat $list1, by(round_369) stat(N mean sd)
asdoc tabstat $list1, by(site) stat(N mean sd)


*******************************************************************************************************
***************************************BASC SCORES****************************************************************************************************************
*DESCRIPTIVE STATISTICS OF BASC SCORES- ADAPTIVE SKILLS by year and round-3,6,9
global list2 trs_basc3_asi_t1 prs_basc3_asi_t1 trs_basc3_asi_t2 prs_basc3_asi_t2
asdoc tabstat $list2, by(year) stat(N mean)
asdoc tabstat $list2, by(round_369) stat(N mean)


*DESCRIPTIVE STASTICS OF BASC SCORES- BEHAVIORAL SYMPTOMS
global list3 trs_basc3_bsi_t1 prs_basc3_bsi_t1 trs_basc3_bsi_t2 prs_basc3_bsi_t2
asdoc tabstat $list3, by(year) stat(N mean)
asdoc tabstat $list3, by(round_369) stat(N mean)


*DESCRIPTIVE STASTICS OF BASC SCORES- EXTERNALIZING PROBLEMS by year and round-3,6,9
global list4 trs_basc3_epi_t1 prs_basc3_epi_t1 trs_basc3_epi_t2 prs_basc3_epi_t2
asdoc tabstat $list4, by(year) stat(N mean)
asdoc tabstat $list4, by(round_369) stat(N mean)


*DESCRIPTIVE STASTICS OF BASC SCORES- INTERNALIZING PROBLEMS by year and round-3,6,9
global list5 trs_basc3_ipi_t1 prs_basc3_ipi_t1 trs_basc3_ipi_t2 prs_basc3_ipi_t2
asdoc tabstat $list5, by(year) stat(N mean)
asdoc tabstat $list5, by(round_369) stat(N mean)

***********************************************************************************************************************************************
******************************************************************************************************


*DESCRIPTIVE STASTICS of fall scores by year and round-3,6,9
global list6 ol_c1 pv_ss1 oc_ss1 br_c1 math_c1 lwid_ss1 ap_ss1 calc_ss1 wa_ss1
asdoc tabstat $list6, by(year) stat(N mean)
asdoc tabstat $list6, by(round_369) stat(N mean)

*Descriptive statistics of spring scores by year and round-3,6,9
global list7 ol_c2 pv_ss2 oc_ss2 br_c2 math_c2 lwid_ss2 ap_ss2 calc_ss2 wa_ss2
asdoc tabstat $list7, by(year) stat(N mean)
asdoc tabstat $list7, by(round_369) stat(N mean)

**************************************************************************************************
***************************************************************************************************************************************************
*Descriptive across years by site
estpost tabstat pdg_funding missingpdg sex missingsex ethnic missingethnic whiterace missingwhite americanindianrace missingamericanindian asianrace missingasian blackrace missingblack hawaiianrace missinghawaiian mixedrace missingmixed if year == 1, by(site) stat(N mean)

estpost tabstat pdg_funding missingpdg sex missingsex ethnic missingethnic whiterace missingwhite americanindianrace missingamericanindian asianrace missingasian blackrace missingblack hawaiianrace missinghawaiian mixedrace missingmixed if year == 2, by(site) stat(N mean)

estpost tabstat pdg_funding missingpdg sex missingsex ethnic missingethnic whiterace missingwhite americanindianrace missingamericanindian asianrace missingasian blackrace missingblack hawaiianrace missinghawaiian mixedrace missingmixed if year == 3, by(site) stat(N mean)

*Descriptive statistics of BASC Scores across years by site

global var1 trs_basc3_asi_t1 prs_basc3_asi_t1 trs_basc3_asi_t2 prs_basc3_asi_t2 ///
trs_basc3_bsi_t1 prs_basc3_bsi_t1 trs_basc3_bsi_t2 prs_basc3_bsi_t2 trs_basc3_epi_t1 ///
prs_basc3_epi_t1 trs_basc3_epi_t2 prs_basc3_epi_t2 trs_basc3_ipi_t1 prs_basc3_ipi_t1 ///
prs_basc3_ipi_t2 trs_basc3_ipi_t2

estpost tabstat $var1 if year ==1, by(site) stat(n mean)
estpost tabstat $var1 if year ==2, by(site) stat(n mean)
estpost tabstat $var1 if year ==3, by(site) stat(n mean)

*Descriptive statistics of fall scores across years by site
global var2 ol_c1 pv_ss1 oc_ss1 br_c1 math_c1 lwid_ss1 ap_ss1 calc_ss1 wa_ss1
estpost tabstat $var2 if year ==1, by(site) stat(n mean)
estpost tabstat $var2 if year ==2, by(site) stat(n mean)
estpost tabstat $var2 if year ==3, by(site) stat(n mean)

**Descriptive statistics of spring scores across site by year
global var3 ol_c2 pv_ss2 oc_ss2 br_c2 math_c2 lwid_ss2 ap_ss2 calc_ss2 wa_ss2
estpost tabstat $var3 if year ==1, by(site) stat(n mean)
estpost tabstat $var3 if year ==2, by(site) stat(n mean)
estpost tabstat $var3 if year ==3, by(site) stat(n mean)

****************************************************************************************
**********************************************Fundingtype*****************************
global list childcare headstart headstartearly pdgfederal pdgstate privatepay ///
schoolreadinesscompetitive schoolreadinesspriority smartstart missingchildcare ///
missingheadstart missingheadstartearly missingpdgfederal missingpdgstate missingprivatepay ///
missingschoolreadinesscomp missingschoolreadinessprio missingsmartstart 

asdoc tabstat $list, by(year) stat(N mean)

asdoc tabstat $list, by(round_369) stat(N mean)

**************************************************************************************************************************************************
*Regressions
xtset year
asdoc xtreg ol_c2 ol_c1, fe cluster (year)
asdoc xtreg ol_c2 ol_c1 pdg_funding missingpdg, fe cluster (year)
asdoc xtreg ol_c2 ol_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic, fe cluster (year)
asdoc xtreg ol_c2 ol_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic i.site, fe cluster (year)

asdoc xtreg br_c2 br_c1, fe cluster (year)
asdoc xtreg br_c2 br_c1 pdg_funding missingpdg, fe cluster (year)
asdoc xtreg br_c2 br_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic, fe cluster (year)
asdoc xtreg br_c2 br_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic i.site, fe cluster (year)

asdoc xtreg math_c2 math_c1, fe cluster (year)
asdoc xtreg math_c2 math_c1 pdg_funding missingpdg, fe cluster (year)
asdoc xtreg math_c2 math_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic, fe cluster (year)
asdoc xtreg math_c2 math_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic i.site, fe cluster (year)


*regressing spring scores on fall clustering by site

xtset site
asdoc xtreg ol_c2 ol_c1, fe cluster (site)
asdoc xtreg ol_c2 ol_c1 pdg_funding missingpdg, fe cluster (site)
asdoc xtreg ol_c2 ol_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic, fe cluster (site)
asdoc xtreg ol_c2 ol_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic fundingtype missingfunding, fe cluster (site)

asdoc xtreg br_c2 br_c1, fe cluster (site)
asdoc xtreg br_c2 br_c1 missingpdg, fe cluster (site)
asdoc xtreg br_c2 br_c1 missingpdg missingsex missingethnic, fe cluster (site)
asdoc xtreg br_c2 br_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic fundingtype missingfunding, fe cluster (site)

asdoc xtreg math_c2 math_c1, fe cluster (site)
asdoc xtreg math_c2 math_c1 missingpdg, fe cluster (site)
asdoc xtreg math_c2 math_c1 missingpdg missingsex missingethnic, fe cluster (site)
asdoc xtreg math_c2 math_c1 pdg_funding missingpdg sex missingsex ethnic missingethnic fundingtype missingfunding, fe cluster (site)









