x = c(11,12,NA,12,NA)

is.na(x)

getwd()

mean(x)

mean(x,na.rm=TRUE)

which(is.na(x)) # really useful for iterating on records NA values

complete.cases(x) # shows the places which are not null
which(complete.cases(x))


y = na.omit(x)

mean(y)

if(mean(y) > 10){
   print("Mean of y is greater than 10")
   y <- y*10
}

y

z = 5

if(z == 3){
    z = z + 1
} else {
   z = z * 2
}

print(z)

print("Please enter a number between 1 and 3")
z <- as.numeric(readLines(con = "stdin",n = 1))

if( z == 1){
    print("your number is 1")
}else if(z == 2){
    print("your number is two")
}else if (z == 3) {
   print("your number is three")
}else{
    print("Hey its out of bounds")
    if(z %% 2 == 0)
        print("But hey atlest its a multiple of 2")
}

print(ifelse(z<3,z^2,z+2))


cat("
Select an option
1)x
2)x^2
3)2^x
")
z = as.numeric(readLines(con='stdin',n=1))

print(switch(z,x,x^2,2^x))


mat = matrix(nrow=3,ncol = 3, data=1:3)

which(mat %% 2 == 1)

which(mat %% 2 == 1, arr.ind = TRUE)

which.max(mat)
