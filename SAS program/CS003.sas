
/*Case Study : 3 
 
Project Title : Dataset creation and listing generation 
Project Code  : CCS003 
Description   : Eligibility criteria and create inclusive criteria, 
                exclusion criteria and disposition patient’s profile.*/


/*IMPORTING INPUT DATASETS*/

%macro import (dfpath=,outn=,cdbms=,dlm= ",");
proc import datafile=&dfpath.
out= _interm
dbms= &cdbms. replace;
delimiter=&dlm. ;
run;
%mend import;

%import(dfpath="E:\Raw Data\CASE STUDIES\CS003\RAW DATA\screen_pat.txt",
        outn=screen,
        cdbms=dlm);

%import(dfpath="E:\Raw Data\CASE STUDIES\CS003\RAW DATA\medication.txt",
        outn=medication,
        cdbms=dlm);

%import(dfpath="E:\Raw Data\CASE STUDIES\CS003\RAW DATA\dispose.txt",
        outn=dispo,
        cdbms=dlm);

/*SORTING IMPORTED DATASETS*/

%macro sort(dnam,outn,byvar);
proc sort data=&dnam out= &outn;
by &byvar;
run;
%mend sort;
%sort(dispo,s_dispo,pat)
%sort(medication,s_medi,pat)
%sort(screen,s_screen,pat)

/*MERGING DATASETS*/
data s_m;
merge s_screen(in=a) s_medi(in=b);
by pat;
if a or b;
run;

data s_m_d;
merge s_m(in=a) s_dispo(in=b);
by pat;
if a or b;
if age>=30;
if sex="male" or sex="female";
if status="h";
run;

/*CREATING FORMATS*/
proc format;
value $ sexft
"male"="M"
"female"="F";
value $locationft
"us"="USA";
value $statusft
"h"="Healthy"
"p"="Patient";
value $armft
"p"="Placebo"
"a"= "Active"
"s"="Standard";
run;

/*STANDARDISING DATASET*/
data final  ;
retain pat visit age sex location status height weight arm criteria dscat;
length visit $10. age 3. sex $2. location$3. status $10. arm $10. criteria $15. dscat $24.;
set s_m_d (rename=(pat=pat_n));
pat=put(pat_n,4.);
label pat="SUBJECT"
      visit="VISIT"
	  age= "AGE"
	  sex="SEX"
	  location="LOCATION"
	  status="STATUS"
	  height="HEIGHT"
	  weight="WEIGHT"
	  arm="ARM"
	  criteria="CRITERIA"
	  dscat="DISPOSITION CRITERIA";
format sex $sexft. location $locationft. status $statusft. arm $armft. height weight 5.1;
drop pat_n;
run;

/*CREATING SAS DATASET OUTPUT*/
libname output "E:\Raw Data\CASE STUDIES\CS003\OUTPUT";
data output.incl;
set final;
if criteria="inc";
run;
proc print data=output.incl;
run;

data output.excl;
set final;
if criteria="exl";
run;

proc print data=output.excl;
run;

data output.ds;
set final;
if dscat^=" " ;
run;

proc print data=output.ds;
run;

/*creating log output */
proc printto log="E:\Raw Data\CASE STUDIES\CS003\OUTPUT\incl.log"new;
run;
data output.incl;
set final;
if criteria="inc";
run;
proc print data=output.incl;
run;
proc printto;
run;

proc printto log="E:\Raw Data\CASE STUDIES\CS003\OUTPUT\excl.log";
run;
data output.excl;
set final;
if criteria="exl";
run;

proc print data=output.excl;
run;
proc printto;
run;

proc printto log="E:\Raw Data\CASE STUDIES\CS003\OUTPUT\ds.log";
run;
data output.ds;
set final;
if dscat^=" " ;
run;

proc print data=output.ds;
run;
proc printto;
run;
