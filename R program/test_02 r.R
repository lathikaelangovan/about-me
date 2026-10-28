# ############################ #
# program name:test_02.R
# date of creation :26Jun2026
# Program purpose :clinical data cleaning.
# modification history
# ########################### #
### assignment : 2

library(dplyr)

#install.packages("stringr")
library(stringr)
# Q : 1 import dataset

library(readxl)

clinical_data <- read_excel("E:/rprogram/learnprog/clinical_subject_data.xlsx")
View(clinical_data)

# Q : 2
# display first 10 rows

head(clinical_data, n = 10)

# last 10 rows

tail(clinical_data,n = 10)

# Q :3
# standardizing names
clinical_data1 <- clinical_data %>%
  mutate(
   TRTGRP = str_to_upper(TRTGRP),
   
   
   # Q:4
   #trim subjid
   
   USUBJID = str_trim(USUBJID,side = "both"),
   
   # Q :5
   #uppercase ids
  
   USUBJID = str_to_upper(USUBJID),
   
   # Q :6
   #validated id with regex
   
     
 VALID_ID = str_detect(USUBJID,"^SUBJ-\\d{3}$"),
 
 #Q : 8
 # to extract numric id
 
 SUBJECT_NUMBER = str_extract(USUBJID,"\\d+"),
 
 # Q :9
 # create vatriable site using subid
 
 SITE = str_extract(USUBJID,"^SUBJ"),
 
 # Q : 10
 # use str_c & form new identy
 
 NEW_IDENTY = str_c("STUDY",1:20,"-SUBJ-",SUBJECT_NUMBER),
 
 # Q : 11
 # to remove multiple spaces
 
COMMENTS = str_squish(COMMENTS),
 
 # Q :12
 # using srting replacement function
 
 COMMENTS = str_replace_all(COMMENTS,"[@,!,#,*]"," "),



# Q : 14

PATIENT_SUMMARY = str_c(USUBJID,SEX,TRTGRP,AGE,sep = " | ")
 

  )

# Q :7
# to show invalid id
INVALID<- clinical_data1[clinical_data1$VALID_ID==FALSE, ]
  
# Q : 13
# use dplyr filter

clinical_data_filtered <- clinical_data1 %>%
  filter(TRTGRP == "DRUG A" & AGE > 50 )

clinical_data_severe <- clinical_data1 %>%
  filter(AESEV == "severe")

write.csv(clinical_data1,file="E:/rprogram/learnprog/clinical_data1.csv")

    
  


