#################
#### VECTORS ####
#################


# Introduction ------------------------------------------------------------

library(tidyverse)

# Vector basics -----------------------------------------------------------

# Two types of vectors:
# 1) atomic: logical, numeric (integer or double), character, complex and raw
# 2) lists: also known as recursive vectors

# Atomic vectors are homogeneous while lists can be heterogeneous


# Vectors have two key components:
# 1) class (or type)
# 2) lenght
# Other attributes can be defined to create augmented vectors (like factors, date and datetimes, or data.frames and tibbles)

# NULL -> represents the absence of a vector
# NA -> represents the absence of a value in a vector

# Important types of atomic vectors ---------------------------------------

# Numeric
((1/3L) * 3 - 1) == 0
(sqrt(2) ^ 2) == 2
dplyr::near(sqrt(2) ^ 2, 2)

# Character
x <- "This is a reasonably long string."
pryr::object_size(x)
y <- rep(x, 1000)
pryr::object_size(y)


# Using atomic vectors ----------------------------------------------------

## Naming vectors
a <- c(x = 1, y = 2, z = 3, x = 4)
set_names(1:3, nm = c(letters[1:3]))

a[1]
a[[1]]

a[4]
a["x"]
a[["x"]]
a[c(1,4)]
a[[c(1,4)]]


# Recursive vectors -------------------------------------------------------

x <- list(1:3, 2, 3)
x[1]
x[[1]]
x[[1]][1]

y <- list(x, NA, mpg)
y[1]
y[[1]]
y[[1]][1]
y[[1]][[1]]
y[[1]][[1]][1]


# Attributes --------------------------------------------------------------

# Class controls how generic functions work

methods("mean")
getS3method("mean", "default")


# Augmented vectors -------------------------------------------------------

x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
attributes(x)


#########################
#### END OF PROGRAMM ####
#########################