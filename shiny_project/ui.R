library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("ATP Match Statistics (Tennis)"),
  textOutput("intro"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        #create a tabbed panel for exploring or modeling data
        tabsetPanel(
            tabPanel("Explore",
                radioButtons("vars1", label = "Select a variable:", 
                             choices = c("Rank" = "rank", "% Aces" = "ace_perc", "% Double Faults" = "df_perc", 
                                         "% 1st Serves In" = "firstin_perc", 
                                         "% 1st Serve Points Won" = "firstwon_perc", 
                                         "% 2nd Serve Points Won" = "secondwon_perc", 
                                         "% Break Points Saved" = "bp_perc"))),
            tabPanel("Model",
                checkboxGroupInput("vars2",
                              "Variables to include in the model:",
                              c("Rank" = "rank", "% Aces" = "ace_perc", "% Double Faults" = "df_perc", 
                                "% 1st Serves In" = "firstin_perc", 
                                "% 1st Serve Points Won" = "firstwon_perc", 
                                "% 2nd Serve Points Won" = "secondwon_perc", 
                                "% Break Points Saved" = "bp_perc")),
                actionButton('go', 'Calibrate Model')))),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("varPlot"),
       textOutput("progress"),
       verbatimTextOutput("model")
    )
  )
))
