library(tidyverse)
library(ggplot2)

#read in happiness report 2018 and 2019
h_2019_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2019.csv")
View(h_2019_df)

#Make a bar chart, with y = scores, x = each individual column for both dataset
# REFLECTION: Why is making a bar chart relevant in understanding the score of each column?

top_bottom_2019 <- h_2019_df %>% 
  filter(Overall.rank <= 3 | Overall.rank >= 154)
bar_2019 <- ggplot(top_bottom_2019, aes(x=Country.or.region, y=Score)) + 
  geom_bar(stat="identity", width=0.5) 
