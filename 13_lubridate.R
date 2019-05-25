################################
#### Chapter 13 - Lubridate ####
################################

#### INTRODUCTION ####

library(tidyverse)
library(magrittr)
library(lubridate)
library(nycflights13)

#### CREATING DATE/TIME ####

# There are three types of date/time data:
#     date: <date>
#     time: <time>
#     date/time: include time zones <dttm>

# To work with times, refer to hms package

# To get the current date use:
today()
# To get hte current date-time:
now()

### From Strings ###

# lubridate has helper functions to parse date-time objects from string. First identify the order in which year, month and
# day appear in the string then arrange "y", "m" and "d" accordingly
ymd("2017-01-31")             # year-month-day
mdy("January 31st, 2017")     # month-day-year
dmy("31-Jan-2017")            # day-month-year
ymd(20170131)                 # Can also use this functions with numeric data

# All these functions creared date objects. Tho create daate-time objects add and underscore and one or more "h", "m", "s"
ymd_hms("2017-01-31 20:11:59")      # creates date-time object with UTC time zone
mdy_hm("01/31/2017 08:01")          # creates date-time object with 00 seconds and UTC time zone

# Can also create date-time objects with date objects by supplying a time zone
ymd(20170131, tz = "UTC")

### From individual components ###

# When date or date-time data si spread across multiple columns, use make_date or make_datetime
flights %>% select(year, month, day, hour, minute)

flights %>%
      select(year, month, day, hour, minute) %>%
      mutate(departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time) {
      make_datetime(year, month, day, time %/% 100, time %% 100)
      }

flights_dt <- flights %>%
      filter(!is.na(dep_time), !is.na(arr_time)) %>%
      mutate(dep_time = make_datetime_100(year, month, day, dep_time),
             arr_time = make_datetime_100(year, month, day, arr_time),
             sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
             sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>%
      select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>%
      ggplot(aes(dep_time)) +
      geom_freqpoly(binwidth = 86400) + # 86400 seconds = 1 day
      labs(title = "Distribution of departure times across the year")

flights_dt %>%
      filter(dep_time < ymd(20130102)) %>%
      ggplot(aes(dep_time)) +
      geom_freqpoly(binwidth = 600) + # 600 s = 10 minutes
      labs(title = "Distribution of departure times during January 1st, 2013")
      
### From other types ###

# To switch between date-time and date use the as_ functions
as_datetime(today())
as_date(now())
as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)

#---------------- EXERCISES (page 243) ----------------#

# 1) you get a warning for the ones that couldn't parse
ymd(c("2010-10-10", "bananas"))

# 2) Set's the time zone. Today is not "today" in every time zone at the same time
today()
today() == today("GMT") # not always true

# 3) 
d1 <- "January 1, 2010"
mdy(d1)
d2 <- "2015-Mar-07"
ymd(d2)
d3 <- "06-Jun-2017"
dmy(d3)
d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)
d5 <- "12/30/14" # Dec 30, 2014
mdy(d5)

#------------------------------------------------------#

#### DATE TIMEE COMPONENTS ####

### Getting components ###

# Use accessor functions to get date components
datetime <- ymd_hms("2016-07-08 12:34:56")
year(datetime)                               # returns the year
month(datetime)                              # returns the month: in number
month(datetime, label = TRUE)                # returns the month: abbreviation
month(datetime, label = TRUE, abbr = FALSE)  # returns the month: full name
mday(datetime)                               # returns day of the month
yday(datetime)                               # returns the day of the year
wday(datetime)                               # returns day of the week: 1 == Monday, ..., 7 == Sunday
wday(datetime, label = TRUE)                 # returns day of the week: abbr name
wday(datetime, label = TRUE, abbr = FALSE)   # returns day of the week: full name

flights_dt %>%
   mutate(wday = wday(dep_time, label = TRUE)) %>%
   ggplot(aes(x = wday)) +
   geom_bar()

flights_dt %>%
   mutate(minute = minute(dep_time)) %>%
   group_by(minute) %>%
   summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>%
   ggplot(aes(minute, avg_delay)) +
   geom_line()

sched_dep <- flights_dt %>%
   mutate(minute = minute(sched_dep_time)) %>%
   group_by(minute) %>%
   summarize(
      avg_delay = mean(arr_delay, na.rm = TRUE),
      n = n())

ggplot(sched_dep, aes(minute, avg_delay)) +
   geom_line()

ggplot(sched_dep, aes(minute, n)) +
   geom_line()

### Rounding dates ###

flights_dt %>%
   count(week = floor_date(dep_time, "week")) %>%
   ggplot(aes(week, n)) +
   geom_line()

weeks <- flights_dt %>%
   mutate(week = week(dep_time)) %>% 
   count(week)

flights_dt %>%
   count(week = floor_date(dep_time, "week")) %>%
   rename(rounded_n = n) %>% 
   dplyr::bind_cols(weeks) %>% 
   ggplot() +
   geom_line(aes(week, n), color = "blue") +
   geom_line(aes(week, rounded_n), color = "red")

### Setting components ###

# Can set using accessor functions
(datetime <- ymd_hms("2016-07-08 12:34:56"))
year(datetime) <- 2020
datetime
month(datetime) <- 01
datetime
hour(datetime) <- hour(datetime) + 1
datetime

# Can uodate using update(). This function can roll over
update(datetime, year = 2020, month = 2, mday = 2, hour = 2)
ymd("2015-02-01") %>% update(mday = 30)
ymd("2015-02-01") %>% update(hour = 400)

flights_dt %>%
   mutate(dep_hour = update(dep_time, yday = 1)) %>% # sets year date as Jan 1 for every flight.
   ggplot(aes(dep_hour)) +
   geom_freqpoly(binwidth = 300)

#---------------- EXERCISES (page 248/9) ----------------#


#--------------------------------------------------------#

#### TIME SPANS ####

# Durations: exact number of seconds
# Periods: human units (like weeks and months)
# Intervals: starting and ending point

### Duration ###

# How old is Hadley?
h_age <- today() - ymd(19791014)
h_age

# Duration objects always uses seconds
as.duration(h_age)
as.duration(today() - ymd(19871105))

# Duration constructor functions
dseconds(15)
dminutes(10)
dhours(c(12, 24))
ddays(0:5)
dweeks(3)
dyears(1)

# Can add and multiply durations
2 * dyears(1)
dyears(1) + dweeks(12) + dhours(15)

# Can add and substract duraations to and from days
tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

# Problem with durations and Daylight Savings Time
one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")
one_pm
one_pm + ddays(1)

### Periods ###

# Periods are time spans that work with human time instead of fixed intervals
one_pm
one_pm + days(1)

# Periods constructor functions (only takes integer values)
seconds(15)
minutes(10)
hours(c(12, 24))
hours(12.5) # error
days(7)
months(1:6)
weeks(3)
years(1)

# Can be added and multiplied
10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)

# Can add them to dates
# A leap year
ymd("2016-01-01") + dyears(1)
ymd("2016-01-01") + years(1)

# Daylight Savings Time
one_pm + ddays(1)
one_pm + days(1)

# Fixing flights13 (overnight flights)
flights_dt %>%
   filter(arr_time < dep_time)

flights_dt <- flights_dt %>%
   mutate(overnight = arr_time < dep_time,
          arr_time = arr_time + days(overnight * 1),
          sched_arr_time = sched_arr_time + days(overnight * 1))

flights_dt %>%
   filter(overnight, arr_time < dep_time)

### Invtervals ###

# Intervals are durations with a starting point
dyears(1) / ddays(365)
years(1) / days(1)

# %--% is an operator that creates an interval that covers the range spanned by two dates 
next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)

# To find how many periods fall into an interval, use integer division
(today() %--% next_year) %/% days(1)

#### TIME ZONES ####

# R uses IANA time zones: "<continent/city>" (with some few exceptions)

# find local time zone (according to R). If R dosen't know, it'll produce NA
Sys.timezone()

# All time zones:
length(OlsonNames())
head(OlsonNames())

# the time zone is an attribute of the date-time that only controls printing
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))

x1 - x2
x1 - x3

# Two wayas of chaning time zones:
# i) keep the instant in times the same and chaange how it's displayed
(x4 <- c(x1, x2, x3))
(x4a <- with_tz(x4, tzone = "Australia/Lord_Howe"))
with_tz(x4, tzone = Sys.timezone())
x4a - x4
# ii) change the instant in time
(x4b <- force_tz(x4, tzone = "Australia/Lord_Howe"))
x4b - x4

################################
#### Fin de la programación ####
################################