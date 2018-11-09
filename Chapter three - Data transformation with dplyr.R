##############################
#### CHAPTER THREE: DPLYR ####
##############################

library(nycflights13)
library(Lahman)
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

# collapses data fram into a single row
summarise(flights, delay = mean(dep_delay, na.rm=TRUE))

# if used with groupp_by(), computes summaries per groups
# use the pipe operator to pipe operationes (duh!)
# aggregate function follow standard NA tules
group_by(flights, year, month, day) %>%
      summarise(delay = mean(dep_delay, na.rm=TRUE))

# when using aggregate functions it si always a good idea to include counts and/or counts
# of non missing values
group_by(flights, month) %>%
      summarise(obs = n(), not_na = sum(!is.na(dep_delay)))

delays <- flights %>%
      group_by(dest) %>%
      summarise(
            count = n(),
            dist = mean(distance, na.rm=TRUE),
            delay = mean(arr_delay, na.rm=TRUE)
      ) %>%
      filter(count > 20, dest != "HNL")

not.cancelled <- flights %>%
      filter(!is.na(dep_delay), !is.na(arr_delay))

not.cancelled %>%
      group_by(tailnum) %>%
      summarise(delay = mean(arr_delay)) %>%
      ggplot() +
      geom_freqpoly(aes(delay), binwidth = 10)
      

not.cancelled %>%
      group_by(tailnum) %>%
      summarise(delay = mean(arr_delay, na.rm=TRUE), n = n()) %>%
      ggplot() +
      geom_point(aes(x=n, y=delay), alpha=1/10)

# remove smaller groups
not.cancelled %>%
      group_by(tailnum) %>%
      summarise(delay = mean(arr_delay, na.rm=TRUE), n = n()) %>%
      filter(n > 25) %>%
      ggplot() +
      geom_point(aes(x=n, y=delay), alpha=1/10, color="red")

# Summary functions:
#     Location: mean(), median()
not.cancelled %>%
      group_by(year, month, day) %>%
      summarise(
            # average delay:
            avg_delay1 = mean(arr_delay),
            # average positive delay
            avg_delay2 = mean(arr_delay[arr_delay > 0])
      )
#     Spread: sd(), IQR(), mad()
not.cancelled %>%
      group_by(dest) %>%
      summarise(distance_sd = sd(distance)) %>%
      arrange(desc(distance_sd))
#     Rank: min(), quantile(), max()
not.cancelled %>%
      group_by(year, month, day) %>%
      summarise(
            first = min(dep_time),
            last = max(dep_time)
      )
#     Position: first(), nth(),last()
not.cancelled %>%
      group_by(year, month, day) %>%
      summarise(
            first_dep = first(dep_time),
            last_dep = last(dep_time)
      )
# this is equivalent to filtering on ranks:
not.cancelled %>%
      group_by(year, month, day) %>%
      mutate(r = min_rank(desc(dep_time))) %>%
      filter(r %in% range(r))
#     Counts: n(), sum(!is.na()), n_distinct()
not.cancelled %>%
      group_by(dest) %>%
      summarise(carriers = n_distinct(carrier)) %>%
      arrange(desc(carriers))
# counter helper function
not.cancelled %>%
      count(dest, wt=distance)
#     Counts and proportions of logical values: TRUE = 1, FALSE = 0

# to return to ungrouped data use ungroup()

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
# how's a group of flights defined??

# 2)
not.cancelled %>%
      count(dest)
not.cancelled %>%
      group_by(dest) %>%
      tally()

not.cancelled %>%
      count(tailnum, wt=distance)
not.cancelled %>%
      group_by(tailnum) %>%
      tally(wt=distance)

# 3)
# if a flight was cancelled then the arrival becomes irrelevant

# 4)
flights %>%
      mutate(cancelled = if_else(is.na(dep_time) & is.na(arr_time), 1, 0)) %>%
      group_by(year, month, day) %>%
      summarise(
            n = n(), 
            prop_cancelled = mean(cancelled),
            mean_delay = mean(dep_delay, na.rm=TRUE)
      ) %>%
      ggplot(aes(prop_cancelled, mean_delay)) +
      geom_point(alpha = 1/5, color="red") +
      geom_smooth()

# 5)
# Carriers by mean delay
flights %>%
      group_by(carrier) %>%
      summarise(mean_delay = mean(dep_delay, na.rm=TRUE)) %>%
      arrange(desc(mean_delay))

# Carriers/destinations by mean delay
flights %>%
      group_by(carrier, dest) %>%
      summarise(n = n(), mean_delay = mean(dep_delay, na.rm=T)) %>%
      arrange(desc(mean_delay))

# Disentangle effect
ggplot(flights, aes(dest, y=dep_delay)) +
      geom_boxplot() +
      facet_grid(~carrier) +
      coord_flip() +
      theme(axis.text=element_text(size = 7))

# subsetting carriers and airports for simplicity
filter(flights, 
       dest %in% sample(dest, 25),
       carrier %in% sample(carrier, 10)
       ) %>%
      droplevels() %>%
      group_by(carrier, dest) %>%
      summarise(mean_delay = mean(dep_delay, na.rm=TRUE)) %>%
      ggplot(aes(dest, mean_delay)) +
      geom_point() +
      facet_grid(~carrier) +
      coord_flip() +
      theme(axis.text=element_text(size = 7))

# 6)
flights %>%
      filter(!is.na(dep_time)) %>%
      mutate(greater_60 = if_else(dep_delay > 60, 1, 0)) %>%
      group_by(tailnum) %>%
      mutate(has_delay = cumsum(greater_60)) %>%
      filter(has_delay == 0) %>%
      tally()

# to examin the data set use
flights %>%
      filter(!is.na(dep_time)) %>%
      mutate(greater_60 = if_else(dep_delay > 60, 1, 0)) %>%
      group_by(tailnum) %>%
      mutate(has_delay = cumsum(greater_60)) %>%
      select(tailnum, greater_60, has_delay, dep_delay, everything()) %>%
      arrange(.by_group=TRUE) %>%
      View()

# 7)
?dplyr::count
# sort output in descending order
# will use it when needed

#----------------------------------------------------------------------------------------#

#### Grouped Mutates ####

# Find the worst members of each group
flights_sml %>%
      group_by(year, month, day) %>%
      filter(rank(desc(arr_delay)) <= 2)

# Find all groups bigger than a threshold
popular_dests <- flights %>%
      group_by(dest) %>%
      filter(n() > 365)

# Standarize to compute per group metrics
popular_dests %>%
      filter(arr_delay > 0) %>%
      mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
      select(year:day, dest, arr_delay, prop_delay)


#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
# They operate on a per group basis

# 2)
flights %>%
      mutate(late = if_else(arr_delay > 0, 1, 0)) %>%
      group_by(tailnum) %>%
      summarise(siempre_tarde = mean(late, na.rm=TRUE)) %>%
      arrange(desc(siempre_tarde))

# 3)
flights %>%
      mutate(late = if_else(arr_delay > 0, 1, 0)) %>%
      group_by(sched_dep_time) %>%
      summarise(worst_times = mean(late, na.rm=TRUE)) %>%
      arrange(desc(worst_times))

# 4)
flights %>%
      group_by(dest) %>%
      summarise(total_delay = sum(arr_delay, na.rm=TRUE))

flights %>%
      group_by(dest) %>%
      mutate(dest_total_delay = sum(arr_delay, na.rm=TRUE)) %>%
      ungroup() %>%
      group_by(tailnum, dest) %>%
      summarise(prop_delay = sum(arr_delay, na.rm=TRUE) / first(dest_total_delay))

# 5) 
flights %>%
      filter(!is.na(dep_delay)) %>%
      mutate(previous_dep_delay = lag(dep_delay)) %>%
      ggplot() +
      geom_point(aes(previous_dep_delay, dep_delay), alpha=1/5)

# 6)
flights %>%
      mutate(velocity = distance / air_time) %>%
      select(velocity, everything()) %>%
      arrange(desc(velocity))

# 7) 
flights %>%
      group_by(dest) %>%
      summarise(num_carriers = n_distinct(carrier)) %>%
      arrange(desc(num_carriers))

#----------------------------------------------------------------------------------------#

################################
#### FIN DE LA PROGRAMACIÓN ####
################################