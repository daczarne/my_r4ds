################################
#### CHAPTER SEVEN: TIBBLES ####
################################

library(tidyverse)
library(hexbin)
library(modelr)

#### Introduction ####

# A tibble is a data.frame with some different behaviours

#### Creating tibbles ####

# Transforming a data.frame into a tibble
as_tibble(iris)

# Creating a tibble
tibble(
      x = 1:5,
      y = 1,
      z = x ^ 2 + y)

# Tibble variables acan have nonsyntactic names:
tb <- tibble(
      `:)` = "smile",
      ` ` = "space",
      `2000` = "number")
tb

# A tribble (transposed tibble) is customized for data entry in code
tribble(
      ~x, ~y, ~z,
      #--|--|----
      "a", 2, 3.6,
      "b", 1, 8.5)

#### Tibbles versus data.frames ####

# The two differences between a tibble and a data.frame are:
#     i) printing
#     ii) subsetting

## Printing
tibble(
      a = lubridate::now() + runif(1e3) * 86400,
      b = lubridate::today() + runif(1e3) * 30,
      c = 1:1e3,
      d = runif(1e3),
      e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>%
      print(n = 10, width = Inf)

nycflights13::flights %>%
      View()

## Subsetting
df <- tibble(
      x = runif(5),
      y = rnorm(5)
)

# Extract by name
df$x
df %>% .$x

df[["x"]]
df %>% .[["x"]]

# Extract by position
df[[1]]

#### Interacting with older code ####

class(as.data.frame(tb))
class(tb)

#### ----------------------------------- EXERCISES ---------------------------------- ####





#----------------------------------------------------------------------------------------#


################################
#### FIN DE LA PROGRAMACIÓN ####
################################