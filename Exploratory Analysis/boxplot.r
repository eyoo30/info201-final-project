library(tidyverse)
library(ggplot2)

#read in happiness report 2018 and 2019
h_2019_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2019.csv")
View(h_2019_df)

#Make a box plot for the healthy life expectancy of all the countries in the dataset.
#REFLECTION: why analyze the healthy life expectancy? 

boxplot_2019 <- boxplot(h_2019_df$Healthy.life.expectancy, main="Healthy Life Expectancy Plot", ylab="Life Expectancy")