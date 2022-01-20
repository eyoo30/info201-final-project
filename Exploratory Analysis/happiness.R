# install packages
install.packages("tidyverse")
library(tidyverse)
library(ggplot2)

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
h_2019_df <- h_2019_df %>% mutate(across(3:9, round, 1))
View(h_2019_df)
h_2018_df <- h_2018_df %>% 
  filter(Perceptions.of.corruption != "N/A")%>% 
  mutate(across(where(is.numeric), round, 1))
View(h_2018_df)

#use groupby to get the range of the scores in both datasets

score_2019 <- h_2019_df %>%
  group_by(Overall.rank, Country.or.region) %>%
  summarize(total_2019 = sum(Score))
score_2018 <- h_2018_df %>%
  group_by(Overall.rank, Country.or.region) %>%
  summarize(total_2018 = sum(Score))
totals_year <- left_join(x = score_2018, y = score_2019, by= "Overall.rank") 
#Make a Scatterplot based on the score and GDP
#REFLECTION: What is the purpose of analyzing the relationship between the score and GDP?

scatter_2018 <- ggplot(h_2018_df, aes(x=GDP.per.capita, y=Score)) + geom_point()

scatter_2019 <- ggplot(h_2019_df, aes(x=GDP.per.capita, y=Score)) + geom_point()

#Make a bar chart, with y = scores, x = each individual column for both dataset
# REFLECTION: Why is making a bar chart relevant in understanding the score of each column?

bar_2018 <- ggplot(h_2018_df, aes(y=Score)) + geom_bar()

bar_2019 <- ggplot(h_2019_df, aes(y=Score)) + geom_bar()

#Make a map based on the countries and region. Just one map, since the two dataset
#contains the exact same locations
#REFLECTION: why analyze the locations? 

#location_region_2018 <- h_2018_df$Country.or.region

#world_map <- map_data("world", region = location_region_2018, exact = FALSE)
  
#happiness_map <- ggplot(world_map) + 
  #geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = location_region_2018), color = "grey")
