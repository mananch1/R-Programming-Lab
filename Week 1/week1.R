# Basic output and assignment
cat("Hello R\n")

x = 10
y = 20
z = x + y
print(z)

# Getting help
?mean
help(sum)
help.search("median")
find("lowess")
apropos("sum")
apropos("lm")
example(min)

# Packages and libraries
installed.packages()

library(MASS)
packageDescription("MASS")
library(help = MASS)
detach("package:MASS", unload = TRUE)
