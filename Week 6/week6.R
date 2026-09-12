for (i in 1:5){
  print(i**2)
}

x = c(2,4,6,8,10,12)

excount = function(x){
  count = 0
  for(xi in x){
    if(xi/2 > 3){
      count = count+1
    }
  }
  print(count)
}

cat("excount is :", excount(x),"\n")

child = c("child1", "child2", "child3")
sweet = c("sweet1","sweet2","sweet3")
for (x in child) {
  for (y in sweet)
    print (paste(x,y))
}


drink = c("Cappucino","Hot cocoa","OJ","Lemonade","Latte")

for (x in drink){
  if(x == "OJ")
    break
  print(x)
}

print("")

for( x in drink){
  if(x == "OJ")
    next
  print(x)
}

i = 1
while(i < 10){
  print(i**.5)
  i = i+2
}
