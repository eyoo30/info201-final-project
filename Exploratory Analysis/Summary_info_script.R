# install packages
#install.packages("tidyverse")
library(tidyverse)

#read in happiness report 2018 and 2019
h_2019_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2019.csv")
View(h_2019_df)

h_2018_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2018.csv")
View(h_2018_df)

# Summary Information Script
# The first file you should save in your project should store summary information in a list.How many rows in each dataset
# find the min and max of "scores" in 2018 & 2019, find the mean happiness score worldwide in 2018 and 2019
# find correlation between Score and GDP.per.capita in 2018 and 2019.
summary_info <- list()
summary_info$row_2018 <- nrow(h_2018_df)
summary_info$row_2019 <- nrow(h_2019_df)
summary_info$col_2018 <- ncol(h_2018_df)
summary_info$col_2019 <- ncol(h_2019_df)
summary_info$mean_2019 <- mean(h_2019_df$Score) 
summary_info$mean_2018 <- mean(h_2018_df$Score) 
summary_info$min_2019 <- h_2019_df %>%
  filter(Score == min(Score))%>%
  select(Country.or.region)
summary_info$min_2018 <- h_2018_df %>%
  filter(Score == min(Score))%>%
  select(Country.or.region)
summary_info$max_2019 <- h_2019_df %>%
  filter(Score == max(Score))%>%
  select(Country.or.region)
summary_info$max_2018 <- h_2018_df %>%
  filter(Score == max(Score))%>%
  select(Country.or.region)
summary_info$correlation_s_gdp_2019 <- h_2019_df %>%
  summarise(cor = Score, GDP.per.capita)
summary_info$correlation_s_gdp_2018 <- h_2018_df %>%
  summarise(cor = Score, GDP.per.capita) 

print(summary_info)


# Aggregate Table Script
# round the datasets to the nearest hundredths place
# Please note, the last column of dataset 2018 is not rounded yet.


#use groupby to get the range of the scores in the both dataset 

#Make a Scatterplot based on the score and GDP
#REFLECTION: What is the purpose of analyzing the relationship between the score and GDP?

#Make a bar chart, with y = scores, x = each individual column for both dataset
# REFLECTION: Why is making a bar chart relevant in understanding the score of each column?

#Make a map based on the countries and region. Just one map, since the two dataset
#contains the exact same locations
#REFLECTION: why analyze the locations? 

