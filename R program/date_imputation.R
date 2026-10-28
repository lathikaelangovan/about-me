# ############################ #
# program name: date_imputation.R
# date of creation : 02Oct2026
# Program purpose :To impute start date and end date as per specification.
# modification history
# ########################### #


##Functions...

library(haven)
library(stringr)
library(lubridate)
library(dplyr)
library(tidyr)
#start date imputation


ae <- read_sas("source/lib_s/sas/ae.sas7bdat", NULL)
View(ae)
adsl <- read_sas("source/lib_a/sas/adsl.sas7bdat",NULL)
View(adsl)



###start date imputation

dtc<- ae$AESTDTC
trtsdt<- ae$TRTSDT

stdt_imputation<- function(dtc,trtsdt){
  if (!is.Date(trtsdt)) {
    stop("Provided `treatment start date is not in date format.")
  }
  
  yy<- is.numeric(str_split_i(dtc,'-',1))
  mm<- is.numeric(str_split_i(dtc,'-',2))
  dd<- is.numeric(str_split_i(dtc,'-',3))
  
  
  trty <- year(trtsdt)
  trtm <- month(trtsdt)
  
  if (is.na(yr) | dtc == ""){
    return(NA_integer_)
  }
  
  if (str_length(dtc) >= 10){
    dat_ <- substr(dtc,1,10)
  }
  
  
  # date missing
  if (is.na(dt) & !is.na(mn)) {
    
    if ((!is.na(yr) | yr != "") & ((mn != trtm) )  ){
      dat_ <- str_c(dtc,"01",sep = "-")  ## impute logic B
      message(paste("impute logic B is used for",dtc))
    }
    
    if ((!is.na(yr) | yr != "") & ((mn == trtm) & (yr == trty) )  ){
      dat_ <- as.character(trtsdt) ## impute logic A
      message(paste("impute logic A is used for",dtc))
    }
    
    if ((!is.na(yr) | yr != "") & ((mn == trtm) & (yr != trty) )  ){
      dat_ <- str_c(dtc,"01",sep = "-")  ## impute logic B
      message(paste("impute logic B is used for",dtc))
    }
  }
  
  
  
  # month and date missing
  if (is.na(mn)) {
    if ((!is.na(yr) | yr != "") & (yr == trty) ) {
      dat_ <- as.character(trtsdt) ## impute logic A
      message(paste("impute logic A is used for",dtc))
    }
    
    if ((!is.na(yr) | yr != "") & (yr != trty) ) {
      dat_ <- str_c(dtc,"01-01",sep = "-")  ## impute logic C
      message(paste("impute logic C is used for",dtc))
    }
  }
  
  dat <- as.Date(dat_)
  
  return(dat)
  
}



####end date imputation


edt<-ae$AENDT
trtedt<-ae$TRTEDT
impute_enddate<- function(edt,TRTEDT){
  
  if (!is.Date(trtedt)) {
    stop("Provided `treatment end date is not in date format.")
  }
  
  yr <- as.numeric(str_split_i(edt,"-",1))
  mn <- as.numeric(str_split_i(edt,"-",2))
  dt <- as.numeric(str_split_i(edt,"-",3))
  
  trtyr <- year(trtedt)
  trtmm <- month(trtedt)
  
  if (is.na(yr) | edt == ""){
    return(NA_integer_)
  }
  
  if (str_length(edt) >= 10){
    dat_ <- substr(edt,1,10)
  }
  
  
  # date missing
  if (is.na(dt) & !is.na(mn)) {
    
    if ((!is.na(yr) | yr != "") & ((mn != trtmm) )  ){
      dat_ <- str_c(edt,"01",sep = "-")  ## impute logic B
      message(paste("impute logic B is used for",edt))
    }
    
    if ((!is.na(yr) | yr != "") & ((mn == trtmm) & (yr == trtyr) )  ){
      dat_ <- as.character(trtedt) ## impute logic A
      message(paste("impute logic A is used for",edt))
    }
    
    if ((!is.na(yr) | yr != "") & ((mn == trtmm) & (yr != trtyr) )  ){
      dat_ <- str_c(edt,"01",sep = "-")  ## impute logic B
      message(paste("impute logic B is used for",edt))
    }
  }
  
  # month and date missing
  if (is.na(mn)) {
    if ((!is.na(yr) | yr != "") & (yr == trtyr) ) {
      dat_ <- as.character(trtedt) ## impute logic A
      message(paste("impute logic A is used for",edt))
    }
    
    if ((!is.na(yr) | yr != "") & (yr != trtyr) ) {
      dat_ <- str_c(edt,"01-01",sep = "-")  ## impute logic C
      message(paste("impute logic C is used for",dtc))
    }
  }
  if(AEENRF=="ONGOING"|is.na(AEENRF)){
    AENDT=NA
    AENDTF=NA
  }
  else if(AEENRF=="BEFORE"&ASTDT<trtsdt){
    AENDT=trtsdt
    AENDTF="D"
  }
  end_dat <- as.Date(dat_)
  
  return(end_dat)
  
}

# testing my function
ae_f<- merge(ae,adsl,by= "USUBJID")

adae<- ae_f %>% (
  mutate(
    astdt<- stdt_imputation(aestdtc,trtsdt)
    
  )
)
