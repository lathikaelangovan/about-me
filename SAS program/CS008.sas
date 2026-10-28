

/*Case Study : 8 
 
Project Title : Summary of Medication 
Project code  : CCS008 
Description   : Generate summary reports of concomitant medication reports by 
                using procedure Report */


proc printto log="E:\Raw Data\CASE STUDIES\CS008\OUTPUT\med.log";
run;
libname cs8 "E:\Raw Data\CASE STUDIES\CS008\RAW DATA";
libname out8 "E:\Raw Data\CASE STUDIES\CS008\OUTPUT";

data trt  (drop=lab rename=(lab_=lab));
set cs8.trtmentr;
if lab='A1' then lab_='A1234';
else if lab='A2' then lab_='A2345';
else if lab='A3' then lab_='A3456';
run;
proc summary data=trt nway;
class lab drug;
var sub;
output out =out8.Med (drop=_type_ _freq_)sum=sub;
run;


proc transpose data=new out=new_;
by lab;
id drug;
var sub;
run;
data sum;
set new_;
total= sum(of dolo2mg ,dolo3mg, dolo4mg ,dolo5mg);
run;

/*CREATING RTF OUTPUT TABLES*/

/*TABLE1*/
options nodate number;
ods rtf file="E:\Raw Data\CASE STUDIES\CS008\OUTPUT\med.rtf";
footnote"**********************************";
title "Summary medication table";
proc report data= out8.med ;
column lab drug sub;
define lab/group ;
define drug/group;
define sub/ sum;
break after lab/ol ul summarize;
rbreak after/ol ul summarize;
run;

/*TABLE2*/
ods rtf startpage=now;
title "Summary medication table";
proc report data=sum nowd ;
column lab ("Drug" ("dolo2mg" dolo2mg) ("dolo3mg" dolo3mg) ("dolo4mg" dolo4mg) ("dolo5mg" dolo5mg)) total;
define lab/display;
define dolo2mg/  display "Sub";
define dolo3mg/display "Sub";
define dolo4mg/display "Sub";
define dolo5mg/display "Sub" ;
define total/display;
compute after;
line' ';
line "This data belongs to phase4";line' ';
endcomp;
run;


/*TABLE 3*/ 
ods rtf startpage=now;
title "Summary medication table";
proc report data=sum nowd spacing=10;
column lab ("Drug" ("dolo2mg" dolo2mg) ("dolo3mg" dolo3mg) ("dolo4mg" dolo4mg) ("dolo5mg" dolo5mg)) total;
compute before ;
line "   ";
line "this data belongs to oncology"; line ' ';
line "phase 4 trials";  
line" ";
endcomp;
define lab/display;
define dolo2mg/  display "Sub";
define dolo3mg/display "Sub";
define dolo4mg/display "Sub";
define dolo5mg/display "Sub" ;
define total/display;
compute after;
line "  ";
line "This data belongs to phase4";line" ";
endcomp;
run;

title;
ods rtf close;
footnote;

proc printto;
run;
