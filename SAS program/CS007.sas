

/*Case Study : 7 
 
Project Title : Summary of Treatment 
Project code  : CCS007 
Description   : Generate summary reports of treatment reports by using procedure 
                 tabulate */


proc import datafile="E:\Raw Data\CASE STUDIES\CS007\RAW DATA\trt2.csv"
out= trt1
dbms=csv;
run;
proc import datafile="E:\Raw Data\CASE STUDIES\CS007\RAW DATA\trt2.xls"
out= trt2
dbms=xls;
run;
/*Table1*/

proc printto log='E:\Raw Data\CASE STUDIES\CS007\OUTPUT\trt.log';
run;
/*importing external sas file*/

libname cs7 "E:\Raw Data\CASE STUDIES\CS007\RAW DATA";
data out.trt;
set cs7.trt;
run;
/*formatting visit*/
proc format;
value visitft
1= 'visit1'
2='visit2'
3='visit3'
4='visit4'
5='visit5'
6='visit6'
7='visit7';
run;
/*to store the sas dataset in external file*/
libname out "E:\Raw Data\CASE STUDIES\CS007\OUTPUT";

/*creating rtf output*/
options nodate;
ods rtf file= 'E:\Raw Data\CASE STUDIES\CS007\OUTPUT\trt.rtf';
title1 c=black bcolor=lightgrey italic bold 'Summary of Treatment';
title2 c=black bcolor=lightgrey italic bold "CCS007";
title3 c=black bcolor=lightgrey italic bold "Generate Summary reports of treatment reports by using procedure tabulate";
proc tabulate data=cs7.trt ;
class lab;
var sub;
table lab , sub*(n mean);
label lab='Lab_Group';
run;

/*Table2*/

proc tabulate data=cs7.trt;
class visit drug;
var  sub;
format visit visitft.;
table visit*drug,sub*(n sum mean max min std);
run;
ods rtf close;
proc printto;
run;

/*Task 2*/
/*Table 3*/

proc printto log="E:\Raw Data\CASE STUDIES\CS007\OUTPUT\Trt2.log" ;
run;
data out.trt2;
set trt1;
run;
options nodate;
ods rtf file='E:\Raw Data\CASE STUDIES\CS007\OUTPUT\trt2.rtf';
ods escapechar='^';
title1 c=black bcolor=lightgrey italic bold'Summary of Treatment';
title2 c=black bcolor=lightgrey italic bold "CCS007";
title3 c=black bcolor=lightgrey italic bold "Generate Summary reports of treatment reports by using procedure tabulate";

proc tabulate data=trt1 ;
class trt sex ;
var subjid;
table trt all,sex='Gender(count)' all*(n) (sex='Gender(%)' all)*( pctn )
/box='Example of ^n using^n PCTN';
run;
/*Table 4*/
proc tabulate data= trt1;
class trt sex ;
var aval;
table trt all,sex='Gender(count)'*aval='Lab_Group^n Result' *sum
              all*aval='Lab_Group^n Result'*sum
              sex='Gender(%)' *aval='Lab_Group^n Result'*pctsum
              all*aval='Lab_Group^n Result'*pctsum/box='Example of^n using^n PCTSUM'rts=20;
run;

/*Table 5*/
proc tabulate data=trt1 ;
class trt sex ;
var subjid;
table trt all,sex='Gender(count)' all*(n) (sex='Gender(%)' all)*( rowpctn )
/box='Example of ^n using^n ROWPCTN';
run;

/*Table 6*/
proc tabulate data= trt1;
class trt sex ;
var aval;
table trt all,sex='Gender(count)'*aval='Lab_Group^n Result' *sum
              all*aval='Lab_Group^n Result'*sum
              sex='Gender(%)' *aval='Lab_Group^n Result'*rowpctsum
              all*aval='Lab_Group^n Result'*rowpctsum/box='Example of^n using^n ROWPCTSUM'rts=20;
run;



proc sql noprint;
create table denom as select site,avisit,count(*)as total
from trt1
group by site ,avisit;
quit;

proc sql noprint;
create table summary as select  a.site,a.trt,a.avisit,a.sex,count(*) as n,
           b.total,count(*)/b.total*100 as pct format=6.2
    from trt1 as a
    left join denom as b
      on a.site=b.site
     and a.avisit=b.avisit
    group by a.site, a.trt, a.avisit, a.sex, b.total;
quit; 

/*Table 7*/
proc tabulate data=summary;
    class site trt avisit sex;
    var pct;
    table site*(trt all),
          avisit*(sex all)*pct=" "*sum=" ";
run;
ods rtf close;

proc printto ;
run;
