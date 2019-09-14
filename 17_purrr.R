###############
#### PURRR ####
###############

# Introduction ------------------------------------------------------------

library(tidyverse)
library(magrittr)
library(nycflights13)

# Imperative programming: for loops, while loops
# Functional programming: functiona

# For Loops ---------------------------------------------------------------

# Every for loop has three components:
#     1) output: allocate sufficient space for the output before starting the loop
#     2) sequence: determines what to loop over
#     3) body: the code that does the work

# example: calculate the median of each variables in df
df <- tibble(
   a = rnorm(10),
   b = rnorm(10),
   c = rnorm(10),
   d = rnorm(10)
)

output <- vector("double", ncol(df))   # 1. output
for (i in seq_along(df)) {             # 2. sequence
   output[[i]] <- median(df[[i]])      # 3. body
}
output

#==========================# EXERCISES PG. 316 #==========================#
# 1)
# a. compute the mean of every column in mtcars
output <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
   output[[i]] <- mean(mtcars[[i]])
}
output

# b. type of column in nyc flights13::flights
output <- matrix(data = NA, nrow = ncol(nycflights13::flights), ncol = 2)
colnames(output) <- c("variable", "clase")
for (i in seq_along(nycflights13::flights)) {
   output[i, "variable"] <- names(nycflights13::flights[i])
   output[i, "clase"] <- typeof(nycflights13::flights[[i]])
}
output

# c. number of unique values in each column of iris
output <- matrix(data = NA, nrow = ncol(iris), ncol = 2)
colnames(output) <- c("variable", "cant_vals_unicos")
for (i in seq_along(iris)) {
   output[i, "variable"] <- names(iris[i])
   output[i, "cant_vals_unicos"] <- length(unique(iris[[i]]))
}
output

# d. 10 random normals for mus
mus <- c(-10, 0, 10, 100)
output <- matrix(data = NA,
                 nrow = length(mus),
                 ncol = 10,
                 dimnames = list(
                    paste("mu =", mus)
                 ))
for (i in 1:dim(output)[1]) {
   for (j in 1:dim(output)[2]) {
      output[i, j] <- rnorm(n = 1, mean = mus[i])
   }
}
output

# 2)
# caso a)
out <- ""
for (x in letters) {
   out <- stringr::str_c(out, x)
}
out

stringr::str_flatten(letters)

# caso b)
set.seed(1234)
x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
   sd <- sd + (x[i] - mean(x)) ^ 2
}
sd <- sqrt(sd / (length(x) - 1))

sd(x)

# caso c)
set.seed(1234)
x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
   out[i] <- out[i - 1] + x[i]
}
out

cumsum(x)

# 3) combine functions and for loops
# caso a) Alice the Camel
animals <- c("Alice the Camel has one hump.",
             "Ruby the Rabbit has two ears.",
             "Sally the Sloth has three toes.",
             "Felix the Fox has four legs.",
             "Lilly the Ladybug has five spots.",
             "Andy the Ant has six legs.",
             "Larry the Lizard has seven stripes.",
             "Sammy the Spider has eight legs.")
for (i in seq_along(animals)) {
   for (j in 1:3) {
      print(
         animals[i]
      )
   }
   print(
      paste(
         "Go", 
         stringr::word(animals[i], 1),
         "go!"
      )
   )
}

#=========================================================================#


# For Loop Variations -----------------------------------------------------

# There are four variations on the basic theme of the for loop:
#     1) Modifying an existing object, instead of creating a new object.
#     2) Looping over names or values, instead of indices.
#     3) Handling outputs of unknown length.
#     4) Handling sequences of unknown length.

## Modifying an existing object

df <- tibble(
   a = rnorm(10),
   b = rnorm(10),
   c = rnorm(10),
   d = rnorm(10)
)
rescale01 <- function(x) {
   rng <- range(x, na.rm = TRUE)
   (x - rng[1]) / (rng[2] - rng[1])
}

for (i in seq_along(df)) {
   df[[i]] <- rescale01(df[[i]])
}

## Looping patterns

#  a. looping over indices: for (i in seq_along(x))
#  b. looping over elements: for (i in x)
#  c. looping over names: for (i in names(x))

results <- vector("list", length(x))
names(results) <- names(x)
for (i in seq_along(x)) {
   name <- names(x)[[i]]
   value <- x[[i]]
}

## Unknown output lenght

# Increase the output size (not recommended)
means <- c(0, 1, 2)
output <- double()
for (i in seq_along(means)) {
   n <- sample(100, 1)
   output <- c(output, rnorm(n, means[[i]]))
}
str(output)

# Recomendarion: save them to a list a then combine
out <- vector("list", length(means))
for (i in seq_along(means)) {
   n <- sample(100, 1)
   out[[i]] <- rnorm(n, means[[i]])
}
str(out)
str(unlist(out))

## Unknown sequence length

# use while loop

# For Loops versus functionals --------------------------------------------



# The map functions -------------------------------------------------------

# There is one function for each type of output:
# map() makes a list.
# map_lgl() makes a logical vector.
# map_int() makes an integer vector.
# map_dbl() makes a double vector.
# map_chr() makes a character vector.

# Each function 
#     i) takes a vector as input
#     ii) applies a function to each piece
#     iii) returns a new vector that’s the same length (and has the same names) as the input. 
# The type of the vector is determined by the suffix to the map function.

df <- tibble(
   a = rnorm(10),
   b = rnorm(10),
   c = rnorm(10),
   d = rnorm(10)
)

map_dbl(.x = df, .f = mean)
map_dbl(.x = df, .f = median)
map_dbl(.x = df, .f = sd)

# Map functions can be piped
df %>% map_dbl(.f = mean)

# map_*() uses ellipsis
df %>% map_dbl(.f = mean, trim = 0.5)

# map functions preser names
z <- list(x = 1:3, y = 4:5)
map_int(.x = z, .f = length)

### Shortcuts

models <- mtcars %>%
   split(.$cyl) %>%
   map(function(df) lm(mpg ~ wt, data = df))

# Use one sided formulae to create functions
models <- mtcars %>%
   split(.$cyl) %>%
   map(~lm(mpg ~ wt, data = .))

models %>%
   map(summary) %>%
   map_dbl(~.$r.squared)

models %>%
   map(summary) %>%
   map_dbl("r.squared")

x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x %>% map_dbl(2)

#------- EXERCISES PAGE 328 -------#
# 1) use map_*
# a)
mtcars %>% map_dbl(mean)
mtcars %>% map_dbl(median)
mtcars %>% map_dbl(quantile, 0.50)
mtcars %>% map_dbl(var)
mtcars %>% map_dbl(sd)
mtcars %>% map_dbl(IQR)
mtcars %>% map_dbl(quantile, 0.25)
mtcars %>% map_dbl(quantile, 0.75)

# b)
flights %>% map_chr(typeof)

# c)
iris %>% as_tibble() %>% map_dbl(function(x) length(unique(x)))

# d)
set.seed(1234)
c(-10, 0, 10, 100) %>%
   map(function(x) rnorm(10, mean = x)) %>%
   unlist() %>%
   matrix(nrow = 4, byrow = TRUE)

# 2)
iris %>% 
   as_tibble() %>% 
   map(is.factor) %>% 
   flatten_lgl()

# 3) for each run of the runif it's passing the corresponding element of the numeric vector as the first
# argument, ie number of simulations
map(1:5, runif)
# can use it as other arguments defining a fucntion that does so
map(1:5, .f = function(x) runif(1, min = x, max = x + 1))

# 4)
# generates a list of length 5 each element containing a numeric vector of length 5
map(-2:2, rnorm, n = 5)
# generates an error since input is a numeric vector of length 5. Output needs to be either a list as
# before or a single element (double vector of length 1)
map_dbl(-2:2, rnorm, n = 5)

# 5) what's the expected output of this call?? what is it mapping over??
map(x, function(df) lm(mpg ~ wt, data = df))
mtcars %>% map(~lm(mpg ~ wt, data = .))

#---------------------------------#

# Dealing with failure ----------------------------------------------------

# Use purrr::safely() (which is designed to work with map)
safe_log <- safely(log)
str(safe_log(10))
str(safe_log("a"))

x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y)

# transpose() separates into two lists
y <- y %>% transpose()
str(y)

is_ok <- y$error %>% map_lgl(is_null)
x[!is_ok]
y$result[is_ok] %>% flatten_dbl()

# possibly() always succeeds. It’s simpler than safely(), because you give it a default value to return when there is an error
x <- list(1, 10, "a")
x %>% map_dbl(possibly(log, NA_real_))

# quietly() performs a similar role to safely(), but instead of capturing errors, it captures printed output, messages, and warnings
x <- list(1, -1)
x %>% map(quietly(log)) %>% str()

# Mapping over multiple arguments -----------------------------------------

## Simulating random normal variables with different means
mu <- list(5, 10, -3)
mu %>%
   map(rnorm, n = 5) %>%
   str()

## Simulating random normal variables with different means and standard devs
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)

### Option 1: seq_along and map
seq_along(mu) %>%
   map(~rnorm(5, mu[[.]], sigma[[.]])) %>%
   str()

### Option 2: map2
map2(mu, sigma, rnorm, n = 5) %>% str()

# argument positions:
#  - before function: arguments that vary (those to map over)
#  - after function: arguments that stay the same

## There's no map3, map4, map5, and so on. Use pmap for multiple arguments
mu <- list(5, 10, -3)
sigma <- list(1, 5, 10)
n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)
args1 %>% pmap(rnorm) %>% str()

# If no names are provided, pmap() will use positional matching (i.e. it will assum arguments where passed in the correct order)
args2 <- list(mean = mu, sd = sigma, n = n)
args2 %>% pmap(rnorm) %>% str()

# Invoking different functions --------------------------------------------
f <- c("runif", "rnorm", "rpois")
param <- list(
   list(min = -1, max = 1),
   list(sd = 5),
   list(lambda = 10)
)
invoke_map(f, param, n = 5) %>% str()

sim <- tribble(
   ~f, ~params,
   "runif", list(min = -1, max = 1),
   "rnorm", list(sd = 5),
   "rpois", list(lambda = 10)
)
sim %<>%
   mutate(sim = invoke_map(f, params, n = 10))

##########################
#### END OF PROGRAMM #####
##########################