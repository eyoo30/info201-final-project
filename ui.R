library(shiny)
library(tidyverse)
library(dplyr)
library(maps)
library(ggplot2)
library(shinythemes)
library(plotly)

ui <- fluidPage(navbarPage("World Happiness", collapsible = TRUE, 
      tabPanel("Introduction",
               titlePanel(strong("What is the World Happiness Report?")),
               textOutput("intro_overview"),
               img(src = "world-happiness.jpg", alt = "World Happiness Picture"),
               tags$style(
                 "img {
                    display: block; 
                    margin-left: auto; 
                    margin-right: auto;
                 }"
               ),
               h2(strong("Research Questions:")),
               h4("World Map"),
               textOutput("intro_map"),
               h4("Yearly Growth"),
               textOutput("intro_yearly"),
               h4("Analysis"),
               textOutput("intro_analysis"),
               h2(strong("Group Members:")),
               p("Eliott Yoo, Mengying Jiang, Priscilla Nguyen, Xujin Yan"),
               hr(),
               tags$footer("The dataset for this analysis was retrieved from Kaggle and was published by Sustainable Development Solution Network."),
               tags$a(href="https://www.kaggle.com/unsdsn/world-happiness?select=2019.csv", "Link to the dataset.")),
    
      
      # code for World map showing happiness score     
      tabPanel("World map",
               sidebarLayout(
                 sidebarPanel(
                   uiOutput("year_plotly"),
                   h4("Description"),
                   textOutput("WorldMapIntro"),
                   br(),
                   sliderInput(
                     inputId="worldmap_year",
                     label="Select Year:",
                     min=2018, max=2019,
                     value=2018,
                     sep=""),
                 ),
                 mainPanel(
                   titlePanel(strong("World map showing happiness score by country")),
                   plotlyOutput("world_map", height = 400), width = 8)
               )),
      
      #code for rank to show 
      tabPanel("Yearly Growth",
               sidebarLayout(
                 sidebarPanel(
                   ## Widget that allow users to select category
                   radioButtons("scatterplot_year", label = h3("scores in different years"),
                                choices = list("2018" = 2019, "2019" = 2018), 
                                selected = 2019)
                 ),
                 mainPanel(
                   titlePanel(strong("Happniess Score Differences of the Top 6 Countries")),
                   plotlyOutput("rank_scatterplot"),
                   h3("Description"),
                   textOutput("sum_yearly")
                 )
               )
      ),
      tabPanel("Analysis", 
               sidebarLayout(
                 sidebarPanel(
                   uiOutput("s_button"), #action buttons: choose column
                 ),
                 mainPanel(
                   titlePanel(strong("Overview of countries happiness based on impacts")),
                   plotOutput("analysis_plot"), #histogram goes here
                   h3("Why make this?"),
                   textOutput("ana_reason"), #text of reason goes here
                   h3("What is this about?"), 
                   textOutput("ana_about") #text of the about goes here
                 )
               )),
      tabPanel("Conclusion",
                sidebarLayout(
                  sidebarPanel(
                    titlePanel(strong("Major Takeways and Findings")),
                    h3("World Map"),
                    p(strong("What is the difference between happiness scores across different countires between 2018 and 2019?"),
                    textOutput("map_answer")),
                    h3("Yearly Growth"),
                    p(strong("How stable is the happiness score between 2018 and 2019 for the top ranking countries?"),
                    textOutput("yearly_answer")),
                    h3("Analysis"),
                    p(strong("How does each variable affect happiness rankings across countries?")),
                    textOutput("analysis_answer")
                  ),
                  mainPanel(
                    titlePanel("Top 5 and Bottom 5 Ranked Countries"),
                    p(strong("These tables show the difference in rankings and different variables between 2018 and 2019.")),
                    tableOutput("table_2018"),
                    tableOutput("table_2019")
                  )
                ),
               ),
      selected = "Introduction",
      fluid = TRUE
  )
)


