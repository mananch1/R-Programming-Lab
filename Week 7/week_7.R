seq(1.23,10,by=2)


seq(-1.23,10,by=2)

seq(1,10,2.10)
seq(1,10,length = 6)

seq(1,100,5)


y = 2 * seq(1,100,5)

print(y)

ind = seq(along=y)

y[ind[2]]

Sys.time()

Sys.Date()


seq(as.Date("2020-12-12"),by = "-1 year",length=10)



letters

rep(LETTERS[1:4],times = 3, each = 2)

rep(1:4,2:5)

rep(1:4,seq(2,8,2))

x = matrix (nrow=2, ncol=2, data=1:4, byrow=T)

rep(x,byrow=T)


sort(x)

order(x)

factor(c("A","B"))

x = list(2:5,9:20)

print(x)

x[[1]]


x1 = matrix(nrow = 2, ncol = 3, data = 1:6, byrow=T)
x1

x2 = matrix(nrow = 3, ncol = 2, data= 1:6)
x2

matlist = list(x1,x2)
matlist

matlist[1]