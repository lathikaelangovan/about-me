

/*Case Study : 4 
 
Project Title  : Summary of Demographic tables 
Project code   : CCS004 
Description    : Generate a Demographics table */



proc printto log= "E:\Raw Data\CASE STUDIES\CS004\OUTPUT\demog.log";
run;
libname case4 "E:\Raw Data\CASE STUDIES\CS004\RAW DATA";

proc format ;
value armft
0="Placebo"
1="Active";
value genderft
1="Male"
2="Female";
run;
data dm (drop=gender);
set case4.dm;
gen= put(gender,genderft.);
format arm armft. gender genderft.;
run;

proc means data=dm n mean std median Q1 Q3 min max;
var age;
class arm;
output out= age_sum
N=N mean=mean std=std median=median Q1=Q1 Q3=Q3 min=min max=max;
run;

/*deriving variables*/

data age1 (drop=_type_ _freq_ Q1 Q3 min max n std mean median rename=(n1=N mean1=MEAN median1=MEDIAN ));
set age_sum;
if _type_=1;
Q1_Q3= catx("-",put(Q1,4.1),put(Q3,4.1));
MIN_MAX= catx("-",min,max);
n1=put(N,8.);
SD=put(std,4.1);
mean1=put(mean,4.1);
median1=put(median,4.1);
run;
proc transpose data= age1 out= age2(drop=_label_ rename=(_name_=gen));
id arm;
var N MEAN SD MEDIAN Q1_Q3 MIN_MAX;
run;

/**proc freq*/

proc freq data= dm;
table gen*arm/nocum out=gen_f;
format percent 3. ;
run;
data gen1 (drop= count percent per);
length cp $8. per $5.;
set gen_f;
per= cats("(",put(percent,3.),"%)");
cp= cats(count,per);
run;
proc sort data= gen1  out=gen2;
by  gen;
run;
proc transpose data=gen2 out= g1 (drop=_name_);
by gen;
id arm;
var cp;
run;

/*assigning row order number*/

data final;
length gen $7. active placebo $15.;
set g1 age2;
    if gen = 'Male' then row_order = 2;
    else if gen = 'Female' then row_order = 3;
    else if gen = 'N' then row_order = 5;
    else if gen = 'MEAN' then row_order = 6;
    else if gen = 'SD' then row_order = 7;
    else if gen = 'MEDIAN' then row_order = 8;
    else if gen = 'Q1_Q3' then row_order = 9;
    else if gen = 'MIN_MAX' then row_order = 10;
run;

data headers;
length gen $15. active $15. placebo $15.;
       gen = 'Gender';
    Active = '';
    Placebo = '';
    row_order = 1;
    output;

    gen = 'Age';
    Active = '';
    Placebo = '';
    row_order = 4;
    output;
run;
proc sort data= final;
by row_order;
run;
proc sort data= headers;
by row_order;
run;

/*final dataset for creating report*/

libname c4 "E:\Raw Data\CASE STUDIES\CS004\OUTPUT";

data c4.demog (drop= row_order rename=(gen=parameter ));
length gen $15. active $15. placebo $15.;
merge headers(in=a) final(in=b);
by row_order;
run;
proc print data=c4.demog;
run;

/*creating rtf reporting output*/

options nodate nonumber;
ods rtf file="E:\Raw Data\CASE STUDIES\CS004\OUTPUT\demog.rtf";
title "Table 4: Demographic Characteristics";
proc report data=c4.demog nowd;
column parameter active placebo;
define parameter/display " " width=15;
define active/display "Active N=xx(xx%)";
define placebo/display "Placebo N=xx(xx%)";
run;
title;
ods rtf close; 

proc printto;
run;

















 
