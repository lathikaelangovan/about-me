library(safetyData)
library(haven)
library(dplyr)
library(stringr)

#importing raw data
df<- read_sas("E:/rprogram/learnprog/source/lib_s/sas/cm.sas7bdat")
adsl<- read_sas("E:/rprogram/learnprog/source/lib_a/sas/adsl.sas7bdat")


df1<-left_join(df,adsl,by=c("USUBJID","STUDYID")) |> 
  mutate(
    #assigning trt01p to trtp
    TRTP=TRT01P,
    #assining trt01pn to trtpn
    TRTPN=TRT01PN,
    #assigning trt01a to trta when saffl is "y"
    TRTA= ifelse(SAFFL=="Y",TRT01A,NA),
    #assigning trt01an to trtan when saffl is "y"
    TRTAN= ifelse(SAFFL=="Y",TRT01AN,NA)
  )

df2<- df1 |> 
  mutate(
  #deriving ASTDT variable
    ASTDT= std_imput(CMSTDTC,TRTSDT),
    PREFL=ifelse(ASTDT<TRTSDT,"Y",NA_character_),
    ONTRTFL=if_else(ASTDT>TRTSDT,"Y",NA_character_),
    APHASEN=
      case_when((PREFL=="Y") ~  0,
                (ONTRTFL=="Y") ~1),
    #assigning aphasen to aphase
    APHASE=case_when(
      APHASEN==0  ~ "Screening Phase",
      APHASEN==1  ~ "Treatment Phase"
    ),
    
    #deriving ASTDY
    ASTDY= case_when(
      ASTDT>=TRTSDT ~ (ASTDT-TRTSDT)+1,
      ASTDT < TRTSDT ~(ASTDT-TRTSDT)
    ),
    #Deriving ASTDTF
    ASTDTF= case_when(
      (str_length(CMSTDTC)==7 & !is.na(ASTDT)) ~ "D",
      str_length(CMSTDTC)==4 & !is.na(ASTDT) ~"M"),
    
    #end date imputation
    AENDT=endt_imput(CMENDTC,TRTEDT),
    AENDY=case_when(
      (AENDT >= TRTSDT) ~  (AENDT-TRTSDT)+1,
      AENDT < TRTSDT   ~ (AENDT-TRTSDT)
    ),
      
    #end date imputation flag derivation
    AENDTF=case_when(
      (str_length(CMENDTC)==7 & !is.na(AENDT)) ~ "D",
      (str_length(CMENDTC)==4 & !is.na(AENDT)) ~ "M"
    ),
    # deriving contrtfl variable
    CONTRTFL=case_when(
      SAFFL=="Y" &  ((ASTDT>= TRTSDT) | (AENDT <= TRTEDT)) ~ "Y"
    )
  )

adcm<- df2 |> 
  arrange(USUBJID,CMTRT,ASTDT,CMSEQ) |> 
  select(STUDYID, USUBJID, SUBJID,SITEID, SITEGR1, ARM,TRT01P,TRT01PN,
         TRT01A,TRT01AN,TRTSDT, TRTEDT, AGE,RACE,RACEN, SEX,SAFFL,ITTFL,
         EFFFL, COMP8FL, COMP16FL, COMP24FL,TRTP,TRTPN,TRTA, TRTAN, CMSEQ,
         CMSPID, CMTRT,CMDECOD,CMINDC,CMCLAS,CMDOSE,CMDOSU,CMDOSFRQ,CMROUTE,
         CMSTDTC,APHASEN,APHASE,ASTDT,ASTDY,ASTDTF,CMENDTC,CMSTDY,AENDT,AENDY,
         AENDTF,CMENDY,PREFL,ONTRTFL,CONTRTFL) 

label<- c('Study Identifier',
          'Unique Subject Identifier',
          'Subject Identifier for the Study',
          'Study Site Identifier',
          'Pooled Site Group 1',
          'Description of Planned Arm',
          'Planned Treatment for Period 01',
          'Planned Treatment for Period 01 (N)',
          'Actual Treatment for Period 01',
          'Actual Treatment for Period 01 (N)',
          'Date of First Exposure to Treatment',
          'Date of Last Exposure to Treatment',
          'Age',
          'Race',
          'Race (N)',
          'Sex',
          'Safety Population Flag',
          'Intent-To-Treat Population Flag',
          'Efficacy Population Flag',
          'Completers of Week 8 Population Flag',
          'Completers of Week 16 Population Flag',
          'Completers of Week 24 Population Flag',
          'Planned Treatment',
          'Planned Treatment (N)',
          'Actual Treatment',
          'Actual Treatment (N)',
          'Sequence Number',
          'Sponsor ID',
          'Concomitant Treatment',
          'Preffered Term',
          'Indication',
          'Concomitant Medication Class',
          'Concomitant Medication Dose',
          'Concomitant Medication Dose Unit',
          'Concomitant Medication Dose frequency',
          'Concomitant Medication Route',
          'Concomitant Medication Start Date',
          'Phase (N)',
          'Phase',
          'Analysis Start Date',
          'Analysis Start Day',
          'Analysis Start Date Imputation Flag',
          'Concomitant Medication End Date',
          'Concomitant Medication Start Day',
          'Analysis End Date',
          'Analysis End Day',
          'Analysis End Date Imputation Flag',
          'Concomitant Medication End Day',
          'Prior Treatment Flag',
          'On-Treatment Flag',
          'Concomitant Treatment Flag'  )
  
varnam<-names(adcm)
#labelling variables in final dataset
  for (i in 1:length(varnam)) {
    attr(adcm[[varnam[i]]],"label")<- label[i] 
  }
#labelling adcm dataset
 attr(adcm,"label")<-"Concomitant Medication Analysis Dataset" 
