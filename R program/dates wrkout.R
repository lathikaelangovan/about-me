###########################################
# Program name    : Dates workout.r
# Assignment Date : 08Sept2026
# Description     : Handling with date and time
#modification history
############################################

### DATES WORKOUT


### create date

a <- as.Date("2025-12-31")
class(a)

### print todays date
h<- Sys.Date()


####Find the difference between "2025-01-01" and "2025-02-15"
  D1 <-2025-01-01
  D2 <-2025-02-15
d <- D1-D2


#####Add 30 days to "2026-03-01".
dd <-as.Date("2026-03-01")
 f <- dd+30

 
 ####Print all dates from "2026-08-01" to "2026-08-10" using seq()
 sss<- seq(
   as.Date("2026-08-01"),
   as.Date("2026-08-10"),
  
 )

 
 ###Extract the month name from "2026-10-25"
 g<-as.Date("2026-10-25")
format(g,"%m")     ##extract month
format(g,"%B")     ##extract month name 
format(g,"%b")     ##extract  short month name
format(g,"%d")     ##extract date
format(g,"%A")     ##extract day
format(g,"%Y")     ##extract full yr 
format(g,"%y")     ##extract short yr


##Write a for loop to print the next 10 dates starting from today
for (i in 0:9) {
  
  print(as.Date(Sys.Date()+i))
}

#####Print the current date and time

crtym <- Sys.time()


###Create a date-time for "2026-12-25 08:15:30".
dt <- as.POSIXct("2026-12-25 08:15:30")


###Extract the hour, minute, and second.
format(dt,"%H")        ##to extract hr
format(dt,"%M")        ##to extract minutes
format(dt,"S")         ##to extract second
format(dt,"%H:%M:%S")


##Add 2 hours to a date-time.
ndt <- dt+2*60*60


###Find the difference between "2026-07-13 09:00:00" and "2026-07-13 17:30:00".
t1<- as.POSIXct("2026-07-13 09:00:00")
t2<- as.POSIXct("2026-07-13 17:30:00")
timdif<- t2-t1


###Create a sequence of date-times every 30 minutes from 9:00 AM to 12:00 PM.
seq(
  from = as.POSIXct("2026-07-13 09:00:00 "),
  to = as.POSIXct("2026-07-13 12:00:00 "),
  by = "30 min"
)

####### seq for every one hour to mention AM AND PM
seq(
  f = as.POSIXct("2026-07-14 08:00 AM",format = "%Y-%m-%d %I:%M %p"),   ##%I for 12hr format
  t = as.POSIXct("2026-07-15  01:00 PM" ,format= "%Y-%m-%d %I:%M %p"),   ## %p for AM /PM
  by = "hour"
)


###Write a for loop to print the next 10 hours starting from the current time.
for (i in 0:9) {
  print(Sys.time()+i*60*60)
}



for (i in 1:5) {
  for (x in 1:i) {
    cat("*")
  }
  cat("\n")
  
}


























































