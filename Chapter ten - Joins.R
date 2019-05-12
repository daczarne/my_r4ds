#################################################
#### CHAPTER TEN: RELATIONAL DATA WITH DPLYR ####
#################################################

#### Introduction ####

library(tidyverse)
library(hexbin)
library(modelr)
library(hms)
library(nycflights13)

#### nycflights13 ####

# 4 tibbles
airlines
airports
planes
weather

#### Keys ####

planes %>%
      count(tailnum) %>%
      filter(n > 1)

weather %>%
      count(year, month, day, hour, origin) %>%
      filter(n > 1)

flights %>%
      count(year, month, day, flight) %>%
      filter(n > 1)


#### Mutating joins ####

flights2 <- flights %>%
      select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>%
      select(-origin, -dest) %>%
      left_join(airlines, by = "carrier")

flights2 %>%
      select(-origin, -dest) %>%
      mutate(name = airlines$name[match(carrier, airlines$carrier)])

## Understanding joins
x <- tribble(
      ~key, ~val_x,
      1, "x1",
      2, "x2",
      3, "x3"
)

y <- tribble(
      ~key, ~val_y,
      1, "y1",
      2, "y2",
      4, "y3"
)

## Inner join
x %>%
      inner_join(y, by = "key")


## Outer joins


## Duplicated keys
x <- tribble(
      ~key, ~val_x,
      1, "x1",
      2, "x2",
      2, "x3",
      1, "x4"
)
y <- tribble(
      ~key, ~val_y,
      1, "y1",
      2, "y2"
)
left_join(x, y, by = "key")


x <- tribble(
      ~key, ~val_x,
      1, "x1",
      2, "x2",
      2, "x3",
      3, "x4"
)
y <- tribble(
      ~key, ~val_y,
      1, "y1",
      2, "y2",
      2, "y3",
      3, "y4"
)
left_join(x, y, by = "key")

## Defining the key columns
flights2 %>%
      left_join(weather)

flights2 %>%
      left_join(planes, by = "tailnum")

flights2 %>%
      left_join(airports, c("dest" = "faa"))

flights2 %>%
      left_join(airports, c("origin" = "faa"))


#### Filtering joins ####

top_dest <- flights %>%
      count(dest, sort = TRUE) %>%
      head(10)
semi_join(flights, top_dest)


flights %>%
      anti_join(planes, by = "tailnum") %>%
      count(tailnum, sort = TRUE)

#### Join problems ####


#### Set operations ####

df1 <- tribble(
      ~x, ~y,
      1, 1,
      2, 1
)
df2 <- tribble(
      ~x, ~y,
      1, 1,
      1, 2
)

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)

################################
#### FIN DE LA PROGRAMACIÓN ####
################################