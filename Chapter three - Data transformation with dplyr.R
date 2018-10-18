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




################################
#### FIN DE LA PROGRAMACIÓN ####
################################