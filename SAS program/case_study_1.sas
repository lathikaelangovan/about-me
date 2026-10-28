

/* CLINICAL CASE STUDY  #1

Project Title : Dataset creation and Listing generation 
Project code  : CCS001 
Description   : Listing of demographic data. */

/*TASK 1*/
proc import datafile= "E:\Raw Data\CASE STUDIES\CS001\RAW DATA\demography.csv"
out= demography
dbms=csv replace;
run;

proc import datafile= "E:\Raw Data\CASE STUDIES\CS001\RAW DATA\visit.xls"
out= visit
dbms= xls replace;
run;

proc sort data= demography out= dd ;
by patid;
run;


proc sort data= visit  out= visit1 ;
by pat;
run;


data demo1 (label= "demography");
merge dd visit1(rename=(pat=patid)) ;
by patid;
length category $20.;
BMI= (weight/(height**2))*703.1;
label bmi= "Body Mass Index";
if missing(bmi) then Category= "NA";
else if bmi>=35 then Category= "Very Obese";
else if 30=<bmi<=34.9 then  Category= "Obese";
else if 25=<bmi<=29.9 then Category= "Overweight";
else if 18.5=<bmi<=24.9 then Category= "Normal";
else if 16=<bmi<=18.4 then Category= "Underweight";
else if .<bmi<=15 then Category="Very Underweight";
format height 4.2 bmi 6.2 sexcd sex. ;
drop f g h i j k l m n;
run;

proc print data= demo1 (rename=(patid= SubjectID sexcd=Gender ));
run;

proc format  ;
value  sex
1= "Male"
2= "Female";
run;

libname cs1 "E:\Raw Data\CASE STUDIES\CS001\OUTPUT";
data cs1.demo;
set demo1;
keep patid sexcd bmi;
run;
proc print data= cs1.demo (rename=(patid= SubjectID sexcd=Gender ));
run;


/* Print the dataset to output window*/
proc printto print= "E:\Raw Data\CASE STUDIES\CS001\OUTPUT\Demo.lst";
run;
proc print data= cs1.demo (rename=(patid= SubjectID sexcd=Gender ));
run;

proc printto;
run;
 
/*Generate adhoc report*/
proc printto print= "E:\Raw Data\CASE STUDIES\CS001\ADHOC\Demo_report";
run;

title"Category wise BMI Report";

proc report data= demo1 nowd;
column Category bmi;
define Category/ display;
define bmi/ display;
run;
proc printto;
run;


/*TASK 2*/

libname mywrk "E:\mywrk";
data mywrk.demography ;
set demography ;
run;
data mywrk.visit ;
set visit;
drop f g h i j k l m n;
run;


data mywrk.demo_ ;
set demo1;
today= "05Oct2026"d;
AGE= intck("years",birthdt,today);
rename sexcd=SEX
       site=LOCATION;
format today date10.;
run;

data mywrk.demo3;
set mywrk.demo_ ;
keep age sex location;
run;

proc print data= mywrk.demo3;
run;

ods excel file= "E:\Raw Data\CASE STUDIES\CS001\OUTPUT\demo2.xls"
options(sheet_name = "Demographics");
title "demographic report";
 proc report data= mywrk.demo3;
 column age sex location;
 define age/display;
 define sex/display;
 define location/display;
 run;

 title;
 ods excel close;

/*TASK 3*/

 data mywrk.dem;
 set mywrk.demo_ (drop= today);
 rename patid= subjid
        location=site;
 if racecd=1 then race= "Asian";
 else if racecd=2 then race="White";
 else if racecd=3 then race="Black";
 else if racecd=4 then race="African";
 else if racecd=5 then race="Multi";
 else if racecd=6 then race="CAUCA"; 
 else if racecd=7 then race="BI-RA";
 format birthdt  start_date end_date date9.  ;
 run;

 proc print data= mywrk.dem;
 run;

 data mywrk.demographics;
 set mywrk.dem;
fst_col= catx("\",site,subjid,race,ethnicity,put(SEX,sex.));
 sec_col= catx("\",put(birthdt,date9.),age);
 usubjid= cats(site,subjid);
 run;

 proc print data= mywrk.demographics;
 run;
 

/* rtf REPORT GENERATION BY PROC REPORT*/
ods rtf file= "E:\Raw Data\CASE STUDIES\CS001\OUTPUT\demographics.rtf";
title "Demographics Overall Report";

 proc report data= mywrk.demographics nowd;
 column fst_col sec_col start_date end_date usubjid;
 define fst_col/display "Site\Subjid\race\ethnicity\Sex" ;
 define sec_col/display "Brthdt\Age (DD\MM\YY)";
 define start_date/display "Start date (DD\MM\YY)";
 define end_date/display "End date (DD\MM\YY)";
 define usubjid/display "Usubjid (site+subjid)";
 run;

 title;
ods rtf close;
