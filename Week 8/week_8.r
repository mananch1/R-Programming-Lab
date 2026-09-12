# Week 8 practial session content

list1 = list(1,2,3)

list2 = list("water","juice","lemonade")

print(list1)
print(list2)

c(list1,list2)

print("List merging")
print(c(list1,list2))
print(mode(unlist(c(list1,list2))))


# List to Vector Conversions

print(unlist(list2))

# Appending append(), appened(,after)

append(list1,4)


append(list2,"Coffee",after=1)

# Removing from lists
cat("Uisng list[-x] to remove from a list\nlist1[-2]")
list1[-2]


x = list()

for (item in 21:1) {
   x = append(x,item)
}

x[10:15]

x[c(1,4,7)]

# Vecotr Indexing

y = 1:10
y[(y > 5)]
x[(x>5)]

y[(y%%2==0)]
#x[(x%%2==0)] does not work even tho the above one works

y[5] = NA
x

z = y[!is.na(y)]
z

mean(x)
mean(y)
mean(z)

# String vector

z = list(a1 = 1, a2 = "c", a3 = 1:3)
z

names(z)[3]

