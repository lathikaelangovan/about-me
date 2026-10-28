############################################
# Program name    : test_01.r
# Assignment Date : 18Aug2026
# Description     : To perform conditional processing
#                  using various R functions
#modification history
############################################

# libraries
library(readxl)
library(dplyr)

# Q : 1

# import excel file into r
subject_data <- read_excel("r_22Jun2026/subject_data.xlsx")

## to find no of rows in df :
nrow(subject_data)
## to find no of columns in df :
ncol(subject_data)
## to view the basic st of df :
structure(subject_data)
## to list all variable names :
names(subject_data)  


# Q : 2

#if statement

if(nrow(subject_data) > 100){
  print("Large dataset")
  
}else{
  print("smaller dataset")
}

# Q : 3

#ifelse chain
subject_data$AGECAT <- ifelse(subject_data$AGE < 18, "Child",
                              ifelse((subject_data$AGE >= 18 & subject_data$AGE <= 40), "Young adult",
                                    ifelse((subject_data$AGE >= 41 & subject_data$AGE <= 65), "Adult",
                                          ifelse(subject_data$AGE > 65 ,"Senior",NA_character_))))

# ---- dplyr method ----

subject_data$AGECAT <- case_when(
                       (subject_data$AGE < 18) ~ "Child",
                       (subject_data$AGE>= 18 & subject_data$AGE <=40) ~ "Young adult",
                       (subject_data$AGE>= 41 & subject_data$AGE <=65) ~ "Adult",
                       (subject_data$AGE >65) ~ "Senior",
                        TRUE ~ NA_character_)                           


subj <- subject_data %>% 
   filter(AGE > 18 & DOSE > 0) %>% 
  mutate(
    ### Q  :
    AGECAT = case_when(
    (AGE < 18) ~ "Child",
    (AGE>= 18 & AGE <=40) ~ "Young adult",
    (AGE>= 41 & AGE <=65) ~ "Adult",
    (AGE >65) ~ "Senior",
    TRUE ~ NA_character_),                           
    
    ### Q  :4
    
    SAFFL = if_else(DOSE > 0, "Y","N"),
    
    ### Q  :5
    
    LABSTAT = case_when(
      (AVAL > ULN) ~ "High",
      (AVAL < 0.8*ULN) ~ "Low",
      TRUE ~ "normal"
    ),
    
    ### Q :6
    
    SNRFL = if_else( AGE>= 65 , "Senior","Non senior" )
    
    
  )

### Q :7

subj_1 <- subject_data %>% 
  filter(TRTEMFL == "Y" ,AESEV =="SEVERE")


### Q :8
 subj$visit_label <- sapply(subj$VISIT,function(visit){
   switch(as.character(visit),
          "1" = "Screening",
          "2" = "Baseline",
          "3" = "Week 1",
          "4" = "Week 2",
          "5" = "Week 4",
          "Unknown Visit")
 })

 ### Q :9
 
 anyNA(subj$AGE,recursive = FALSE)
 anyNA(subj$AVAL,recursive = FALSE)  
 anyNA(subj$DOSE,recursive = FALSE)
 
 ### Q :10
 
stopifnot(subj$AGE > 0)
stopifnot(subj$DOSE>= 0,local = TRUE)
stopifnot(subj$USUBJID,local = TRUE)

# Q : 11

excel <- tryCatch(
  expr = {
    library(readxl)
    dataset <- read_excel(NULL)
    View(dataset)
  },
  error = function(e){
    stop("Dataset could not be imported")
  }
  
)

# Q : 12

subj_1 <- subj%>%
  mutate(
    ANALYSIS_STARTDT= coalesce(AESTDT,TRTSDT)
    
  )
