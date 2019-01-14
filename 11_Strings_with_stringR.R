###########################################
#### CHAPTER 11 - STRINGS WITH STRINGR ####
###########################################

library(tidyverse)
library(magrittr)
library(stringr)

# Al stringR functions begin with str_
str_length(c("a", "R for data science", NA))
str_c("X", "Y")
str_c("X", "Y", sep = " ")
str_c("X", "Y", sep = ",")
str_c("X", "Y", sep = ", ")

# Missing values are contagious
x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

# str_c is vectorized
str_c("prefix-", c("a", "b", "c"), "-suffix")
str_c("prefix-", letters[1:3], "-suffix")
str_c("prefix-", LETTERS[1:3], "-suffix")

# 0 length objects are silently dropped:
name <- "Daniel"
time_of_day <- "morning"
birthday <- FALSE
str_c(
      "Good ", time_of_day, ", ", name,
      if (birthday) {" and HAPPY B-DAY"},
      "."
)
birthday <- TRUE
str_c(
      "Good ", time_of_day, ", ", name,
      if (birthday) {" and HAPPY B-DAY"},
      "."
)

# To collapse a string vector use collapse argument:
str_c(c("x", "y", "z"), collapse = ", ")
str_c("x", "y", "z", collapse = ", ")

#### SUBSETTING ####



################################
#### FIN DE LA PROGRAMACIÓN ####
################################