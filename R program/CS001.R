
# CLINICAL CASE STUDY: 1
#Project Title: Dataset creation and Listing generation 
#Project code : CCS001 
# Description : Listing of demographic data. 
##################################################
  
library(haven)
library(dplyr)
library(readxl)
library(lubridate)
library(openxlsx)

#TASK:1
 
  
 # a) Create a dataset & named it as demo.(label : Demography) 
#b) Derive BMI variable as Weight (kg) / [Height (m) x Height (m)] & 
#Label it as Body Mass Index. 
#c) Assign format to a Gender variable (1=Male, 2=Female). 
#d) Keep Subject Gender BMI. 
#e) Print the dataset to output window. (Lst file by using proc print to) 

#Input dataset: Demographics    :    Output: demo.sas7bdat, Demo.lst.

df1<- read.csv("E:/Raw Data/CASE STUDIES/CS001/RAW DATA/demography.csv")
df2<- read_excel("E:/Raw Data/CASE STUDIES/CS001/RAW DATA/visit.xls")

df3<- df2 %>% 
  mutate(
    PATID= pat
  )
df4<- left_join(df1,df3,by="PATID")                      
df5 <- df4 %>% 
  mutate(
    Subject=PATID,
    BMI= round((weight/(height**2)*703.1),2),
    Gender= case_when(
      SEXCD==1 ~"Male",
      SEXCD==2 ~ "Female"), 
    
    Category = case_when(
      BMI>=35 ~ "Very obese",
      BMI>=30 & BMI <=34.9 ~ "obese",
      BMI>=25 & BMI<=29.9 ~ "overweight",
      BMI>=18.5 & BMI<=24.9 ~ "Normal",
      BMI>=16 & BMI<=18.4 ~ "Under weight",
      BMI<=15  ~ "very underweight"
    )
  )   

attr(df5$BMI,"label")<- "Body Mass Index"

Demo<- df5 %>% 
  select(Subject,Gender,BMI)

write.csv(Demo,"E:/rprogram/r_casestudy/Demo.csv")

#Task:2
a <- as.Date("06/10-2026", format = "%d/%m-%Y")

df6<- df5 %>%
  mutate(
   DOB= parse_date_time(BIRTHDT,orders = c("mdy","dmy")),
   age= as.numeric(year(a) - year(DOB)),
   Location= SITE,
   Sex= Gender
  )
Demo2<- df6 %>% 
  select(age,Sex,Location)

write.xlsx(Demo2,"E:/rprogram/r_casestudy/Demo2.xlsx")

#Task :3
#listing dataset

demo_listing <-df6 %>% 
  select(SITE,Subject,RACECD,ETHNICITY,Sex,BIRTHDT,`start date`,`end date`) %>% 
  arrange(Subject,SITE)
print(demo_listing)
