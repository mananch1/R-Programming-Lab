print(getwd())
# Intilizing the location to load the data
setwd("D:\\DOCS\\VIT Ebooks\\Fourth Year\\Sem 7\\R\\Lab\\UCI Heart Disease")
data = read.csv("./heart disease/processed.cleveland.data",header=FALSE)

# Chaning the headers
colnames(data) <- c("age", "sex", "cp", "trestbps", "chol", "fbs", "restecg", "thalach", "exang", "oldpeak", "slope", "ca", "thal", "num")