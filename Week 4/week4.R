
data = c(1:10)
"Initializing a matrix"
matrix = matrix(nrow = 10, ncol = 3, data = c(data,data**2,2**data))
matrix = matrix(nrow = 4, ncol = 3, data = c(1:12))


"Giving proper row and col names"
rownames(matrix) = c(1:10)

colnames(matrix) = c("x","x^2","2^x")

rowSums(matrix)

colSums(matrix)

rowMeans(matrix)
colMeans(matrix)



matrix[5:8,2:3]

- x + (x+10)


x = matrix(nrow=4,ncol=3,c(1:12))

y = matrix(nrow=3,ncol=4,c(1:12))


x

y

x %*% y

t(y)

crossprod(x)


rbind(matrix,x)

solve(matrix(nrow=2,ncol=2,c(1,2,3,9)))

sq = matrix(nrow=2,ncol=2,c(1,2,3,9))

solve(sq)

eigen(sq)