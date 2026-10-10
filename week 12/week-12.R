# R Programming week 12


#Bar Plot
cust = matrix(nrow=4,ncol=3,data = c(2,20,30, 26,53, 40, 42 , 15, 25 , 30, 75, 100),byrow = T)


rownames(cust) = c("Day 1","Day 2","Day 3","Day 4")
colnames(cust) = c("Shop 1","Shop 2","Shop 3")
cust

barplot(cust,names.arg = c("Shop 1","Shop 2","Shop 3"), xlab = "Shops",
        ylab = "Total Cost for all days",col = c("Red","Green","Blue","Yellow"))


#Pie Chart

gender = c(1,2,1,2,2,1,1,2,1,2,2,1,1,1,1)
gender
table(gender)

pie(gender)
pie(table(gender))


# Pizza Example
direction =
  c (1,1,2,1,2, 3,2,2,3,3, 3,1, 2, 3, 2, 2, 3, 1, 1, 3, 3, 1 , 2
     , 1,3,3,3,2,2,2,2,1,2,2,1,1,1,3,2,2,1,2,3,2,2,1,
     2,3, 3,2,1,2, 2, 3, 1, 1, 2, 1, 2 , 3, 2 , 3, 2, 2 , 3, 1 , 2 , 3, 3, 3
     , 2,1,1,1,2,1,1,2,1,2,3,3,1,2,3,3,2,1,2,3,2,1,3,
     2,2,2,2,3,2,2)

pie(table(direction),col = c("red","green","blue"))

par(mfrow=c(1,2))

barplot(table(direction))
pie(table(direction),col = c("red","green","blue"))


# Histograms
par(mfrow=c(1,1))

hist(direction,main="Frequency of Pizza Orders from Districts") # Abs Freq

hist(direction,freq=F) # Relative Freq or Density


hist(x,main,col)


#Heights Example

height = c (166, 125, 130, 142, 147, 159, 159, 147,
            
            165, 156, 149, 164 , 137 , 166, 135 , 142, 133, 136, 127, 143 ,
            
            165, 121, 142 , 148 , 158 , 146, 154 , 157, 124, 125, 158 , 159 ,
            
            164, 143, 154, 152 , 141 , 164, 131 , 152 , 152 , 161 , 143, 143,
            
            139, 131, 125, 145, 140, 163)

hist(height,main = "Heights of People", xlab = "Heights", ylab = "Count of People",col = "tan",density=5,angle=30)


# Bivariate Graphs

marks = c (337, 316, 327, 340, 374, 330, 352, 353, 370, 380, 384, 398,
     413, 428, 430, 438, 439, 479, 460, 450)

hours = c (23, 25, 26, 27, 30, 26, 29, 32, 33 , 34 , 35, 38 , 39,
     42, 43, 44,45,46,44,41)

par(mfrow=c(3,2))

plot(hours,marks,"p")
plot(hours,marks,"l")
plot(hours,marks,"b")
plot(hours,marks,"c")
plot(hours,marks,"o")
plot(hours,marks,"s")

par(mfrow=c(1,1))


plot (hours, marks, xlab="Number of weekly
hours", ylab="Marks obtained", main="Marks
obtained versus Number of hours per week")


# Pairs

pairs(cbind(hours,marks))
