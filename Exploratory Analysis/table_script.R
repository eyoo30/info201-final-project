# Aggregate Table Script
# install packages

library(tidyverse)
library(knitr)

#read in happiness report 2018 and 2019

h_2019_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2019.csv")
View(h_2019_df)

h_2018_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2018.csv")
View(h_2018_df)

# round the datasets to the nearest hundredths place
# Please note, the last column of dataset 2018 is not rounded yet.

h_2019_df <- h_2019_df %>% mutate(across(3:9, round, 1))
View(h_2019_df)
h_2018_df <- h_2018_df %>% 
  filter(Perceptions.of.corruption != "N/A")%>% 
  mutate(across(where(is.numeric), round, 1))
View(h_2018_df)
#make a table on the score higher then 7.0 and a life expectancy higher then 1.00
# certain unsure on the group_by

score_table_2019 <- h_2019_df %>%
  group_by(Country.or.region) %>% 
  filter(Score >= 7.5) %>%
  filter(Healthy.life.expectancy >= 1.00) 

table_2019 <- kable(score_table_2019, col.names 
        = c("Rank", "Countries and Regions", 
            "Score", "GDP", "Life Expectancy", "Support", "Freedom", 
            "Generosity", "Corruption"), 
        caption = "Table 1. The result of a high score and high expectancy") 
