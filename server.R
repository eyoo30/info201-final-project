library(shiny)
library(countrycode)

# rearrage for wolrdmap dataset---------
data2018 <- read.csv("2018.csv")
data2019 <- read.csv("2019.csv")
# add column year to each dataframe
data2018$year = 2019
data2019$year = 2018
data2018$Perceptions.of.corruption = as.numeric(data2018$Perceptions.of.corruption)
happiness = bind_rows(data2019,data2018)
# create country code columns
happiness$code = countrycode(happiness$Country.or.region, origin='country.name',
                             destination='iso3c', custom_match = c(Kosovo = "KSV"))
# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)
# specify map projection/options
g <- list(showframe = FALSE,showcoastlines = FALSE,
          projection = list(type = 'Mercator'))
#--------------------------------------------
# For use in "yearly growth" section 
# take out top 6 from each df 
rank2018 <- data2018 %>%
  select(rank_18 = Overall.rank, Country.or.region, score_18 = Score, year) %>%
  filter(rank_18 <= 6)

rank2019 <- data2019 %>%
  select(rank_19 = Overall.rank, Country.or.region, score_19 = Score, year) %>%
  filter(rank_19 <= 6)
#combine rank
rank_happiness = bind_rows(rank2018,rank2019)
#------------------------------------------

server <- function(input, output) {
  output$intro_overview <- renderText({
    print("The World Happiness Report is a landmark survey intended to evaluate the state of global happiness across different countries. The happiness scores and rankings 
    for each country are determined by data from the Gallup World Poll: a survey that asks respondents to rate their own current lives on a scale from 0 to 10 (0 being the
    worst possible life and 10 being the best). The happiness scores are mainly determined by six factors: GDP per capita, social support, healthy life expectancy, 
    freedom, generosity, and perceptions of corruption. It is important to understand these various factors to get some insight on what influences people's happiness levels.")
  })
  
  output$intro_map <- renderText({
    print("What is the difference between happiness scores across different countires between 2018 and 2019?")
  })
  
  output$intro_yearly <- renderText({
    print("How stable is the happiness score between 2018 and 2019 for the top ranking countries?")
  })
  
  output$intro_analysis <- renderText({
    print("How does each of the six variables (GDP per capita, social support, healthy life expectancy, 
    freedom, generosity, and perceptions of corruption) affect happiness rankings across countries?")
  })
  
  # Create reactive data frame to use for world map and data table
  react_data <- reactive({
    map_happiness = happiness %>%
      #select(c('Overall.rank', 'year','Score','Country.or.region','code','GDP.per.capita',input$happiness_features)) %>%
      filter(year == input$worldmap_year)
  })
  # Create output plot of world map
  output$world_map <- renderPlotly({
    react_data() %>%
      plot_geo() %>%
      add_trace(z = ~Score, 
                color = ~Score,
                colors = 'Oranges', 
                text = ~Country.or.region, 
                locations = ~code, 
                marker = list(line = l)) %>%
      colorbar(title = 'Score') %>%
      layout(title = '' ,geo = g)
  })
  
  output$WorldMapIntro <- renderText({
    print("The map allows the user to easily visualize where each country is and gain general
    information regarding the name of the country. It shows that Americas, Europe, Australia and New Zealand 
          have higher happiness score than Africa and Asia for the year 2018 and 2019.")
  })
  
  # Create reactive data frame to use for scatterplot
  
  output$rank_scatterplot <- renderPlotly({
    rank_happiness <- rank_happiness %>%
      filter(year == input$scatterplot_year) 
    
    if(input$scatterplot_year == 2018){
      plot_ly(rank_happiness,  x=~Country.or.region, y= ~score_19, type = "scatter") 
      #  add_trace(y = ~score_18, name = '2018 Score', mode = 'lines')
    }
    else if(input$scatterplot_year == 2019){
      plot_ly(rank_happiness, x= ~Country.or.region, y= ~score_18, type = "scatter") 
    #  add_trace(y = ~score_19, name = '2019 Score', mode = 'lines')
    }
    #   add_trace(y = ~score18, name = '2018 Score', mode = 'lines')
    
  }) 
  output$sum_yearly <- renderText({
    print("This scatterplot gives the users the chance to see whether the happiness score is stable in different years. For this section specifically, we choose the top-ranking countries to see the result. Among the top six countries (Denmark, Finland, Iceland, Netherlands, Norway, and Switzerland), Finland has the most stable scores between 2018 and 2019 at around 7.6-7.8."
          ) 
  })
  
  #-------------------------
  # histogram 
  high_countries <- data2019 %>%
    filter(Score >= 7) %>%
    select(Country.or.region, GDP.per.capita, Social.support, Healthy.life.expectancy, 
           Freedom.to.make.life.choices, Generosity, Perceptions.of.corruption)
  
  output$s_button <- renderUI({
    selectInput("s_button", label = "Selected a Variable",
                choices = colnames(high_countries[, c("GDP.per.capita", "Social.support","Healthy.life.expectancy",
                                                "Freedom.to.make.life.choices", "Generosity", "Perceptions.of.corruption")])
                )   
  })
  histo_data <- reactive ({ 
    if ("GDP.per.capita" %in% input$s_button)  
      return(high_countries$GDP.per.capita)
    if ("Social.support" %in% input$s_button) 
      return(high_countries$Social.support) 
    if ("Healthy.life.expectancy" %in% input$s_button) 
      return(high_countries$Healthy.life.expectancy)
    if ("Freedom.to.make.life.choices" %in% input$s_button) 
      return(high_countries$Freedom.to.make.life.choices)
    if ("Generosity" %in% input$s_button) 
      return(high_countries$Generosity) 
    if ("Perceptions.of.corruption" %in% input$s_button) 
      return(high_countries$Perceptions.of.corruption)
  })
  output$analysis_plot <- renderPlot({ 
    ggplot(high_countries, aes(Country.or.region, histo_data(), fill = Country.or.region)) +
      geom_bar(stat="identity") + coord_flip() + 
      xlab("Country/regions") + ylab(input$s_button)
  }) 
  output$ana_reason <- renderText({
    print("The purpose of this histogram is to give an overall analysis of the variables relationship with the countries.
          Each variable that is selected will change the length of the country, because the length is based on how much that 
          country or region, takes up from that variable.")
  })
  output$ana_about <- renderText({
    print("The histogram, focus on the most recent year of 2019 World Happiness dataset. The sidebar have the interactive
          which allow user to select the variable that they want to see compared to the Country/regions, each variable that is in
          the drop down bar is a specific variable that determine rather the Country/region is the happiest. The horizontal graph,
          is a unique way for the user, to see the graph more clearly and easier, then a vertical chart. Note: not all of the 
          Country/regions are showen, because there is ~156 of them, and it would be too overwhelming to look at. So its filter
          based on the score that are greater or equal to 7. The score determine the rank of the happiness Country/region.
          ")
  })
  
  output$map_answer <- renderText({
    print("Through our map visualization, we found that the majority of North and South America, Europe, Australia, and New Zealand 
          have higher happiness scores than Africa and Asia for both 2018 and 2019. Based on our findings, we concluded that the happier
          countries around the world are generally in the more modernly developed regions worldwide.")
  })
  
  output$yearly_answer <- renderText({
    print("Through our scatterplot analysis, we found that among the top 6 ranking countries (Denmark, Finland, Iceland, Netherlands,
          Norway, and Switzerland), Finland had the most stable happiness scores between 2018 and 2019. Additionally, this visualization shows that 
          the top ranking country's happiness scores stay consistent between different years. Because of this, we can conclude that the people who live 
          in theses top ranking countries have consistently better livelihoods than other countries around the world.")
  })
  
  output$analysis_answer <- renderText({
    print("Through our histogram, We found that each of the six variables effect each country's rankings equally depending on how highly valued a 
          certain variable is for a speficic country. However, this can vary between countries because a country's rank may be dependant on one or 
          more variables, therefore, there is no country that ranks high in all six variables. Overall, the effect of the variable on the country 
          allows us and the user to explore and analyze how much impact each variable has on each country.")
  })
  
  top_bottom_2018 <- data2018 %>% 
    filter(Overall.rank <= 5 | Overall.rank >= 152)
  output$table_2018 <- renderTable({
    top_bottom_2018
  })
  
  top_bottom_2019 <- data2019 %>% 
    filter(Overall.rank <= 5 | Overall.rank >= 152)
  output$table_2019 <- renderTable({
    top_bottom_2019
  })
}