# ############################ #
# program name:adam_ae.R
# date of creation : 06Oct2026
# Program purpose :To create adverse event analysis dataset.
# modic=fication history
# ########################### #


##adam dataset

library(haven)
library(stringr)
library(dplyr)
library(lubridate)
adsl<-read_sas("source/lib_a/sas/adsl.sas7bdat",NULL)

ae <- read_sas("source/lib_s/sas/ae.sas7bdat", NULL)

adae<- merge(ae,adsl,by= c("STUDYID","USUBJID"))

df2<- adae %>% 
  mutate( 
    TRTA=TRT01A,
    TRTAN= TRT01AN,
    ASTDT= std_imput(aestdtc = AESTDTC,trtsdt = TRTSDT), 
    ASTDTF= case_when(
      str_length(AESTDTC)>=7 &  !is.na(ASTDT)  ~ "D",
      str_length(AESTDTC)>=4 &  !is.na(ASTDT)  ~ "M"
    ),
    ASTDY= case_when(
     !is.na(ASTDT) & !is.na(TRTSDT) & ASTDT>=TRTSDT ~ ASTDT-TRTSDT+1,
     !is.na(ASTDT) & !is.na(TRTSDT) & TRTSDT>ASTDT ~ ASTDT-TRTSDT
    ),
  
    AENDT = endt_imput(aeendtc = AEENDTC,trtedt = TRTEDT),
    AENDY= case_when(
      !is.na(AENDT) & !is.na(TRTSDT) & AENDT>=TRTSDT ~ AENDT-TRTSDT+1,
      !is.na(AENDT) & !is.na(TRTSDT) &  TRTSDT>AENDT ~ AENDT-TRTSDT
    ),
    
    ADURN = (AENDT- ASTDT)+1,
    
    ADURU= ifelse(!is.na(ADURN),"DAY"," "),
    TRTEMFL = ifelse(!is.na(ASTDT)& !is.na(TRTSDT),"Y","N") 
    
    )


##FUNCTION FOR FLAGGING

flg_1st_occ <- function(indf,cond,sort_var,grp_var,varnam){
  
  aa <- {{indf}} |> 
    filter({{cond}}) |> 
    arrange(across(all_of(sort_var))) |> 
    group_by(across(all_of(grp_var))) |> 
    mutate(
      !!sym(varnam) := if_else(row_number()==1,"Y"," ")
    ) |> 
    ungroup() |> 
    filter(!!sym(varnam)=="Y") |> 
    select(all_of(sort_var),!!sym(varnam))
  
  bb <- left_join({{indf}},aa, by = sort_var)
  
  return(bb)
  
}
#AOCCFL FLAGING 
df3 <- flg_1st_occ(indf =  df2, 
                   cond = (TRTEMFL=="Y"),
                   sort_var = c("USUBJID","ASTDT","AESEQ"),
                   grp_var = "USUBJID",
                   varnam  = "AOCCFL"
)
#AOCCSFL flaging
df4 <- flg_1st_occ(indf =  df3, 
                   cond = (TRTEMFL=="Y"),
                   sort_var = c("USUBJID","AEBODSYS","ASTDT","AESEQ"),
                   grp_var = c("USUBJID","AEBODSYS"),
                   varnam  = "AOCCSFL"
)

#AOCCPFL FLAGING
df5 <- flg_1st_occ(indf =  df4, 
                   cond = (TRTEMFL=="Y"),
                   sort_var = c("USUBJID","AEBODSYS","AEDECOD","ASTDT","AESEQ"),
                   grp_var = c("USUBJID","AEBODSYS","AEDECOD"),
                   varnam  = "AOCCPFL"
)

#aocc02fl flaging
df6 <- flg_1st_occ(indf =  df5, 
                   cond = (TRTEMFL=="Y" & AESER =="Y"),
                   sort_var = c("USUBJID","ASTDT","AESEQ"),
                   grp_var = "USUBJID",
                   varnam  = "AOCC02FL"
)

#AOCC03FL
df7 <- flg_1st_occ(indf =  df6, 
                   cond = (TRTEMFL=="Y" & AESER =="Y"),
                   sort_var = c("USUBJID","AEBODSYS","ASTDT","AESEQ"),
                   grp_var = c("USUBJID","AEBODSYS"),
                   varnam  = "AOCC03FL"
)

##AOCC04FL FLAGING
df8 <- flg_1st_occ(indf =  df7, 
                   cond = (TRTEMFL=="Y" & AESER =="Y"),
                   sort_var = c("USUBJID","AEBODSYS","AEDECOD","ASTDT","AESEQ"),
                   grp_var = c("USUBJID","AEBODSYS","AEDECOD"),
                   varnam  = "AOCC04FL"
)

#CQ01NAM

  df9 <- df8 |> 
  mutate(
    TRTEMFL = if_else((!is.na(ASTDT) & !is.na(TRTSDT) & ASTDT >= TRTSDT),"Y","N" ),
    CQ01NAM = case_when(
      str_detect(AEDECOD,'APPLICATION|DERMATITIS|ERYTHEMA|BLISTER') ~ 'DERMATOLOGIC EVENTS',
      (str_remove_all(AEBODSYS," ") == 'SKINANDSUBCUTANEOUSTISSUEDISORDERS' 
       & !(AEDECOD %in% c('COLD SWEAT','HYPERHIDROSIS','ALOPECIA'))) ~ 'DERMATOLOGIC EVENTS',
      TRUE ~ " "
    )
  )
  
  #AOCC01FL 
  df9 <- flg_1st_occ(indf =  df9, 
                     cond = (CQ01NAM==" " & TRTEMFL =="Y"),
                     sort_var = c("USUBJID","ASTDT","AESEQ"),
                     grp_var = "USUBJID",
                     varnam  = "AOCC01FL"
  )

  #ASEQ DERIVATION
  
  df9 <- df9 %>% 
    arrange(USUBJID,AEDTC,ASTDT,AESPID,AEBODSYS,AEDECOD,AETERM,AESEQ) %>% 
    group_by(USUBJID) %>% 
    mutate(
     ASEQ = row_number()
    ) %>% 
    ungroup() 
  
  final <- df9 |> 
    select(STUDYID,SITEID,USUBJID,TRTA,TRTAN,AGE,AGEGR1,AGEGR1N,RACE,RACEN,SEX,SAFFL,TRTSDT,TRTEDT,ASTDT,ASTDTF,ASTDY,AENDT,AENDY,ADURN,ADURU,
           AETERM,AELLT,AELLTCD,AEDECOD,AEPTCD,AEHLT,AEHLTCD,AEHLGT,AEHLGTCD,AEBODSYS,AESOC,AESOCCD,AESEV,AESER,AESCAN,AESCONG,AESDISAB,AESDTH,AESHOSP,AESLIFE,AESOD,
           AEREL,AEACN,AEOUT,AESEQ,TRTEMFL,AOCCFL,AOCCSFL,AOCCPFL,AOCC02FL,AOCC03FL,AOCC04FL,CQ01NAM,AOCC01FL) |> 
    arrange(USUBJID,ASTDT,AETERM,AESEQ)
  
  lbl <- c('Study Identifier',
           'Study Site Identifier',
           'Unique Subject Identifier',
           'Actual Treatment',
           'Actual Treatment (N)',
           'Age',
           'Pooled Age Group 1',
           'Pooled Age Group 1 (N)',
           'Race',
           'Race (N)',
           'Sex',
           'Safety Population Flag',
           'Date of First Exposure to Treatment',
           'Date of Last Exposure to Treatment',
           'Analysis Start Date',
           'Analysis Start Date Imputation Flag',
           'Analysis Start Relative Day',
           'Analysis End Date',
           'Analysis End Relative Day',
           'AE Duration (N)',
           'AE Duration Units',
           'Reported Term for the Adverse Event',
           'Lowest Level Term',
           'Lowest Level Term Code',
           'Dictionary-Derived Term',
           'Preferred Term Code',
           'High Level Term',
           'High Level Term Code',
           'High Level Group Term',
           'High Level Group Term Code',
           'Body System or Organ Class',
           'Primary System Organ Class',
           'Primary System Organ Class Code',
           'Severity/Intensity',
           'Serious Event',
           'Involves Cancer',
           'Congenital Anomaly or Birth Defect',
           'Persist or Signif Disability/Incapacity',
           'Results in Death',
           'Requires or Prolongs Hospitalization',
           'Is Life Threatening',
           'Occurred with Overdose',
           'Causality',
           'Action Taken with Study Treatment',
           'Outcome of Adverse Event',
           'Sequence Number',
           'Treatment Emergent Analysis Flag',
           '1st Occurrence of Any AE Flag',
           '1st Occurrence of SOC Flag',
           '1st Occurrence of Preferred Term Flag',
           '1st Occurrence 02 Flag for Serious',
           '1st Occurrence 03 Flag for Serious SOC',
           '1st Occurrence 04 Flag for Serious PT',
           'Customized Query 01 Name',
           '1st Occurrence 01 Flag for CQ01')
  
  for (l in 1:length(lbl)) {
    i <- names(final)[l]
    attr(final[[i]],"label") <- lbl[l]
  }
  
write_sas(final,"E:/rprogram/learnprog/source/lib_a/final.sas")

## execute the validation to view descrepencies in console
validate_adae(final)  
