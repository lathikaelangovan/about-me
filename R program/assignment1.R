
############################################
# Program name    : assignment 1.r
# Assignment Date : 02Aug2026
# Description     : Indexing on dataset
#modification history
############################################
####exercise :1 

#Create a vector of 10 numbers 
vec <- c(20:30)

### extracting 3rd and 5th element
vec[c(3,5)]

#remove 1st element
vec[-1]

##extract all element greater than mean
vec[vec > mean(vec)]

##Create a 4×4 matrix
a<- matrix(1:16,nrow=4,byrow=TRUE)
a

#Extract the second column
a[ ,2]

#Extract rows 1 and 3
a[c(1,3), ]

##creating list
b <- list(
  num_vec = c(1:10),
  chr_vec = c("a","b","c","d","e","f","g","h","i","j"),
  dt = data.frame(
    std_name = c("john","shamili","arjun","mithun","george","rosy",
                 "justin","alice","beacon","barbie"),
    marks = c(91,87,58,69,74,88,96,75,83,87)
  )
)
##extracting from list
b[["num_vec"]]
b[["chr_vec"]]
b$dt
b$dt[["marks"]]
b$dt[["std_name"]]
b$dt[["marks"]]

###cap project
df2 <- data.frame(Name = c("Alex", "Bob", "Cara", "Dan"),
                  Age = c(24, 30, 22, 29),
                  Score = c(80, 88, 92, 85))


##Names of people older than 28
df2$Name[df2$Age > 28]

###All scores greater than 85
df2$Score[df2$Score>85]

##Replace all ages below 25 with 25
df2$Age[df2$Age < 25] <- 25
df2











