data("Toothgrowth")
View(ToothGrowth)
install.packages("dplyr")

# filter data
filtered_tg <- filter(ToothGrowth, dose==0.5)
View(filtered_tg)

# arrange data
arrange(filtered_tg, len)

# nested function, filters first then arranges by length
arrange(filter(ToothGrowth, dose==0.5), len)

# pipe
filtered_toothgrowth <- ToothGrowth %>% 
  filter(dose==0.5) %>% 
  arrange(len)

# summarized by mean
filtered_toothgrowth <- ToothGrowth %>% 
  filter(dose==0.5) %>% 
  group_by(supp) %>% 
  summarize(mean_len = mean(len,na.rm = T),.group="drop")

