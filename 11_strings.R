###########################################
#### CHAPTER 11 - STRINGS WITH STRINGR ####
###########################################

#### INTRODUCTION ####

library(tidyverse)
library(magrittr)
library(stringr)

#### STRING BASICS ####

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

## Subsetting ##

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

#----------------- EXERCISES (page 199) -----------------#
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

#### MATCHING PATTERNS WITH REGULAR EXPRESSIONS ####

## Basic maatches ##

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

#----------------- EXERCISES (page 201) -----------------#
# 1) matching a \:
# "\": This will escape the next character in the R string.
# "\\"` This will resolve to `\` in the regular expression, which will escape the next character in the regular
# expression.
# "\\\": The first two backslashes will resolve to a literal backslash in the regular expression, the third will 
# escape the next character. So in the regular expression, this will escape some escaped character.

# 2)
str_view("\"'\\", "\"'\\\\", match = TRUE)

# 3)
# It will match any patterns that are a dot followed by any character, repeated three times.
str_view(string = c(".a.b.c", ".a.b", ".....", ".d.e.f.", "más texto raro"), 
         pattern = c("\\..\\..\\.."))

#--------------------------------------------------------#

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

#----------------- EXERCISES (page 203) -----------------#
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

#--------------------------------------------------------#

## Character clases and alternatives ##
str_view(c("grey", "gray"), "gr(e|a)y")

#----------------- EXERCISES (page 204) -----------------#
# 1) a) start with a vowel
str_view(stringr::words, pattern = "^(a|e|i|o|u)", match = TRUE)
str_view(stringr::words, pattern = "^(i|o|u)", match = TRUE)

# b) only consonants
str_view(stringr::words, pattern = "^[^aeiou]+$", match = TRUE)

# c) end with ed but not with eed
str_view(stringr::words, pattern = "ed$", match = TRUE)
str_view(stringr::words, pattern = "[^e]ed$", match = TRUE)

# d) End with ing or ize
str_view(stringr::words, pattern = "(ing|ize)$", match = TRUE)

# 2)
str_view(stringr::words, "(cei|[^c]ie)", match = TRUE)
str_view(stringr::words, "(cie|[^c]ei)", match = TRUE)
sum(str_detect(stringr::words, "(cei|[^c]ie)"))
sum(str_detect(stringr::words, "(cie|[^c]ei)"))

# 3) 
str_view(stringr::words, pattern = "q", match = TRUE)
str_view(stringr::words, pattern = "q[^u]", match = TRUE)

# 4) 
str_view(string = stringr::words,
         pattern = "ou|ise$|ae|oe|yse$",
         match = TRUE)

# 5) telephone numbers
phones <- "^09[1-9]{7}"

#--------------------------------------------------------#

## Repetition ##
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')

str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")

# Lazy matching
str_view(x, 'C{2,3}?')
str_view(x, 'C[LX]+?')

#----------------- EXERCISES (page 206) -----------------#
# 1)
# ? -> {0,1}
# + -> {1,}
# * -> {0,}

# 2)
# a) any string
# b) any string of the form: {a}, {ab}, {abc}, etc
# c) any string of the form: ####-##-## (for example dates: YYYY-MM-DD)
# d) four backslashes

# 3)
# a) start with three consonants
"^[^aeiou]{3}"
# b) have three or more vowels in a row
"[aaeiou]{3,}"
# c) two or more vowel-consonant pairs
"([aeiou][^aeiou]){2,}"

#--------------------------------------------------------#

## Grouping and backreferences ##

str_view(fruit, "(..)\\1", match = TRUE)

#----------------- EXERCISES (page 207) -----------------#
# 1) 
# a) same character three times in a row: aaa
str_view(stringr::words, pattern = "(.)\1\1", match = TRUE)

# b) cuartetos de la forma abba
str_view(stringr::words, pattern = "(.)(.)\\2\\1", match = TRUE)

# c) any two characters repeated: aa, bb, cc, etc
str_view(stringr::words, pattern = "(..)\1", match = TRUE)

# d) strings de la forma a.a.a
str_view(stringr::words, pattern = "(.).\\1.\\1", match = TRUE)

# e) Three characters followed by zero or more characters of any kind followed by the same three characters but in 
# reverse order. E.g. `"abcsgasgddsadgsdgcba"` or `"abccba"` or `"abc1cba"`.
str_view(stringr::words, pattern = "(.)(.)(.).*\\3\\2\\1", match = TRUE)

# 2) 
# a) start and end with the same letter
str_view(string = stringr::words, pattern = "^(.).*\\1$", match = TRUE) # more than one letter long
str_view(stringr::words, "^(.)((.*\\1$)|\\1?$)", match = TRUE) # also one letter long words

# b) contains a repeated pair of letters
str_view(stringr::words, "([a-zA-Z][a-zA-Z]).*\\1", match = TRUE)

# c) same letter repeated at least three times
str_view(stringr::words, "([a-zA-Z]).*\\1.*\\1", match = TRUE)

#--------------------------------------------------------#

#### TOOLS ####

## Detect matches
x <- c("apple", "banana", "pear")
str_detect(x, "e")

# How many common words start with t?
sum(str_detect(words, "^t"))
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))

# Finding all words that don't contain any vowels
# Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

## Select the elements that match a pattern
words[str_detect(words, "x$")]
str_subset(words, "x$")

df <- tibble(
  word = words,
  i = seq_along(word)
)
filter(df, str_detect(words, "x$"))

# str_count counts the number of matches in a string
x <- c("apple", "banana", "pear")
str_count(x, "a")

# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

# str_count and mutate
mutate(df,
  vowels = str_count(word, "[aeiou]"),
  consonants = str_count(word, "[^aeiou]")
)
mutate(df,
       vowels = str_count(word, "[aeiou]"),
       consonants = str_count(word, "[^aeiou]")
)

# Matches don't overlap
str_count("abababa", "aba")

#----------------- EXERCISES (page 211) -----------------#


#--------------------------------------------------------#

## Extract matches ##

length(sentences)
head(sentences)

# extracting sentences with colors
# First, create a vector with color names
colors <- c(
  "red", "orange", "yellow", "green", "blue", "purple"
)
# Then create a regexp that matches colors
color_match <- str_c(colors, collapse = "|")
# Find which sentences contain a color
has_color <- str_subset(sentences, color_match)
# Extract the color that they match
matches <- str_extract(has_color, color_match)
head(matches)

# Extracting matches with more than one match
more <- sentences[str_count(sentences, color_match) > 1] # there are three sentences with 2 matches
str_view_all(more, color_match)

# To get all matches use extract all
str_extract_all(more, color_match)
# simplify to get a matrix
str_extract_all(more, color_match, simplify = TRUE)
# R will complete the matrix when needed
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)

#----------------- EXERCISES (page 213) -----------------#


#--------------------------------------------------------#

## Grouped matches ##

# Extract words after "a" or "the" 
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>%
  str_extract(noun)

sentences %>%
  str_subset(noun) %>%
  head(10) %>% 
  str_extract(noun)

has_noun %>%
  str_match(noun)

# Matchinf is a tibble with tidyr::extract()
tibble(sentence = sentences) %>%
  tidyr::extract(col = sentence, 
                 into = c("article", "noun"), 
                 regex = "(a|the) ([^ ]+)", 
                 remove = FALSE)

#----------------- EXERCISES (page 215) -----------------#


#--------------------------------------------------------#

## Replacing matches

x <- c("apple", "pear", "banana")
# replaces the first match
str_replace(x, "[aeiou]", "-")
# replaces all matches
str_replace_all(x, "[aeiou]", "-")

# Perform multiple replacementes by supplying a names vector
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

# Use backreferences to insert components of the match
sentences %>% 
  head(5)
# Second and thrid word flip
sentences %>%
  str_replace(pattern = "([^ ]+) ([^ ]+) ([^ ]+)", 
              replacement = "\\1 \\3 \\2") %>%
  head(5)

#----------------- EXERCISES (page 216) -----------------#


#--------------------------------------------------------#

## Splitting
sentences %>%
  head(5) %>%
  str_split(" ")

"a|b|c|d" %>%
  str_split("\\|") %>%
  .[[1]]

# Use simplify to return a matrix
sentences %>%
  head(5) %>%
  str_split(" ", simplify = TRUE)

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
str_split(string = fields,
          pattern = ": ", 
          n = 2, simplify = TRUE)

# Splitting by boundary
x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("word"))
str_split(x, " ")[[1]]
str_split(string = x, pattern = boundary("word"))[[1]]

#----------------- EXERCISES (page 217) -----------------#


#--------------------------------------------------------#

## Find matches

# use str_locate and str_locate_all for starting and ending points of a match
# can then use str_sub to extract or modify the match

#### OTHER TYPES OF PATTERN #####

# The regular call:
str_view(fruit, "nana")
# Is shorthand for
str_view(fruit, regex("nana"))

# Ignore cases
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

# Multiline
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

# Comments
phone <- regex(
  "\\(?       # optional opening parens
  (\\d{3})    # area code
  [)- ]?      # optional closing parens, dash, or space
  (\\d{3})    # another three numbers
  [ -]?       # optional space or dash
  (\\d{3})    # three more numbers
  ", 
  comments = TRUE)
str_match("514-791-8141", phone)

# Low level regex
microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)

a1 <- "\u00e1"
a2 <- "a\u0301"
c(a1, a2)

a1 == a2

# Use of coll()
str_detect(a1, fixed(a2))
str_detect(a1, coll(a2))

# That means you also need to be aware of the difference when doing case-insensitive matches:
i <- c("I", "İ", "i", "ı")
i
str_subset(i, coll("i", ignore_case = TRUE))
str_subset(i, coll("i", ignore_case = TRUE, locale = "tr"))

# Finding default locale
stringi::stri_locale_info()

#----------------- EXERCISES (page 221) -----------------#


#--------------------------------------------------------#

#### OTHER USES OF REGULAR EXPRESSIONS ####

# Search objects in global environment. Useful when you can't remember the name of a function
apropos(what = "replace")

# dir() lists all files in a directory
head(dir(pattern = "\\.Rmd$"))
head(dir(pattern = "\\.R$"))

#----------------- EXERCISES (page 222) -----------------#


#--------------------------------------------------------#

################################
#### FIN DE LA PROGRAMACIÓN ####
################################