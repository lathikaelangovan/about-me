

/*Case Study : 5 
 
Project Title :  Listing of Screening Volunteers for Clinical Trials 
Project code  : CCS005 
Description   : To screen healthy volunteers for clinical trials*/

proc printto log="E:\Raw Data\CASE STUDIES\CS005\OUTPUT\SC.log";
run;
libname cs5 "E:\Raw Data\CASE STUDIES\CS005\RAW DATA"; 

data cs5.s1 (drop=patid rename=(id=patid));
set cs5.sc;
ID= input(substr(patid,1,2),2.);
run;

proc sort data=cs5.s1 out= cs5.s2;
by patid site;
run;

proc sort data=cs5.pat_inf out= cs5.pat;
by patid site;
run;
data cs5.df1 (drop=dob today age_c sex patid site rename=(sex_c=Sex siteid=Site));
merge cs5.pat(in=a) cs5.s2(in=b);
by patid site;
if a and b;
today="12oct2026"d;
Birthdt=input(dob,mmddyy10.);
Age_c= intck("year",birthdt,today);
Age= put(age_c,3.);
Race= scan(racespec,1,"/");
Spec= scan(racespec,2,"/");
sex_c= put(sex,8.);
Subjid= put(patid,3.);
siteid=put(site,3.);
BIRDT=put(birthdt,date9.);
format  birthdt today mmddyy10.;
run;

proc format ;
value sexft
1="Male"
2="Female";
run;

data cs5.lab1;
set cs5.lab;
if lb_test="BICARBONATE" then row_no=1;
if lb_test="BUN (Blood Urea Nitrogen" then row_no=2;
if lb_test="Basophils (% and/or abso" then row_no=3;
if lb_test="CALCIUM" then row_no=4;
if lb_test="Chloride" then row_no=5;
if lb_test="EOSINOPHILS (% AND/OR AB" then row_no=6;
if lb_test="GGT" then row_no=7;
if lb_test="Hemoglobin" then row_no=8;
if lb_test="Lymphocytes (% and/or ab" then row_no=9;
if lb_test="Monocytes (% and/or abso" then row_no=10;
if lb_test="Neutrophils (% and/or ab" then row_no=11;
if lb_test="PH" then row_no=12;
if lb_test="POTASSIUM" then row_no=13;
if lb_test="Phosphorus" then row_no=14;
if lb_test="Protein" then row_no=15;
if lb_test="RBC (Red Blood Cell Coun" then row_no=16;
if lb_test="Specific Gravity" then row_no=17;
if lb_test="Uric acid" then row_no=18;
if lb_test="WBC (WHITE BLOOD CELL CO" then row_no=19;
run;
proc sort data =cs5.lab1 out = cs5.lab2;
by row_no;
run;
libname case5 "E:\Raw Data\CASE STUDIES\CS005\OUTPUT";

data cs5.SC1 (drop=row_no );
retain subjid age sex race spec height weight lb_test;
set cs5.df1;
do i=1 to 19;
set cs5.lab2 point=i;
if i>1 then 
call missing( site,subjid,age,sex,height,weight,race,spec,racespec,birdt);
output;
end;
run;
data case5.SC;
set cs5.sc1;
keep subjid age sex race spec height weight lb_test;
format sex sexft.;
run;
proc print data= case5.sc;
run;

proc printto print="E:\Raw Data\CASE STUDIES\CS005\OUTPUT\SC.lst";
run;
proc print data= case5.sc;
run;
proc printto;
run;

ods rtf file="E:\Raw Data\CASE STUDIES\CS005\OUTPUT\SC.rtf";
title1 "Listing 5";
title2 "Screening Patient";
footnote1 "*1=male & 2=female";
footnote2 "**Created by Lathika 12-10-2026 Monday 6:10pm";
proc report data=cs5.sc1 nowd;
column  site subjid age sex birdt height weight racespec lb_test;
define site/display "SITE" ;
define subjid/display "PATID";
define age/display "AGE";
define sex/display "SEX";
define birdt/display ;
define height/display "HEIGHT";
define weight/display "WEIGHT" width=6;
define racespec/display "RACESPEC";
define lb_test/display "LB_TEST";
run;
footnote1;
footnote2;
title1;
title2;
ods rtf close;

proc printto ;
run;
