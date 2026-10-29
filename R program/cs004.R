
#Case Study # 4 

#Project Title: Summary of Demographic tables 
#Project code: CCS004 
#Description: Generate a Demographics table 
####################################################

library(haven)
library(dplyr)
library(stringr)
library(tidyr)
library(gt)
library(flextable)
library(officer)

dm <- read_sas("E:/Raw Data/CASE STUDIES/CS004/RAW DATA/dm.sas7bdat", NULL)
View(dm)
dm_<-dm |> 
  mutate(
    arm= ifelse(arm==0,"Placebo","Active")
  )

# calculating stat values
dm1<- dm_ %>% 
  arrange(pat) %>% 
  group_by(arm) %>% 
  summarise(
    N= n_distinct(pat),
    MEAN=sprintf("%.1f",mean(age)),
    SD= sprintf("%.1f",sd(age)),
    MEDIAN=sprintf("%.1f",median(age)),
    Q1_Q3=sprintf("%.1f - %.1f",quantile(age,probs=0.25),quantile(age,probs=0.75)),
    MIN_MAX=sprintf("%.1f - %.1f",min(age),max(age))
  )
#transposing dataset
dm2<-dm1 |>
  mutate(across(-arm,as.character)
        ) |> 
  pivot_longer(
             cols=-arm,
             names_to = "stat",
             values_to = "value") |> 
  pivot_wider(
    names_from = arm,
    values_from = value)

dm3<-dm2 |> 
  mutate(
    t1=stat
  ) |> select(-stat)

  #calculating ncount for gender
num<-dm |> 
  arrange(pat) |> 
  group_by(arm,gender) |> 
  summarise(
    n1=n_distinct(pat),
    .groups = "drop"
  )

#calculating denominator to calculate pct
denom<-dm |> 
  arrange(pat) |> 
  group_by(arm) |> 
  summarise(
    dnm=n_distinct(pat),
    .groups = "drop"
  )
# percentage calculation
sex<-merge(num,denom,by="arm") |> 
  mutate(
    arm= ifelse(arm==0,"Placebo","Active"),
    gender=ifelse(gender==1,"Male","Female"),
    PCT=sprintf("(%.0f%%)",(n1/dnm)*100 ),
    percent= str_c(n1,PCT),
 t1=gender
  
  ) |> 
  select(-n1,-dnm,-PCT,-gender) |> 
  pivot_wider(
    names_from = arm,
    values_from = percent
  )
headers<- data.frame(
  t1=c("Gender","Age"),
  Placebo=c(" "," "),
  Active=c(" "," ")
)
#assigning row number

headers$row<-c(1,4)
dm3$row<-c(5,6,7,8,9,10)
sex$row<-c(2,3)
#merging dataset
f1<- bind_rows(headers,sex,dm3)
final<- f1 |> 
  arrange(row) |> 
  select(-row)
#exporting rtf output file
final |>
  gt() |> 
  tab_header(
    title = "Demographic Characteristics"
  ) |> 
  cols_label(
    t1=" "
  )
gtsave(
  gt(final),
  filename = "E:/rprogram/r_casestudy/Demog.rtf"
)  

