# Power operations
2^3
2**3

2^0.5
2^-0.5

c(2, 3, 5, 7)^2
c(2, 3, 5, 7)^c(2, 3)
c(1, 2, 3, 4, 5, 6)^c(2, 3, 4)

# Integer division and modulo
5 %/% 2
7 %/% 3
c(2, 3, 5, 7) %/% 2
c(2, 3, 5, 7) %/% c(2, 3)

2 %% 2
3 %% 2
7 %% 3
7 %% 4
c(2, 3, 5, 7) %% 2
c(2, 3, 5, 7) %% c(2, 3)

# Mathematical and statistical functions
max(1.2, 3.4, -7.8)
min(1.2, 3.4, -7.8)

mean(2, 3, 4)
mean(c(2, 3, 4))

abs(-4)
abs(c(-1, -2, -3, 4, 5))
sqrt(4)
sqrt(c(4, 9, 16, 25))

sum(c(2, 3, 5, 7))
prod(c(2, 3, 5, 7))

round(1.23)
round(1.83)
floor(1.83)
ceiling(1.23)

log(10)
log(exp(1))
log10(100)
log2(8)
exp(2)

sin(pi / 2)
cos(0)

# Combined vector expressions
x1 = c(1, 2, 3, 4)
x2 = x1^2

c(1, 2, 3, 4) + sum(c(1, 2, 3, 4)) * prod(c(1, 2))
abs(c(1, 2, 3, 4) - sum(c(1, 2, 3, 4)) * prod(c(1, 2)))

# Matrices
x = matrix(nrow = 4, ncol = 2, data = c(1, 2, 3, 4, 5, 6, 7, 8))
x

y = matrix(nrow = 4, ncol = 2, data = c(1, 2, 3, 4, 5, 6, 7, 8), byrow = TRUE)
y

# Matrix indexing
x[3, 2]
x[1, ]
x[, 2]

# Matrix properties
dim(x)
nrow(x)
ncol(x)
mode(x)
attributes(x)

is.matrix(x)
as.matrix(1:5)
