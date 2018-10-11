##############################
#### CHAPTER ONE: GGPLOT2 ####
##############################

library(tidyverse)

#### CREATING A PLOT WITH GGPLOT ####

ggplot(data=mpg) + 
      geom_point(mapping=aes(x=displ, y=hwy))

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
ggplot(data=mpg) # An empty canvas

# 2)
dim(mpg) # 234 rows, 11 columns

# 3)
?mpg # f=front-wheel drive, r=rear wheel drive, 4=4wd

# 4)
ggplot(data=mpg) + 
      geom_point(mapping=aes(x=hwy, y=cyl))

# 5)
ggplot(data=mpg) + 
      geom_point(mapping=aes(x=class, y=drv)) # Both are character variables

#----------------------------------------------------------------------------------------#

#### AESTHETIC MAPPINGS ####

# Associating different aesthetics to a variable
# An aesthetic is a visual property of the objects in a plot.
# Aesthetic properties have LEVELS
# SCALING: assigning a unique level of the aesthetic to each unique value of the variable

# To set aesthetics to variables, use aes()
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color=class))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, size=class))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, alpha=class))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, shape=class))

# To set aesthetics manually, set them outside the mapping
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), color="blue")
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), size=2)
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), alpha=0.5)
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), shape=21, color="red", fill="blue")

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color="blue"))
# Color needs to be outside the parentheses. ggplot is mapping the aes color to a variable 
# that only takes one value (blue).

# 2)
unlist(lapply(mpg, class))
# Categorical: manutacturer, model, year, cyl, trans, drv, fl, class (but they are coded as chr)
# continous: displ, cty, hwy

# 3)
ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, color=cty))
ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, size=cty))
ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, shape=cty))

ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, color=class))
ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, size=model))
ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, shape=trans))

# Some aes are better to be used with different types or variables (cont or discrete)

# 4)
ggplot(data=mpg) + 
      geom_point(mapping=aes(displ, hwy, color=class, shape=class))
# ggplot combines the scalling

# 5)
ggplot(data=mpg) + 
      geom_point(mapping=aes(displ, hwy), stroke=5, shape=16, fill="red")
# stroke controlls the width of the border for bordered and filled shapes and the color 
# for colored shapes

# 6)
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), color="blue")
ggplot(data=mpg) + geom_point(mapping=aes(displ, hwy, color=displ < 5), color="blue")
# it maps the scalling to a variable with only one level

#----------------------------------------------------------------------------------------#

#### FACETS ####

# Splits the plot into subplots each displaying one subset of data.
# face_wrap: faceting by a single variable
# face_grid: faceting by two variables
ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_wrap(~ class)

ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_wrap(~ class, nrow=2)

ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_grid(drv ~ cyl)

ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_grid(. ~ cyl)

ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_grid(cyl ~ .)

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
# It produces multiple plots
ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_wrap( ~ cty)

# 2)
# It means      drv==4 \cap cyl==5 => \emptyset
#               drv==r \cap cyl==4 => \emptyset
#               drv==r \cap cyl==5 => \emptyset
ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_grid(drv ~ cyl)
# No points in this graph
ggplot(data=mpg) + geom_point(mapping=aes(x=drv, y=cyl))

# 3)
# displ Vs hwy by drv (rows)
ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_grid(drv ~ .)
# displ Vs hwy by cyl (columns)
ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_grid(. ~ cyl)

# 4)
# With facet you get a different plot for every factor level. If the number of levels is
# too large, the number of graph will too.
ggplot(data=mpg) + 
        geom_point(mapping=aes(x=displ, y=hwy)) +
        facet_wrap(~ class, nrow=2)

# 5)
?facet_wrap
# nrow and ncol determine the number of rows and columns respectively.
# Other options that control layout: scales, shrink, as.table, switch, drop, dir, strip.position
# Because facet_grid by dafault, forms a matrix. The number of rows and columns are determined
# by the number of levels in each factor.

# 6)
?facet_grid
# Because of screen space limitations.

#----------------------------------------------------------------------------------------#

#### GEOMETRIC OBJECTS ####

# geoms are the geometrical object that ggplot uses to represent data.

ggplot(mpg) +
      geom_point(aes(displ, hwy))

ggplot(mpg) +
      geom_smooth(aes(displ, hwy))

ggplot(mpg) +
      geom_smooth(aes(displ, hwy, linetype=drv))

# Multiple geoms can be used in the same graph
ggplot(mpg) +
      geom_point(aes(displ, hwy, color=drv)) +
      geom_smooth(aes(displ, hwy, color=drv, linetype=drv))

# Global mappings will be used (inherited) by all subsequent geoms. Local mappings are 
# used to overide global mappings or to specify scallings that only apply to one layer

# the following both produce the same graph
ggplot(mpg) +
      geom_point(aes(displ, hwy)) +
      geom_smooth(aes(displ, hwy))

ggplot(mpg, aes(displ, hwy)) +
      geom_point() +
      geom_smooth()

# adding a scalling to points only
ggplot(mpg, aes(displ, hwy)) +
      geom_point(aes(color=drv)) +
      geom_smooth()

# changing the color of the line
ggplot(mpg, aes(displ, hwy)) +
      geom_point() +
      geom_smooth(color="red")

# the same principle can be applied to the data set that is been mapped
ggplot(mpg, aes(displ, hwy)) +
      geom_point(aes(color=class)) +
      geom_smooth(
            data=filter(mpg, class == "subcompact"), 
            se=FALSE
      )

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1)
# line chart: geom_line
# boxplot: geom_boxplot
# histogram: geom_histogram
# area chart: geom_area

# 2)
# prediction: scatter plot for displ and hwy colored by drv, with loess smooth by drv 
# (no se will be showned)
ggplot(mpg, aes(displ, hwy, color=drv)) +
      geom_point() +
      geom_smooth(se=FALSE)

# 3)
# show.legend = FALSE removes the legend for that layer

# 4)
# removes the display of the standard deviation 

# 5)
# they will look the same since the same variables of the same data set are been mapped to
# the same aesthetics using the same geoms
ggplot(mpg, aes(displ, hwy)) +
      geom_point() +
      geom_smooth()

ggplot() +
      geom_point(
            data=mpg,
            mapping=aes(x=displ, y=hwy)
      ) +
      geom_smooth(
            data=mpg,
            mapping=aes(x=displ, y=hwy)
      )

# 6)
# top left
ggplot(mpg, aes(displ, hwy)) +
      geom_point() +
      geom_smooth(se=FALSE)
# top right
ggplot(mpg, aes(displ, hwy)) +
      geom_point() +
      geom_smooth(aes(group=drv), se=FALSE)
# middle left
ggplot(mpg, aes(displ, hwy)) +
      geom_point(aes(color=drv)) +
      geom_smooth(aes(group=drv), se=FALSE)
# middle right
ggplot(mpg, aes(displ, hwy)) +
      geom_point(aes(color=drv)) +
      geom_smooth(se=FALSE)
# bottom left
ggplot(mpg, aes(displ, hwy)) +
      geom_point(aes(color=drv)) +
      geom_smooth(aes(linetype=drv), se=FALSE)
# bottom right
ggplot(mpg, aes(displ, hwy)) +
      geom_point(aes(color=drv))

#----------------------------------------------------------------------------------------#

#### STATISTICAL TRANSFORMATIONS ####

# A stat is the algorithm used to calculate new values for a graph:
#     identity: does not transformation to the data.
#     count: bins the data and counts how many data points fall in each bin
#     bin: 

# Each stat has a specific group of computed variableS:
#     stat_count: ..count.. and ..prop..
#     

# Each geom has a default stat and every stat has a default geom:
#     geom_point -> identity
#     geom_bar -> count
#     geom_histogram -> bin

# GENERALLY, geoms and stats can be used interchangeably:
ggplot(ggplot2::diamonds) +
      geom_bar(aes(cut))
ggplot(ggplot2::diamonds) +
      stat_count(aes(cut))

# But stats can also be overriden in different geoms:
demo <- tribble(
      ~a,     ~b,
      "bar_1", 20, 
      "bar_2", 30,
      "bar_3", 40)
ggplot(demo) +
      geom_bar(aes(x=a, y=b), stat="identity")

# One can also change from the default computed variable, to any other of them:
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., group=1))

# "you might want to draw greater attention to the stat transform in your code"
ggplot(diamonds) +
      stat_summary(mapping=aes(cut, depth),
                   fun.ymin=min,
                   fun.ymax=max,
                   fun.y=median)

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1) 
# default geom: pointrange
diamonds %>%
      group_by(cut) %>%
      summarise(mediana.gr = median(depth), min.gr = min(depth), max.gr = max(depth)) %>%
      ggplot() +
      geom_pointrange(aes(x=cut, y=mediana.gr, ymin=min.gr, ymax=max.gr)) +
      ylab("depth")

# No funciona. ggplot no quiere agrupar ... aes(group = ??)
ggplot(diamonds) +
      geom_pointrange(aes(x=cut, y=median(depth), ymin=min(depth), ymax=max(depth)))

# 2)
?geom_col
# Like goem_bar but heights of the bars represent the values in the data

# 3)
# See excel file: geoms and stats

# 4)
# computed variables: ..y.. & ..ymin.. & ..ymax.. & ..se..
# parameters: method & formula & se & n & span & fullrange & level & method.args

# 5) why does group need to be set to 1?
# whitout grouping: plots a and b
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop..))
ggplot(diamonds) +
      geom_bar(aes(cut, fill=color, y=..prop..))
# with grouping: plots c and d
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., group=1))
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., fill=color, group=color))

# In plot a prop is been calculated for each group. Therefore, it's always 1, since 100%
# of the Fair diamonds are in the Fair bar, 100% of Good diamonds are in the Good bar, and 
# so on. In plot c prop is been calculated for the different groups, since group=1 
# overrides the default grouping ggplot does and sets to group to a constant. The argument
# could have taken any other value such as 2 or 3 or 123 or "abc" and the result would
# have been the same, as demostrated below:
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., group=2))
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., group=3))
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., group=123))
ggplot(diamonds) +
      geom_bar(aes(cut, y=..prop.., group="abc"))
# They all render the same plot since the objective is to set the grouping argument to a
# constant. By default ggplot will always group by factor levels when either x or y are
# categorical variables.

# In plot b, problem is that we need to add a second grouping variable (cut been the 
# default one). group= color (as in plot d), will group results by variable color. 
# ggplot is calculating the within group proportions and ploting them in each bar so that 
# the proportion of each bar colored by one color represents the proportion of diamonds
# with that value of color for that of cut.

#----------------------------------------------------------------------------------------#

#### POISTION ADJUSTMENTS ####

# color arguments colors the perimeter of the bars
ggplot(diamonds) +
      geom_bar(aes(cut, color=cut))
# fill arguments colors the area of the bars
ggplot(diamonds) +
      geom_bar(aes(cut, fill=cut))

# if the fill argument is set to a different variable, each colored rectangle is the 
# combination of the two variables
ggplot(diamonds) +
      geom_bar(aes(cut, fill=clarity))

# by default the bars are stacked because that is the default value of argument position.
# This can be changed to either: "identity", "dodge", or "fill".

# "identity" will create as many bars as fill groups there are and place them on their 
# corresponding cut value. Problem here is the overplotting which can be "solved" by setting
# an alpha value less than 1. Variable been displayed is `..count..`
ggplot(diamonds) +
      geom_bar(aes(cut, fill=clarity), position="identity", alpha=1/4)

# "fill" stacks the bars but does so that each bar in the plot stacks to 100. Useful for
# comparisons. Each rectangle reporesents the proportion of `clarity` for that value 
# of `cut`. Variable been displayed is `..prop..`
ggplot(diamonds) +
      geom_bar(aes(cut, fill=clarity), position="fill")

# "dodge" places overlapping bars beside one another. Variable been displayed is
# `..count..`
ggplot(diamonds) +
      geom_bar(aes(cut, fill=clarity), position="dodge")

# For scatter plots with heavy overplotting we can use position `jitter`, which adds a 
# small random noise to each point so that the data mass is revealed.
ggplot(mpg) +
      geom_point(aes(displ, hwy), position="jitter")
# geom_jitter is used for that
ggplot(mpg) +
      geom_jitter(aes(displ, hwy))

#### ----------------------------------- EXERCISES ---------------------------------- ####

# 1) 
ggplot(mpg, aes(cty, hwy)) +
      geom_point()
# Problem is overplotting and it can be solved by jittering
ggplot(mpg, aes(cty, hwy)) +
      geom_jitter()
# or by using an alpha
ggplot(mpg, aes(cty, hwy)) +
      geom_point(alpha=1/5)

# 2)
?geom_jitter
# width and height control horizontal and vertical jitter. Default is 40%

# 3)
?geom_count
# While jitter adds noise to the points so that they don't overlap, count counts the number
# of points that coincide and uses that information as a point area aes.
# `jitter` -> stat = "identity", postition = "jitter"
# `count` -> stat = "sum", position = "identity"
ggplot(mpg, aes(cty, hwy)) +
      geom_count()

# 4) 
?geom_boxplot
# position = "dodge2"
ggplot(mpg) + 
      geom_boxplot(aes(drv, hwy, color=factor(year)))

#----------------------------------------------------------------------------------------#

sds

################################
#### FIN DE LA PROGRAMACIÓN ####
################################