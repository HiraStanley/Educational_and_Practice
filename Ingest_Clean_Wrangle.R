# installing and loading packages and reading example csv files
library(tidyverse)
data(diamonds)
View(diamonds)
as_tibble(diamonds)
data()
data(mtcars)
readr_example()
read_csv(readr_example("mtcars.csv"))
library(readxl)
readxl_example()
read_excel(readxl_example("type-me.xlsx"))
read_excel(readxl_example("type-me.xlsx"), sheet = "numeric_coercion")
install.packages("here")
library("here")
install.packages("skimr")
library("skimr")
install.packages("janitor")
library("janitor")
install.packages("dplyr")
library("dplyr")
install.packages("palmerpenguins")
library("palmerpenguins")

# HOTEL BOOKINGS 

# import from a csv and save as a dataframe called bookings_df
bookings_df <- read_csv("hotel_bookings.csv")

# preview data
head(bookings_df)
str(bookings_df)
glimpse(bookings_df)
colnames(bookings_df)
skim_without_charts(bookings_df)

# dataframe with only three columns you want
trimmed_df <- bookings_df %>% 
  select( 'hotel', 'is_canceled', 'lead_time')

View(trimmed_df)
head(trimmed_df)

# rename hotel to hotel_type
trimmed_df %>% 
  select(hotel, is_canceled, lead_time) %>% 
  rename(hotel_type = hotel)

# combine arrival month and year into one column
example_df <- bookings_df %>%
  select(arrival_date_year, arrival_date_month) %>% 
  unite(arrival_month_year, c("arrival_date_month", "arrival_date_year"), sep = " ")

head(example_df)

# calculate total number of canceled bookings and avg lead time
example_df <- bookings_df %>%
  summarize(number_canceled = sum(is_canceled),
            average_lead_time = mean(lead_time))

head(example_df)

# PALMER PENGUINS

# review all columns besides species
penguins %>% 
  select(-species)

# rename a column
penguins %>% 
  rename(island_new=island)

# column names to uppercase
rename_with(penguins,toupper)

# only characters, numbers, or underscores in column names
clean_names(penguins)

# operators
x <- c(3, 5, 7)
y <- c(2, 4, 6)

# single & runs on each element separately, returns three results
x < 5 & y < 5

# double && runs on entire vector, returns one result
x < 5 && y < 5

# sort by bill length ASC
penguins %>% arrange(bill_length_mm)

# sort by bill length DECSC
penguins %>% arrange(-bill_length_mm)

# save it as a dataframe
penguins2 <- penguins %>% arrange(-bill_length_mm)

View(penguins2)

# group by statement to get mean
penguins %>% group_by(island) %>%  drop_na() %>%  summarize(mean_bill_length_mm = mean(bill_length_mm))

# group by statement to get max
penguins %>% group_by(island) %>%  drop_na() %>%  summarize(max_bill_length_mm = max(bill_length_mm))

# group by species and island
penguins %>% group_by(species, island) %>% drop_na() %>%  summarize(mean_bl = mean(bill_length_mm), max_bl = max(bill_length_mm))

# filtering data, double equal means exactly equal to
penguins %>% filter(species == "Adelie")

# MANUALLY CREATE A DATAFRAME AND TRANSFORM DATA (SEPARATE, UNITE, MUTATE)

id <- c(1:10)

name <- c("John Mendes", "Rob Stewart", "Rachel Abrahamson", "Christy Hickman", "Johnson Harper", "Candace Miller", "Carlson Landy", "Pansy Jordan", "Darius Berry", "Claudia Garcia")

job_title <- c("Professional", "Programmer", "Management", "Clerical", "Developer", "Programmer", "Management", "Clerical", "Developer", "Programmer")

employee <- data.frame(id, name, job_title)

print(employee)

# separate full name into first and last columns at the blank space
separate(employee, name, into=c('first_name', 'last_name'), sep=' ')

# unite to merge

first_name <- c("John", "Rob", "Rachel", "Christy", "Johnson", "Candace", "Carlson", "Pansy", "Darius", "Claudia")

last_name <- c("Mendes", "Stewart", "Abrahamson", "Hickman", "Harper", "Miller", "Landy", "Jordan", "Berry", "Garcia")

job_title <- c("Professional", "Programmer", "Management", "Clerical", "Developer", "Programmer", "Management", "Clerical", "Developer", "Programmer")

employee2 <- data.frame(id, first_name, last_name, job_title)

print(employee2)

unite(employee2, 'name', first_name, last_name, sep=' ')

# create new variables with mutate, calculate kg from g and m from mm
View(penguins)

penguins %>% 
  mutate(body_mass_kg=body_mass_g/1000, flipper_length_m=flipper_length_mm/1000)

# correlation between x and y
install.packages('Tmisc')
library(Tmisc)
data(quartet)
View(quartet)

quartet %>% 
  group_by(set) %>% 
  summarize(mean(x), sd(x), mean(y), sd(y), cor(x,y))

# visualize some shapes
install.packages('datasauRus')
library('datasauRus')
ggplot(datasaurus_dozen,aes(x=x,y=y,colour=dataset))+geom_point()+theme_void()+theme(legend.position = "none")+facet_wrap(~dataset,ncol=3)

# bias function, unbiased model should be close to zero
install.packages("SimDesign")
library(SimDesign)

actual_temp <- c(68.3, 70, 72.4, 71, 67, 70)
predicted_temp <- c(67.9, 69, 71.5, 70, 67, 69)
bias(actual_temp, predicted_temp)

actual_sales <- c(150, 203, 137, 247, 116, 287)
predicted_sales <- c(200, 300, 150, 250, 150, 300)
bias(actual_sales, predicted_sales)
