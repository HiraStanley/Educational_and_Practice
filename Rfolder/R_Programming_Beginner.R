install.packages("tidyverse")
library(tidyverse)
print("Coding in R")
?print()

# Here's an example of a variable
first_variable <- "This is my variable"
second_variable <- 12.5
vec_1 <- c(13, 48.5, 71,101.5,2)
vec_1

# checking types of vectors
typeof(c("a","b")) #character
typeof(c(1,2)) #double, decimal values
typeof(c(1L,2L)) #integer, whole numbers
typeof(c(TRUE,FALSE, TRUE)) #logical

# checking lengths of vectors
x <- c(33.5, 57.5, 120.05)
length(x)
is.integer(x)
is.double(x)

# naming vectors
y <- c(1,2,3)
names(y) <- c("a", "b", "c")
y

# creating lists (elements can be any type)
list("a", 1L, 1.5, TRUE)

# what types of elements a list contains
str(list("a", 1L, 1.5, TRUE))

# list within a list
z <- list(list(list(1,3,5)))
str(z) #indentation shows the nesting

# naming lists
list('Chicago' =1, 'New York'=2, 'Los Angeles' = 3)

# working with dates and times
library(lubridate)
today()
now()
ymd("2023-08-09")
mdy("January 20, 2021")
ymd(20180506)
as_date(now())

# data frame is collection of columns like SQL
data.frame(x=c(1,2,3), y=c(1.5,5.5,7.5))

# files
dir.create("hira_destination_folder")
file.create("text_file.txt")
file.create("word_file.docx")
file.create("csv_file.csv")
file.copy("text_file.txt", "hira_destination_folder")
unlink("csv_file.csv") #delete

# matrix, columns below are a vector and then 2 rows
matrix(c(3:8), nrow = 2)
matrix(c(3:8), ncol = 2)

# our first calculations
quarter_1_sales <- 12598.25
quarter_2_sales <- 60346.78
midyear_sales <- quarter_1_sales + quarter_2_sales
yearend_sales <- midyear_sales * 2

# and operator
TRUE & TRUE
TRUE & FALSE
FALSE & FALSE
x <- 10
x > 3 & x <12

# or operator
TRUE | FALSE
y <- 7
y < 8 | y > 16

# not operator
!TRUE

# conditional statements
a <- 0
if (a > 0) {
  print("a is a positive number")
} else if ( a == 0) {
    print("a is zero")
} else {
    print("a is a negative number")
  }

# functions
head(diamonds) # preview the data
str(diamonds) # summaries of each column horizontally
glimpse(diamonds) # summaries of each column horizontally
colnames(diamonds) # returns column names
rename(diamonds, carat_new = carat)
summarize(diamonds, mean_carat = mean(carat))

# carats on the x axis, price on y-axis on scatterplot
ggplot(data = diamonds, aes(x = carat, y = price)) +
  geom_point()

# add color to the cut of diamond
ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point()

# separate out the cuts into different graphs
ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  facet_wrap(~cut)

# check what packages we have
installed.packages()
library(class)

# vignettes are guides to an R package
browseVignettes("ggplot2")

# ggplot2 is for data visualizations in plots
# tidyr is for data cleaning
# readr is for importing data
# dplyr is for data manipulations like select/filter


