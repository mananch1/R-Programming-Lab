# Variables and assignment
x = 20
y = x * 2
z = x + y
print(z)

# Characters and case sensitivity
x = "apple"
X = 50
x = 25

# Type checking and conversion
is.numeric(x)
is.character(x)
is.character("apple")

y = as.character(x)
is.character(y)

as.numeric("apple")

# Mode and storage mode
mode(6)
mode("apple")
mode(TRUE)

storage.mode(6)
storage.mode(TRUE)

# Infinity
3 / 0
5 + Inf
is.finite(3 / 0)
is.infinite(3 / 0)

# Basic calculations and precedence
2 + 3
2 - 3
2 * 3
3 / 2
2 * 3 - 4 + 5 / 6

(2 + 3) * 5 + 5 - 10
(((2 + 3) * 5 + 5) - 10) / 2

# Scalar operations on vectors
c(2, 3, 5, 7) + 10
c(12, 13, 15, 17) - 10
c(2, 3, 5, 7) * 10
c(12, 13, 15, 17) / 10

# Vector arithmetic
c(2, 3, 5, 7) + c(-2, -3, -5, 8)
c(2, 3, 5, 7) - c(-2, -3, -5, 8)
c(2, 3, 5, 7) * c(-2, -3, -5, 8)
c(24, 20, 8, 16) / c(3, 4, 2, 8)

# Vector recycling
c(2, 3, 5, 7) + c(8, 9)
c(12, 13, 15, 17) - c(8, 9)
c(2, 3, 5, 7) * c(8, 9)
c(24, 20, 8, 16) / c(4, 2)

c(2, 3, 5, 7) + c(8, 9, 10)
