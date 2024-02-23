
********************
***CRIS ETHNICITY***
********************

*CRIS WITH NOT STATED*
gen ethnicity_cris=.
replace ethnicity_cris=0 if ethnicitycleaned=="British (A)" 
replace ethnicity_cris=0 if ethnicitycleaned=="Irish (B)" 
replace ethnicity_cris=0 if ethnicitycleaned=="Any other white background (C)" 
replace ethnicity_cris=1 if ethnicitycleaned=="Caribbean (M)" 
replace ethnicity_cris=1 if ethnicitycleaned=="African (N)" 
replace ethnicity_cris=1 if ethnicitycleaned=="Any other black background (P)"
replace ethnicity_cris=2 if ethnicitycleaned=="Indian (H)" 
replace ethnicity_cris=2 if ethnicitycleaned=="Pakistani (J)" 
replace ethnicity_cris=2 if ethnicitycleaned=="Bangladeshi (K)"
replace ethnicity_cris=2 if ethnicitycleaned=="Any other Asian background (L)"
replace ethnicity_cris=3 if ethnicitycleaned=="Any other mixed background (G)" 
replace ethnicity_cris=3 if ethnicitycleaned=="White and Asian (F)" 
replace ethnicity_cris=3 if ethnicitycleaned=="White and Black African (E)" 
replace ethnicity_cris=3 if ethnicitycleaned=="White and black Caribbean (D)" 
replace ethnicity_cris=4 if ethnicitycleaned=="Chinese (R)"
replace ethnicity_cris=5 if ethnicitycleaned=="Any other ethnic group (S)" 
replace ethnicity_cris=. if ethnicitycleaned=="xNx" 
replace ethnicity_cris=6 if ethnicitycleaned=="Not Stated (Z)" 
replace ethnicity_cris=. if ethnicitycleaned=="" 
lab def ethnicity_cris 0 "White" 1 "Black" 2 "Asian" 3 "Mixed" 4 "Chinese" 5 "Other" 6 "Not stated", modify
lab val ethnicity_cris ethnicity_cris
lab var ethnicity_cris "CRIS ethnicity"
tab ethnicitycleaned ethnicity_cris , m

*CRIS WITHOUT MISSING*
gen ethnicity_cris_usable=ethnicity_cris
replace ethnicity_cris_usable=. if ethnicity_cris==6
lab val ethnicity_cris_usable ethnicity_cris
tab ethnicity_cris ethnicity_cris_usable , m

*CRIS WITH MISSING*
gen ethnicity_cris_missing=ethnicity_cris
replace ethnicity_cris_missing=6 if ethnicity_cris==. 
lab val ethnicity_cris_missing ethnicity_cris
tab ethnicity_cris ethnicity_cris_missing , m


*******************
***NPD ETHNICITY***
*******************

*NPD WITH NOT STATED*
gen ethnicity_npd=.
replace ethnicity_npd=0 if ethnic_group==1
replace ethnicity_npd=1 if ethnic_group==2
replace ethnicity_npd=2 if ethnic_group==3
replace ethnicity_npd=3 if ethnic_group==4
replace ethnicity_npd=4 if ethnic_group==5 
replace ethnicity_npd=5 if ethnic_group==6
replace ethnicity_npd=6 if ethnic_group==7
replace ethnicity_npd=. if ethnic_group==. 

lab define ethnicity_npd ///
	0 "White" ///
	1 "Black" ///
	2 "Asian" ///
	3 "Mixed" ///
	4 "Chinese" ///
	5 "Other" ///
	6 "Unknown" , modify
lab val ethnicity_npd ethnicity_npd
lab var ethnicity_npd "NPD ethnicity"
tab ethnicity_npd ethnic_group , m

*NPD WITHOUT MISSING*
gen ethnicity_npd_usable=ethnicity_npd
replace ethnicity_npd_usable=. if ethnicity_npd==6
lab val ethnicity_npd_usable ethnicity_npd
tab ethnic_group ethnicity_npd_usable , m

*NPD WITH MISSING*
gen ethnicity_npd_missing=ethnicity_npd
replace ethnicity_npd_missing=6 if ethnicity_npd==. 
lab val ethnicity_npd_missing ethnicity_npd
tab ethnic_group ethnicity_npd_missing , m


*********************************
***NEURODEVELOPMENTAL DISORDER***
*********************************

gen neuro=0
lab def neuro 0 "No" 1 "Yes" , modify
lab val neuro neuro
replace neuro=1 if id_ever==1 | pdd_ever==1 | adhd_ever==1
tab neuro id_ever
tab neuro pdd_ever
tab neuro adhd_ever
tab neuro


******************
***MAIN RESULTS***
******************

*Missing ethnicity
tab ethnicity_npd
tab ethnicity_npd , m

tab ethnicity_cris
tab ethnicity_cris , m

tab ethnicity_npd_usable
tab ethnicity_npd_usable , m

tab ethnicity_cris_usable
tab ethnicity_cris_usable , m

count if ethnicity_npd_usable!=. | ethnicity_cris_usable!=.

count if ethnicity_npd_usable!=. & ethnicity_cris_usable!=.

*Sample overview
tab ethnicity_npd_usable
tab ethnicity_cris_usable
tab ks4_level2_em
tab neuro

*Kappa statistic
kap ethnicity_npd_usable ethnicity_cris_usable, tab

*Kappa 95% CI (SE * 1.96)
disp 0.7850 - (0.0046*1.96)
disp 0.7850 + (0.0046*1.96)

*Crosstab ethnicity (excluding the Chinese ethnicity category to avoid potential disclosure)
tab ethnicity_npd_usable ethnicity_cris_usable if ethnicity_npd_usable!=4 & ethnicity_cris_usable!=4, col row

*Crosstab ethnicity disaggregated (excluding the Chinese ethnicity category to avoid potential disclosure)
tab ethnicitycleaned ethnicity_npd_usable if ethnicitycleaned!="NULL" & ethnicitycleaned!="Not Stated (Z)" & ethnicitycleaned!="Chinese (R)" & ethnicity_npd_usable!=4 , row

*Creating dummy variables for each ethnicity group
foreach x in npd cris {
	gen black_`x'_missing=0
	replace black_`x'_missing=1 if ethnicity_`x'_missing==1
	tab black_`x'_missing ethnicity_`x'_missing , m
	
	gen asian_`x'_missing=0
	replace asian_`x'_missing=1 if ethnicity_`x'_missing==2
	tab asian_`x'_missing ethnicity_`x'_missing , m
	
	gen mixed_`x'_missing=0
	replace mixed_`x'_missing=1 if ethnicity_`x'_missing==3
	tab mixed_`x'_missing ethnicity_`x'_missing , m
	
	gen chinese_`x'_missing=0
	replace chinese_`x'_missing=1 if ethnicity_`x'_missing==4
	tab chinese_`x'_missing ethnicity_`x'_missing , m
	
	gen other_`x'_missing=0
	replace other_`x'_missing=1 if ethnicity_`x'_missing==5
	tab other_`x'_missing ethnicity_`x'_missing , m
	
	gen unknown_`x'_missing=0
	replace unknown_`x'_missing=1 if ethnicity_`x'_missing==6
	tab unknown_`x'_missing ethnicity_`x'_missing , m
	}
	
*Risk ratios
tab ethnicity_npd_missing ks4_level2_em , row
oddsrisk ks4_level2_em black_npd_missing asian_npd_missing mixed_npd_missing chinese_npd_missing other_npd_missing unknown_npd_missing

tab ethnicity_cris_missing ks4_level2_em , row
oddsrisk ks4_level2_em black_cris_missing asian_cris_missing mixed_cris_missing chinese_cris_missing other_cris_missing unknown_cris_missing

tab ethnicity_npd_missing neuro , row
oddsrisk neuro black_npd_missing asian_npd_missing mixed_npd_missing chinese_npd_missing other_npd_missing unknown_npd_missing

tab ethnicity_cris_missing neuro , row
oddsrisk neuro black_cris_missing asian_cris_missing mixed_cris_missing chinese_cris_missing other_cris_missing unknown_cris_missing


****************************
***SUPPLEMENTARY ANALYSES***
****************************

*Supplementary analyses repeated the main analyses after supplementing missing ethnicity in one source using ethnicity from the other

*NPD ETHNICITY WITH 'MISSING' SUPPLEMENTED FROM CRIS*
gen npd_supp_from_cris=ethnicity_npd_missing
replace npd_supp_from_cris=ethnicity_cris_missing if ethnicity_npd_missing==6
lab val npd_supp_from_cris ethnicity_npd
tab npd_supp_from_cris ethnicity_npd_missing
tab npd_supp_from_cris ethnicity_cris_missing if ethnicity_npd_missing==6
tab npd_supp_from_cris , m

*Recreating dummy variables for each ethnicity group
gen black_npd_supp_from_cris=0
replace black_npd_supp_from_cris=1 if npd_supp_from_cris==1
tab black_npd_supp_from_cris npd_supp_from_cris , m

gen asian_npd_supp_from_cris=0
replace asian_npd_supp_from_cris=1 if npd_supp_from_cris==2
tab asian_npd_supp_from_cris npd_supp_from_cris , m

gen mixed_npd_supp_from_cris=0
replace mixed_npd_supp_from_cris=1 if npd_supp_from_cris==3
tab mixed_npd_supp_from_cris npd_supp_from_cris , m

gen chinese_npd_supp_from_cris=0
replace chinese_npd_supp_from_cris=1 if npd_supp_from_cris==4
tab chinese_npd_supp_from_cris npd_supp_from_cris , m

gen other_npd_supp_from_cris=0
replace other_npd_supp_from_cris=1 if npd_supp_from_cris==5
tab other_npd_supp_from_cris npd_supp_from_cris , m

gen unknown_npd_supp_from_cris=0
replace unknown_npd_supp_from_cris=1 if npd_supp_from_cris==6
tab unknown_npd_supp_from_cris npd_supp_from_cris , m

*CRIS ETHNICITY WITH 'MISSING' SUPPLEMENTED FROM NPD*
gen cris_supp_from_npd=ethnicity_cris_missing
replace cris_supp_from_npd=ethnicity_npd_missing if ethnicity_cris_missing==6
lab val cris_supp_from_npd ethnicity_cris
tab cris_supp_from_npd ethnicity_cris_missing
tab cris_supp_from_npd ethnicity_npd_missing if ethnicity_cris_missing==6
tab cris_supp_from_npd , m

*Recreating dummy variables for each ethnicity group
gen black_cris_supp_from_npd=0
replace black_cris_supp_from_npd=1 if cris_supp_from_npd==1
tab black_cris_supp_from_npd cris_supp_from_npd , m

gen asian_cris_supp_from_npd=0
replace asian_cris_supp_from_npd=1 if cris_supp_from_npd==2
tab asian_cris_supp_from_npd cris_supp_from_npd , m

gen mixed_cris_supp_from_npd=0
replace mixed_cris_supp_from_npd=1 if cris_supp_from_npd==3
tab mixed_cris_supp_from_npd cris_supp_from_npd , m

gen chinese_cris_supp_from_npd=0
replace chinese_cris_supp_from_npd=1 if cris_supp_from_npd==4
tab chinese_cris_supp_from_npd cris_supp_from_npd , m

gen other_cris_supp_from_npd=0
replace other_cris_supp_from_npd=1 if cris_supp_from_npd==5
tab other_cris_supp_from_npd cris_supp_from_npd , m

gen unknown_cris_supp_from_npd=0
replace unknown_cris_supp_from_npd=1 if cris_supp_from_npd==6
tab unknown_cris_supp_from_npd cris_supp_from_npd , m

*Descriptives
tab npd_supp_from_cris if npd_supp_from_cris!=6
tab cris_supp_from_npd if cris_supp_from_npd!=6

*Risk ratios
tab npd_supp_from_cris ks4_level2_em , row
oddsrisk ks4_level2_em black_npd_supp_from_cris asian_npd_supp_from_cris mixed_npd_supp_from_cris chinese_npd_supp_from_cris other_npd_supp_from_cris unknown_npd_supp_from_cris

tab cris_supp_from_npd ks4_level2_em , row
oddsrisk ks4_level2_em black_cris_supp_from_npd asian_cris_supp_from_npd mixed_cris_supp_from_npd chinese_cris_supp_from_npd other_cris_supp_from_npd unknown_cris_supp_from_npd

tab npd_supp_from_cris neuro , row
oddsrisk neuro black_npd_supp_from_cris asian_npd_supp_from_cris mixed_npd_supp_from_cris chinese_npd_supp_from_cris other_npd_supp_from_cris unknown_npd_supp_from_cris

tab cris_supp_from_npd neuro , row
oddsrisk neuro black_cris_supp_from_npd asian_cris_supp_from_npd mixed_cris_supp_from_npd chinese_cris_supp_from_npd other_cris_supp_from_npd unknown_cris_supp_from_npd

