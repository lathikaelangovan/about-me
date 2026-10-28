

/*Case Study : 10 
 
Project Title  : Graph 
Project code   : CCS0010 
Description    : Generate vertical Graph */



proc printto log="E:\Raw Data\CASE STUDIES\CS010\OUTPUT\Graph.log";
run;

libname cs10 "E:\Raw Data\CASE STUDIES\CS010\RAW DATA";

proc format;
value monthft
1="Jan"
2="Feb"
3="Mar"
4="Apr"
5="May";
run;

/*graph1*/
ods rtf file="E:\Raw Data\CASE STUDIES\CS010\OUTPUT\Graph.rtf";
goptions hsize=10in vsize=10in;
proc gchart data= cs10.profit;
vbar month/sumvar=sales type=sum discrete raxis= 0 to 80 by 10 ;
run;
quit;

/*graph2*/
goptions hsize=10in vsize=10in;
proc gchart data=cs10.profit;
format month monthft.;
vbar month/sumvar=sales discrete subgroup=month patternid=subgroup raxis= 0 to 80 by 10 minor=10 legend ;
pattern1 v=s c=blue;
pattern2 v=empty c= blue;
pattern3 v=l1 c=blue;
pattern4 v=r2 c=blue;
pattern5 v=x3 c=blue;
run;
quit;

/*graph3*/
goptions hsize=10in vsize=10in;
proc gchart data= cs10.totals;
format sales dollar6.;
vbar site/sumvar=sales  ;
run;
quit;

ods rtf close;
proc printto;
run;
