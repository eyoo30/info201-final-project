library(tidyverse)
library(ggplot2)

#read in happiness report 2018 and 2019
h_2019_df <- read.csv("https://raw.githubusercontent.com/cillanguyen/Exploratory_Analysis/main/2019.csv")
View(h_2019_df)

#Make a Scatterplot based on the score and GDP
#REFLECTION: What is the purpose of analyzing the relationship between the score and GDP?

scatter_2019 <- ggplot(h_2019_df, aes(x=GDP.per.capita, y=Score)) + 
  geom_point()
