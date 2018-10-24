##############################
#### CHAPTER THREE: DPLYR ####
##############################

library(nycflights13)
library(tidyverse)

#### filter() ####

# filter allows you to subset observations bases on the values.
jan1 <- filter(flights, month==1, day==1)

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
# a) arrival delay of 2 or more hours
filter(flights, arr_delay >= 2)
# b) flew to IAH or HOU
filter(flights, dest %in% c("IAH", "HOU"))
# c) were operated by United, America or Delta
nycflights13::airlines
filter(flights, carrier %in% c("AA", "UA", "DL"))
# d) departed in winter (July, August, September)
filter(flights, month %in% c(7, 8, 9))
# e) arrived more than two hours late, but didn't leave late
filter(flights, dep_delay <= 0, arr_delay > 2)
# f) were delayed by at least 1 hour, but made up over 30 minutes in flight
filter(flights, air_time > 30, dep_delay >= 1 | arr_delay >= 1)
# g) departed between midnight and 6 am (inclusive)
filter(flights, dep_time == 2400 | (dep_time >= 0 & dep_time <= 600))
#filter(flights, (dep_time >= 0 & dep_time <= 600))

# 2)
?between
filter(flights, between(month, 7, 9))
filter(flights, air_time > 30, between(dep_delay, 1, Inf) | between(arr_delay, 1, Inf))
filter(flights, dep_time == 2400 | (between(dep_time, 0, 600)))

# 3)
filter(flights, is.na(dep_time)) # 8255 have NA dep_time
filter(flights, is.na(dep_time), !is.na(arr_time))
# There are no flights with no dep_time and arr_time
filter(flights, !is.na(dep_time), is.na(arr_time))
# Flights with dep_time but no arr_time could represent flights that crashed
filter(flights, is.na(dep_time), is.na(arr_time))
# Flights with no dep_time and no arr_time could represent cancelled flights

# 4)
NA ^ 0 # Anything to the zero power is equal to 1?? doesn't work with character, but that
       # makes sense
NA | TRUE # evals to TRUE since it's an or
FALSE & NA # evals to FALSE since both need to eval to TRUE for an and to be TRUE
# I can't figure out the general rule.

#----------------------------------------------------------------------------------------#

### arrange() ####

# arrange orders the rows in ascending order based on the values of a variable
# additional variables can be used to break ties
# desc() is used to order in descending order
# NAs are always sorted at the end

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
arrange(flights, !is.na(dep_time))

# 2)
arrange(flights, desc(dep_delay))

# 3)
# velocity = distance / time
arrange(flights, desc(distance/air_time))

# 4)
# longest
arrange(flights, desc(distance))
# shortest
arrange(flights, distance)

#----------------------------------------------------------------------------------------#

#### select() ####

# selects variables based on their names

# selec variables year, month and day
select(flights, year, month, day)
# select all variables between year and day
select(flights, year:day)
# select all variables except those from year to day (inclusive)
select(flights, -(year:day))

# helper function
#     starts_with("character string")
#     ends_with("character string")
#     contains("character string")
#     matches("regexp")
#     num_range("x", 1:3) matches x1, x2, and x3

# rename() is a variation of selects that changes the name of a variable and keeps all
# the rest: rename(tibble, old_name = new_name)
rename(flights, tail_num = tailnum)

# use helper everything() to move some varable(s) to the start of your data_frame
select(flights, time_hour, air_time, everything())

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1) dep_time, dep_delay, arr_time, arr_delay
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, dep_time:arr_delay, -contains("sched"))
select(flights, matches("time"), matches("delay"), -matches("sched"), -matches("air"), -matches("hour"))

# 2)
select(flights, dep_time, dep_time)
# nothing happens?

# 3) 
?one_of # selects variables in character vector.
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

# 4)
select(flights, contains("TIME"))
# default arg is ignore.case=TRUE => not surpising 

#----------------------------------------------------------------------------------------#

#### mutate() ####

# adds new columns at the end of the data set
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)
# you can refer to columns you've just created
mutate(flights_sml, gain = arr_delay - dep_delay, hours = air_time * 60, 
       gain_per_hour = gain / hours)
# if you only want to keep the new variables use transmute()
transmute(flights, gain = arr_delay - dep_delay, hours = air_time * 60, 
          gain_per_hour = gain / hours)
# you can use any vectorized function to creat new variables
#     arithmetic operators: + - / *
#     modular arithmetic: %/% (integer division) %% (remainder)
transmute(flights, dep_time, hour = dep_time %/% 100, minute = dep_time %% 100)
#     logarithms
transmute(flights, dep_time, log_dep_time = log2(dep_time))
#     offsets: lead() lag()
sort(unique(flights$month))
lead(sort(unique(flights$month)))
lag(sort(unique(flights$month)))
#     cumulative aggregates: cumsum() cumprod() cummin() cummax() cummean()
cumsum(c(1:10))
cumprod(c(1:10))
#     rolling aggregates: use RcppRoll package
#     logical comparisons: < <= == >= > !=
#     ranking: min_rank(), row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1) 
transmute(flights, dep_time, sched_dep_time, 
          dt_mins_from_mid = (dep_time %/% 100) * 60 + (dep_time %% 100),
          scdt_mins_from_mid = (sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100))

# 2) 
# both arr_time and dep_time are in local tz. Both should be the same if this is accounted
# for
transmute(flights, air_time, arr_time, dep_time,
          at_from_mid = (arr_time %/% 100) * 60 + (arr_time %% 100),
          dt_from_mid = (dep_time %/% 100) * 60 + (dep_time %% 100),
          air_time_2 = at_from_mid - dt_from_mid)

# 3)
# delay should be the difference between scheduled and dep.

# 4)
transmute(flights, dep_delay, arr_delay,
          total_delay = if_else(dep_delay > 0 & arr_delay > 0, dep_delay + arr_delay, 
                                if_else(dep_delay > 0 & arr_delay <= 0, dep_delay,
                                        if_else(dep_delay <= 0 & arr_delay > 0, arr_delay, 0))),
          delay_ranking = min_rank(desc(total_delay))) %>%
      arrange(desc(total_delay))
      
# ggplot(flights) +
#       geom_point(aes(dep_delay, arr_delay), alpha = 1/10) +
#       geom_hline(yintercept=0, color="red") + 
#       geom_vline(xintercept=0, color="red")


# 5)
1:3 + 1:10
# recycling

# 6)
?Trig

#----------------------------------------------------------------------------------------#

#### summarize() ####



#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)





#----------------------------------------------------------------------------------------#

#### GRouped Mutates ####



#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)





#----------------------------------------------------------------------------------------#





################################
#### FIN DE LA PROGRAMACIÓN ####
################################