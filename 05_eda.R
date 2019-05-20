###########################
#### CHAPTER FIVE: EDA ####
###########################

library(tidyverse)
library(hexbin)
library(modelr)

#### Variation ####

# To examine the distribution of categorical variables use a bar chart
ggplot(diamonds) +
      geom_bar(aes(cut))

# To get counts
diamonds %>%
      count(cut)

# To examine the distribution of a continuous variable use a histogram
ggplot(diamonds) +
      geom_histogram(aes(carat), binwidth = .5)

# To get values
diamonds %>%
      count(cut_width(carat, 0.5))

#### Typical Values ####

# Should always explore different binwidths
diamonds %>%
      filter(carat < 3) %>%
      ggplot() +
      geom_histogram(aes(carat), binwidth = .1)

diamonds %>%
   filter(carat < 3) %>%
   ggplot() +
   geom_histogram(aes(carat), binwidth = .01)

# When ploting several continous variables, use geom:freqpoly instead of geom_histogram. Same calcultion but displays lines
diamonds %>% 
   filter(carat < 3) %>% 
   ggplot() +
   geom_freqpoly(aes(carat, color = cut), binwidth = .1)

# Faithful gryser eruptions
ggplot(data = faithful) +
   geom_histogram(aes(x = eruptions), binwidth = 0.25)

#### Unusual vlaues ####

# Zoom in the axis with coord_cartesian
ggplot(diamonds) +
   geom_histogram(aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
   geom_histogram(aes(x = y), binwidth = 0.5) +
   coord_cartesian(ylim = c(0, 50))

# Find the outliers
unsual <- diamonds %>% 
   filter(y < 3 | y > 20) %>% 
   arrange(y)
unsual

#### ----------------------------------- EXERCISES ---------------------------------- ####

## 1) Explore x, y and z in diamonds
diamonds %>% 
   select(x, y, z) %>% 
   gather(key = key, value = value) %>% 
   ggplot() +
   geom_density(aes(value, y = ..density.., color = key)) +
   facet_wrap(~key, scales = "free_x")

diamonds %>% 
   select(x, y, z) %>% 
   gather(key = key, value = value) %>% 
   filter(value < 20) %>% 
   ggplot() +
   geom_boxplot(aes(x = key, y = value))
   
## 2) price
diamonds %>% 
   ggplot() +
   geom_histogram(aes(price), binwidth = 200)
## 3) carat
filter(diamonds, carat == 0.99)
filter(diamonds, carat == 1.00)

## 4)

#----------------------------------------------------------------------------------------#

#### Missing Values ####


#### Covariation ####

### One categorical and one continuous variable 

## Frequency Polygons

# Can't compare variation because counts vary too much
ggplot(data = diamonds, mapping = aes(x = price)) +
   geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds) +
   geom_bar(mapping = aes(x = cut))

# Use y = ..density.. instead of ..count.. (the default) for those cases
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
   geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

## Boxplots
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
   geom_boxplot()

# Unordered factor
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
   geom_boxplot()

# Ordered factor
ggplot(data = mpg) +
   geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

# Flip coords
ggplot(data = mpg) +
   geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
   coord_flip()

### Two categorical variables

## Counts
ggplot(data = diamonds) +
   geom_count(mapping = aes(x = cut, y = color))

## Tiles
diamonds %>% 
   count(color, cut) %>% 
   ggplot() +
   geom_tile(aes(x = color, y = cut, fill = n))

### Two continuous variables

## Scatter-plots
ggplot(data = diamonds) +
   geom_point(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
   geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

## bin2d and hex bin
smaller <- diamonds %>%
   filter(carat < 3)
ggplot(data = smaller) +
   geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = smaller) +
   geom_hex(mapping = aes(x = carat, y = price))

## Bin one variabale and use categorical-continuous approach
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
   geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
   geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = TRUE)

ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
   geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

#### Patterns ####

ggplot(data = faithful) +
   geom_point(mapping = aes(x = eruptions, y = waiting))

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>%
   add_residuals(mod) %>%
   mutate(resid = exp(resid))

ggplot(data = diamonds2) +
   geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) +
   geom_boxplot(mapping = aes(x = cut, y = resid))


################################
#### FIN DE LA PROGRAMACIÓN ####
################################