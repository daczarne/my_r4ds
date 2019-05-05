##############################
#### CHAPTER EIGHT: READR ####
##############################

#### Introduction ####

library(tidyverse)
library(hexbin)
library(modelr)
library(hms)

#### Getting started ####

read_csv(
"a,b,c
1,2,3
4,5,6"
)

# Skipping lines
read_csv("The first line of metadata
The second line of metadata
x,y,z
1,2,3", skip = 2)

read_csv("# A comment I want to skip
x,y,z
1,2,3", comment = "#")

# Col names
read_csv("1,2,3\n4,5,6", col_names = FALSE)
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

# Missing values
read_csv("a,b,c\n1,2,.", na = ".")

#### ----------------------------------- EXERCISES ---------------------------------- ####





#----------------------------------------------------------------------------------------#

#### Parsing a vector ####

# parse_*() functions take character vectors and return vector of class *
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

# Missing values
parse_integer(c("1", "231", ".", "456"), na = ".")

# Parse failure
x <- parse_integer(c("123", "345", "abc", "123.45"))
x

## Numbers

# Creaating a locale
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

# Parsing numbers
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

# Grouping marks
parse_number("$123,456,789")
parse_number("123.456.789", locale = locale(grouping_mark = "."))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

## Strings

# Underlying representatios on a string is done in hexadecimal numbers. The mapping from hexadecimal to character is
# called encoding. readr uses UTF-8, but allows for other encoding systems.
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particularly bad this year"
parse_character(x1, locale = locale(encoding = "Latin1"))

x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# Use guess_encoding when encoding is unknown
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

## Factors
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "banana"), levels = fruit)

## Dates, date-times, and times

# Date: the number of days since 1970-01-01
# Date-time: number of seconds since midnight 1970-01-01
# Time: nu,ber of seconds since midnight

# parse_date exprects an ISO8601 date-time
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

# parse date expects a four-digit year, month and then day, separated by "-" or "/"
parse_date("2010-10-01")

# parse_time() expects the hour, :, minutes, optionally : and seconds, and an optional a.m./p.m. specifier:
parse_time("01:10 am")
parse_time("01:10 pm")
parse_time("20:10:01")

# Users can build their own data time formats with:
# Year:
#     %Y - 4 digits
#     %y - 2 digits: 00-69 mean 2000 to 2069, and 70-99 mean 1970 to 1999
# Month:
#     %m - 2 digits
#     %b - abbreviated names (in English?)
#     %B - full name
# Day:
#     %d - 2 digits
#     %e - optional leading spaces
# Time:
#     %H - 0-23 hour format
#     %I - 0-12 hour format, must be used with %p
#     %p - a.m./p.m. indicator
#     %M - minutes
#     #S integer seconds
#     %OS - real seconds
#     %Z - named time zone
#     %z - time zone as offset from UTC
# Nondigits:
#     %. - skips one nondigit characters
#     %* - skips any number of nondigit characters

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/jan/15", "%y/%b/%d")

# Named months requiere setting the language locale
date_names_langs() # shows abbreviation for each available language
date_names_lang("es") # Shows full and abbraviated names for laanguage "es" (Spanish)

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))
parse_date("1 janv. 2015", "%d %b %Y", locale = locale("fr"))

#### Parsing a file ####

# Every parse_xyz() function has a corresponding col_xyz() function. Use parse_xzy() when the data is already in R. Use
# col_xyz() when telling readr how to read the data.

# Other strategies include:
#     i) change guess_max argument. guess_max = 1001
#     ii) read all columns as character: col_types = cols(.default = col_character())
#     iii) for large data sets change n_max to 10.000 or 100.000 while you eliminate the problems
#     iv) use read_lines() to read each line as character or read_file() to read it all as a chacter vector oof lenght 1

#### Writing to a file ####

# write to csv with write_csv() or tabs with write_tsv().
# Use UTF-8 encoding and ISO8601 format for dates and date-times
# use write_excel_csv() to write excel files

# Use write_rds() and read_rds() to save in R binary (and conserve data types)

#### Other types of data ####

# Use the corresponding tidyverse packagees

################################
#### FIN DE LA PROGRAMACIÓN ####
################################