
 
/*Case Study : 6 
 
Project Title : Analysis subject level Dataset. 
 
Project code  : CCS006 
 
Description   : Analysis dataset creation of SL (Subject Level)*/



proc printto log="E:\Raw Data\CASE STUDIES\CS006\OUTPUT\SL.log";
run;
/*importing raw data*/
proc import datafile="E:\Raw Data\CASE STUDIES\CS006\RAW DATA\Base.csv"
out= base
dbms= csv;
run;

proc import datafile="E:\Raw Data\CASE STUDIES\CS006\RAW DATA\SL.xls"
out= sl
dbms= xls replace;
getnames=no;
run;

data ss ;
set sl (firstobs=5);
rename a=subjectid
b=siteid
c=sex
d=startdate
e=enddate
f=birthdate
g=wt
h=initial;
run;
data s (drop=i sub siteid subjectid);
set ss;
subject=input(subjectid,4.);
site=input(siteid,4.);
run;

proc sql;
create table best as select a.*,b.* 
from base as a
left join s as b on a.subject=b.subject and a.site=b.site;
quit;

/*TASK:1*/
/*DATA CLEANING*/
libname cs6 "E:\Raw Data\CASE STUDIES\CS006\OUTPUT";

proc sort data=best out= SL1
dupout= cs6.SL_Dup nodupkey;
by subject site;
run;

/*TASK:2*/
/*PARTIAL DATE*/

data sam (drop=bda bmon byr day month year hour minute sec  startdate) ;
set sl1;
day=input(scan(startdate,1,":"),??best.);
month=input(scan(startdate,2,":"),??best.);
year=input(scan(startdate,3,":"),??best.);
hour=input(scan(startdate,4,":"),??best.);
minute=input(scan(startdate,5,":"),??best.);
sec=input(scan(startdate,6,":"),??best.);
/*startdate imputation*/
if missing(month)& year ^=. then month= 1;
if missing(day) and month in (1,2,3,4,5,6)then day=1;
if missing(day) and month in (7,8,9,10,11,12)then day= 30;
if missing(month) and 1<=day<=15 then month= 1;
if missing(month) and 16<=day<=31 then month= 12;
/*time imputation*/
if missing(hour) & missing(year) then hour=0;
if missing(minute)then minute=0;
if missing(sec)then sec=0;
startdate_1= mdy(month,day,year);
startdate_=dhms(startdate_1,hour,minute,sec);
edate=input(substr(enddate,1,10),mmddyy10.);
/*birthdate imputation*/
if index(strip(birthdate),"unk")then do;
bda=scan(birthdate,1,'/');
bmon=scan(birthdate,2,'/');
byr=scan(birthdate,3,'/');
end;
if bmon='unk' and 1<=bda<=15 then bmon= 1;
if bda='unk' and bmon in (1,2,3,4,5,6)then bda= 1;
birthdate_=mdy(bmon,bda,byr);
birth_date= strip(birthdate);

format startdate_1 edate birthdate_ mmddyy10.  startdate_ datetime20.;
run;
proc print data= sam;
run;

/*formatting start date day and month in two digits*/
data p1;
set sam;
if missing(startdate_) then delete;
startdate = catx(':',
    put(day(datepart(startdate_)), z2.),
    put(month(datepart(startdate_)), z2.),
    put(year(datepart(startdate_)), 4.),
    put(hour(startdate_), z2.),
    put(minute(startdate_), z2.),
    put(second(startdate_), z2.)
);
run;
proc print data=p1;
run;

/*Task 3*/
/*deriving variables*/

data var (drop=birth_date birthdate weight rename=(birthdate_=birthdate));
set p1;
if missing(birthdate_) then birthdate_=birth_date;
Age=abs(intck("years",birthdate_,startdate_1));
Days=intck("days",startdate_1,edate);
Months=intck('months',startdate_1,edate);
Years=intck('years',startdate_1,edate);
weight= input(substr(wt,1,5),6.); 
Wt= cats(put(weight,8.1),"Kg");
label days= No of days
      Months=No of months
	  Years=No of years
	  wt=Weight(In Kgs);
format weight 5.1 ;
run;
proc print data =var;
run;

proc format;
value $sexft
"M"="Male"
"F"="Female";
run;

/*Task 4*/
/*decode data*/

data cs6.SL (label= Subject level drop=sex  startdate_);
retain name height subject site gender startdate enddate birthdate wt initial ;
set var;
Gender=propcase(sex);
format gender $sexft.;
run;
proc print data =cs6.sl;
run;

proc printto;
run;
