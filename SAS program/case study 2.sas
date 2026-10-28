 


/*CASE STUDY :2
  Project Title : Check Outliers 
  Project code  : CSS002 
  Description   : Outliers creation from raw data*/

proc import datafile= "E:\Raw Data\CASE STUDIES\CS002\RAW DATA\MH.xls"
out= MH
dbms= xls replace;
run;

proc import datafile= "E:\Raw Data\CASE STUDIES\CS002\RAW DATA\dm2.xls"
out= dm2
dbms= xls replace;
run;


proc import datafile= "E:\Raw Data\CASE STUDIES\CS002\RAW DATA\AE.xls"
out= Ae
dbms= xls replace;
run;

libname dataset "E:\Raw Data\CASE STUDIES\CS002\RAW DATA";


/*SAFETY DATA*/


 
/*Retain height values where ever data values missing*/
data demo;
set dataset.demo;
retain ht;
if height^=. then ht= height;
else height=ht;
run;

/*Merging dataset*/
proc sort data= dm2 ;
by patid;
run;

proc sort data= demo;
by patid;
run;
/*Weight & temperature variable requires 1 decimal data values. */
 data demo1;
 merge demo dm2;
 by patid;
 format weight 5.1 temp 4.1;
 run;
 proc sort data= ae ;
by subject;
run;
proc sort data= mh ;
by patid;
run;
data MA;
merge mh (in=a) ae(in=b rename=(subject=patid));
by patid;
if a or b;
run;

data final_data;
merge demo1(in=a) ma(in=b);
if a or b;
drop ht d;
run;

/*Create demo_dup and List out the duplicate patients data */
data demo_dup;
set final_data;
if not(first.patid and last.patid); 
drop ht;
run;
proc print data= demo_dup;
run;

/*bmi range between 19 to 26*/

data bmi_range;
set final_data;
BMI= (weight/(height**2))*703.1;
if bmi>=19 and bmi<=26;
format bmi 6.2;
run;

proc print data=bmi_range;
run;

/*age not within 40 to 60 range*/

data age_range;
set final_data;
today= "06Oct2026"d;
age= intck("years",birthdt,today);
if age<40 or age>60;
format today mmddyy10.;
run;

proc print data= age_range;
run;

/*DOB is greater than the Visit date or not..? */

data aedemo;
set final_data;
if  missing(visit_date) then dob_gr_vsdt=" ";
else if BIRTHDT > visit_date then dob_gr_vsdt="Y";
else dob_gr_vsdt= "N";
format visit_date mmddyy10.;
run;
proc print data= aedemo;
run;

/*Gender value is a valid one or invalid. Etc  (M , F else invalid) */
 data gender_val;
 set final_data;
 length gender $10.;
if sex= "M" or sex = "F" then gender= "Valid";
else gender= "Invalid";
run;
proc print data= gender_val;
run;

/*Adverse event*/

/*Stop is before the start  */
data sded;
set ae;
if end_date < start_date then flag= "Y";
else flag="N";
if flag="Y";
run;
proc print data= sded;
run;

/*Overlapping adverse events for the same patient in same visit.*/
proc sort data= ae;
by subject visit_date adverse_event;
run;
data overlap_ae;
set ae;
by subject visit_date adverse_event;
if  first.visit_date then ord=1 ;
else ord +1;
if ord>1;
run;
proc print data= overlap_ae;
run;

  /*Vitals*/ 
/*• Diastolic BP > Systolic BP*/

data vitals;
set final_data;
if diabp>sysbp;
run;
proc print data= vitals;
run;

/*Medical History*/ 
/*• Visit date prior to Screen date of Physical exam is normal.*/

data vs_norm;
set final_data;
if visit_date <screen_date & status= "Normal";
run;
proc print data= vs_norm;
run;

/*exporting output file*/

proc export data=demo_dup outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx replace;
sheet= "Demo_dupe";
run;
proc export data=bmi_range outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx ;
sheet= "BMI_range";
run;
proc export data=age_range outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx ;
sheet= "Age_range";
run;

proc export data=aedemo outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx ;
sheet= "Dates";
run;

proc export data=gender_val outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx replace;
sheet= "Gender_val";
run;

proc export data=sded outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx ;
sheet= "endt_before_stdt";
run;

proc export data=overlap_ae outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx;
sheet= "overlap_data";
run;

proc export data=vitals outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx ;
sheet= "Vitals";
run;

proc export data=vs_norm outfile="E:\Raw Data\CASE STUDIES\CS002\OUTPUT\safety_report.xlsx"
dbms=xlsx ;
sheet= "VS_norm";
run;
 
