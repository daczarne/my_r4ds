###########################################
#### CHAPTER 11 - STRINGS WITH STRINGR ####
###########################################

#### Introduction ####

library(tidyverse)
library(magrittr)
library(stringr)

#### String basics ####

string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"", "\\")
writeLines(x)

# Al stringR functions begin with str_
str_length(c("a", "R for data science", NA))
str_c("X", "Y")
str_c("X", "Y", sep = " ")
str_c("X", "Y", sep = ",")
str_c("X", "Y", sep = ", ")

# Missing values are contagious
x <- c("abc", "defg", NA)
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

# Use str_sub to subset. Negative numbers count backwards
x <- c("Apple","Banana","Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)
str_sub(x, 1, 999)

# Can also use str_sub to modify the string
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))

# The importance of locales
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")
x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")
str_sort(x, locale = "haw")

#----------------- EXERCISES -----------------#
# 1)
# paste0 leaves no spaces between words. str_c is it's equivalent. See difference in
# NA treatment below:
str_c(c("a", NA))
paste(c("a", NA))
str_c("a", NA)
paste("a", NA)

# 2) Use collapse to specify spearation between elements of a string vector. Use 
# collapse to specify character between vectors
str_c("a", "b", "c", collapse = ",")
str_c("a", "b", "c", sep = ",")

str_c(c("a", "b", "c"), collapse = ",")
str_c(c("a", "b", "c"), sep = ",")

str_c(c("a","b","c"), c("d","e","f"), collapse = ",")
str_c(c("a","b","c"), c("d","e","f"), sep = ",")

str_c(c("a","b","c"), "d","e","f", collapse = ",")
str_c(c("a","b","c"), "d","e","f", sep = ",")

# 3)
str_sub("stringR", 
        start = ceiling(str_length("stringR")/2), 
        end = ceiling(str_length("stringR")/2))
# If string has even number of characters then there is no middle

# 4) makes paragraphs
thanks_path <- file.path(R.home("doc"), "THANKS")
thanks <- str_c(readLines(thanks_path), collapse = "\n")
thanks <- word(thanks, 1, 3, fixed("\n\n"))
cat(str_wrap(thanks), "\n")
cat(str_wrap(thanks, width = 40), "\n")
cat(str_wrap(thanks, width = 60, indent = 2), "\n")
cat(str_wrap(thanks, width = 60, exdent = 2), "\n")
cat(str_wrap(thanks, width = 0, exdent = 2), "\n")

# 5) removes whispaces from start and end
?str_trim

# 6) 
x <- c("a", "b", "c")
what_Hadley_wants <- function(x) {
      result <- c()
      for (i in 1:length(x)) {
            if (i == length(x)) {
                  result <- str_c(result, x[i], sep = " and ")
            } 
            else {
                  result <- str_c(result, x[i], sep = ", ")
            }
      }
      return(result)
}
what_Hadley_wants(x)
y <- x[1:2]
what_Hadley_wants(y)
z <- x[1]
what_Hadley_wants(z)
w <- NULL
what_Hadley_wants(w)

#---------------------------------------------#

#### Matching patterns ####

x <- c("apple", "banana", "pear")

# matches "an"
str_view(x, "an")
# . matches any character except new line
str_view(x, ".a.")

# To create the regular expression, we need \\
dot <- "\\."
# But the expression itself only contains one:
writeLines(dot)
# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

# Matching \
x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")

#----------------- EXERCISES -----------------#

#---------------------------------------------#

## Anchors
# ^ start
# $ end

x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

# To force a regular expression to only match a complete string, anchor it with both ^ and $
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")


#----------------- EXERCISES -----------------#
# 1) 
literal <- "$^$"
str_view(literal, pattern = "\\$\\^\\$")

# 2) 
# a) start with y
stringr::words[str_sub(stringr::words,start = 1, end = 1) == "y"]
str_view(string = stringr::words, pattern = "^y", match = TRUE)

# b) end with x
stringr::words[str_sub(stringr::words,start = -1, end = -1) == "x"]
str_view(string = stringr::words, pattern = "x$", match = TRUE)

# c) are exactly three letters long
three_letters_long <- "^...$"
str_view(stringr::words, pattern = three_letters_long, match = TRUE)

# d) seven letters or more
str_view(stringr::words, pattern = "^.......", match = TRUE)

#---------------------------------------------#



################################
#### FIN DE LA PROGRAMACIÓN ####
################################
