## Week 10 lab work

# substring replacment

str = " The car drove off with great haste"

cat(str)

#Replaces the first occourance
sub('o','O',str)

#Replaces the first occourance
gsub('a','A',str)

grep('Car',str,ignore.case = TRUE)

str2 = c("hey","There","here")

cat(str2)

grep("er",str2,value=T)

grep("[f-j]",letters)


# DataFrames

library(MASS)

painters

rownames(painters)

is.numeric(painters$School)
is.numeric(painters$Drawing)

is.factor(painters$School)

colnames(painters)

summary(painters)

str(painters)

summary(painters$School)

attach(painters)

summary(Drawing)

detach()

subset(painters,School=='F')
#This is equvalent to 
painters[painters$School == 'F',]

subset(painters,Drawing >= 17)


#Siplliting a DF

splitted = split(painters,painters$School)
splitted

