
/*Case Study : 9 
 
Project Title  : AE Summary 
Project code   : CCS009  
Description    : Incidence of Treatment Emergent Adverse Events by System Organ 
                 Class (SOC) and Preferred Term (PT) */


proc printto log="E:\Raw Data\CASE STUDIES\CS009\OUTPUT\ae.log";
run;

/*importing rawdata*/

proc import datafile="E:\Raw Data\CASE STUDIES\CS009\RAW DATA\ADAE_AA.xls"
out= adae
dbms=xls replace;
run;

data a1;
set adae;
where teae="Y" ;
if missing (aebodsys)then delete;
if missing(aedecod) then delete;
run;

/*sorting data to remove duplicate obs*/

proc sort data=a1 out = sort nodupkey;
by trt01a usubjid aebodsys aedecod;
run;
/*incidence of teae by soc*/
proc sql;
create table aa as select count(distinct usubjid) as n,trt01a,aebodsys
from sort
group by trt01a,aebodsys
order by trt01a ,aebodsys;
quit;
/*incidence of teae by PT*/
proc sql;
create table ab as select count(distinct usubjid) as n,trt01a,aebodsys,aedecod
from sort
group by trt01a,aebodsys,aedecod
order by trt01a ,aebodsys,aedecod;
quit;

/*assigning levels */
data aasoc;
set aa;
length display $50. aedecod $50.;
display_=aebodsys;
aedecod=' ';
level='1';
run;

data abpt;
set ab;
length display $50. aedecod $50.;
display_=cats(' ',aedecod);
level='2';
run;

/*merging dataset*/
data bfin;
set aasoc abpt;
run;

/*calculating denominator to calculate percentage*/
proc summary data=sort;
class trt01a;
output out=zdenom (drop= _type_ rename=(_freq_=total_n));
run;

/*creating dataset with count percent*/
proc sql ;
create table cf as select a.*,b.total_n,
(a.n/b.total_n)*100 as percent format =5.1
from bfin as a
left join zdenom as b
on a.trt01a =b.trt01a;
quit;

/*formating*/
data v (drop=pct percent total_n n);
set cf;
length count $15.;
pct= cats('(',put(percent,5.1),')');
count=cats(n,pct);
run;

/*transposing dataset*/
proc sort data=v out=bfin1;
by  aebodsys level aedecod;
run;
proc transpose data= bfin1 out=bf2 (drop=_name_);
by  aebodsys level aedecod;
id trt01a;
var count;
run;
data bf3;
set bf2;
if level= '1' then aebodsys=aebodsys;
else if level='2' then aebodsys=aedecod;
if missing(a) then a='0(00.0)';
if missing(b) then b='0(00.0)';
if missing(c) then c='0(00.0)';
run; 
/*creating no of sub with atleast one adr*/
proc sql;
create table first as select trt01a,count(distinct usubjid)as n_c
from sort 
where teae='Y'
group by trt01a;
quit;

proc sql ;
create table frow as select a.*,b.total_n,
(a.n_c/b.total_n)*100 as percent format =5.1
from first as a
left join zdenom as b
on a.trt01a =b.trt01a;
quit;
data headr;
length aebodsys $200 a b c $20;
aebodsys="Number of subjects with atleast one adverse event";
a='4(18.2)';
b='4(14.3)';
c='4(20.0)';
order=0;
output;
run;

libname cs9 "E:\Raw Data\CASE STUDIES\CS009\OUTPUT";
data cs9.ae (drop= order level aedecod rename=(a=TRTA B=TRTB C=TRTC));
retain obs aebodsys a b c;
set headr bf3;
obs=_n_;
run;

/*reporting file*/
proc report data=cs9.ae nowd;
column obs aebodsys TRTA TRTB TRTC;
define obs/display 'Obs';
define aebodsys/display;
define TRTA/display  ;
define TRTB/display ;
define TRTC/display ;
run;

proc printto;
run;
