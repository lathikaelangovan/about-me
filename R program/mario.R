
##############################################################
# Program name    : assignment 2.r
# Assignment Date : 02Aug2026
# Description     : To build a mario pyramid by using loop
#modification history
#############################################################
#### mario pyramid

#### by using for loop
repeat{
  
  height <- readline("Give the height of the triangle: ")
  h<- as.numeric(height)
 
 if(h>0 & h< 9){
   
  
  for (i in 1:h) {
    a<- paste(rep("#",i),collapse = "")
    b<- h-i
    c<- paste(rep(" ",b),collapse = "")
    
    cat(c,a," ",a,"\n")
    
  }
 }
  if(h>0 & h< 9)break
}


###by using repeat loop
repeat{
  

height <- readline("Give the height of the triangle: ")
h<- as.numeric(height)


if(h>0  & h<9){
  i<- 1
  repeat{
    
  a<- paste(rep("#",i),collapse = "")
  b<- h-i
  c<- paste(rep(" ",b),collapse = "")
  i=i+1
  cat(c,a," ",a,"\n")
  if(i>h)break
  }
}
if(h>0 & h< 9)break
}





















