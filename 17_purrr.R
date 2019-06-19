###############
#### PURRR ####
###############


# Introduction ------------------------------------------------------------

library(tidyverse)


# For Loops ---------------------------------------------------------------



# For Loop Variations -----------------------------------------------------



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

#------- EXERCISES -------#



#-------------------------#

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

##########################
#### END OF PROGRAMM #####
##########################