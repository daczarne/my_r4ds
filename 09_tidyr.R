#############################
#### CHAPTER NINE: TIDYR ####
#############################

#### Introduction ####

library(tidyverse)
library(hexbin)
library(modelr)
library(hms)

#### Tidy data ####

table1 %>%
      mutate(rate = cases / population * 10000)

table1 %>%
      count(year, wt = cases)

ggplot(table1, aes(year, cases)) +
      geom_line(aes(group = country), color = "grey50") +
      geom_point(aes(color = country))

#### Spreading and gathering ####

## Gather
table4a %>%
      gather(`1999`, `2000`, key = "year", value = "cases")

table4b %>%
      gather(`1999`, `2000`, key = "year", value = "population")

tidy4a <- table4a %>%
      gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>%
      gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)

## Spread

spread(table2, key = type, value = count)

#### Separating and pull ####

## Separate
table3 %>%
      separate(rate, into = c("cases", "population"))

# Sep argument is a regular expression
table3 %>%
      separate(rate, into = c("cases", "population"), sep = "/")

# Unless told to, separate will keep the original class for each variable
table3 %>%
      separate(rate, into = c("cases", "population"), convert = TRUE)

# sep also takes numeric values which it interprets as positions where to spearate
table3 %>%
      separate(year, into = c("century", "year"), sep = 2)
table3 %>%
      separate(year, into = c("century", "year"), sep = -2)

## Unite
table5 %>%
      unite(new, century, year)

table5 %>%
      unite(new, century, year, sep = "")

#### Missing values ####

stocks <- tibble(
      year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
      qtr = c( 1, 2, 3, 4, 2, 3, 4),
      return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)

stocks %>%
      spread(year, return)

stocks %>%
      spread(year, return) %>%
      gather(year, return, `2015`:`2016`, na.rm = FALSE)

# complete()
stocks %>%
      complete(year, qtr)

# fill()
treatment <- tribble(
      ~ person,           ~ treatment, ~response,
      "Derrick Whitmore", 1,           7,
      NA,                 2,           10,
      NA,                 3,           9,
      "Katherine Burke",  1,           4,
      NA,                 0,           1
)

treatment %>%
      fill(person)


#### Case study ####

# TB data set
who

# tidying process:
#     i) gather all variables from new_sp_m014 to newrel_f65  (remove NA's)
#     ii) change keys "newrel" for "new_rel"
#     iii) separate variables by underscore (does not separate sex and age braket)
#     iv) drops new, iso2 and iso3
#     v) separate sexage into sex and age
who %>%
      gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE) %>% 
      mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>% 
      separate(key, c("new", "type", "sexage"), sep = "_") %>% 
      select(-new, -iso2, -iso3) %>% 
      separate(sexage, c("sex", "age"), sep = 1)


#### Nontidy data ####

# has it's uses


################################
#### FIN DE LA PROGRAMACIÓN ####
################################