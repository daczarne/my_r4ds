#$############################
#### CHAPTER ONE: GGPLOT2 ####
#$############################

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



#$##############################
#### FIN DE LA PROGRAMACIÓN ####
#$##############################