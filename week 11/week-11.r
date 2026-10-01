# week-11 Lab work

getwd()

setwd("D:\\DOCS\\VIT Ebooks\\Fourth Year\\Sem 7\\R\\Lab\\week 11")

getwd()

dataMunich = read.table(file = "http://home.iitk.ac.in/~shalab/Rcourse/munichdata.asc")

# It auto infers the headers so we must set headers to false
data = read.csv("./example1.csv")

data

data = read.csv("./example1.csv",header = F,sep=',')
data

names(data)  = c("column_1","column_2","column_3")

data$column_1

library(readxl)

#Read only the first 3 Rows 
excel_data = read_excel("./students.xlsx",sheet = 1,n_max = 3)

excel_data
mean(excel_data$`AGE`)

mealPlans = read_excel("./students.xlsx",sheet = 1,range = "D1:D7")
mealPlans

get_mode <- function(x) {
  uniq_x <- unique(x)
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}

get_mode(mealPlans)

library(foreign)
library(XML)


x = 1:100
write(x,file = "test.csv",append = T,sep=',',ncolumns = 10)
