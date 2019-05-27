############################
#### CHAPTER 14 - PIPES ####
############################

#### INTRODUCTION ####

library(magrittr)
library(pryr)

#### PIPING AALTERNATIVES ####

# R shares columns when possible
diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>% dplyr::mutate(price_per_carat = price / carat)
pryr::object_size(diamonds)
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

diamonds$carat[1] <- NA
pryr::object_size(diamonds)
pryr::object_size(diamonds2)
pryr::object_size(diamonds, diamonds2)

### Use the pipe ###

assign("x", 10)
"x" %>% assign(100)
x %>% assign(100)

# Be explicit about environment
env <- environment()
"x" %>% assign(100, envir = env)
x

"x" %>% assign(123, envir = .GlobalEnv)

### OTHER TOOLS FROM MAGRITTR ###

# %T>% works like %>%  except that it returns the lhs instead of the rhs
set.seed(1234)
rnorm(100) %>%
      matrix(ncol = 2) %>%
      plot() %>%
      str()

set.seed(1234)
rnorm(100) %>%
      matrix(ncol = 2) %T>%
      plot() %>%
      str()

# %$% is useful when working with functions that don't have a data.frame based API.
mtcars %$%
      cor(disp, mpg)

mtcars %>% 
      cor(disp, mpg)

################################
#### FIN DE LA PROGRAMACIÓN ####
################################