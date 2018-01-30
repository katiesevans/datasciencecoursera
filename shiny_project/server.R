library(shiny)
library(tidyverse)
library(randomForest)
library(e1071)
library(caret)
library(stats)

#load dataset
tennis <- read.csv("atp_matches_2017.csv") %>%
    dplyr::mutate(match_id = paste0(tourney_id, "_", match_num)) %>%
    dplyr::select(w_name = winner_name, w_age = winner_age, w_rank = winner_rank, l_name = loser_name, 
                  l_age = loser_age, l_rank = loser_rank, w_ace:l_bpFaced, match_id)

#data wrangling
winners <- tennis %>%
    dplyr::select(starts_with("w"), match_id) %>%
    dplyr::mutate(outcome = "Win")
colnames(winners) <- c("name", "age", "rank", "ace", "df", "svpt", "firstIn", "firstWon", "secondWon",
                       "SvGms", "bpSaved", "bpFaced", "match_id", "outcome")
losers <- tennis %>%
    dplyr::select(starts_with("l"), match_id) %>%
    dplyr::mutate(outcome = "Lose")
colnames(losers) <- c("name", "age", "rank", "ace", "df", "svpt", "firstIn", "firstWon", "secondWon",
                       "SvGms", "bpSaved", "bpFaced", "match_id", "outcome")
tennis <- rbind(winners, losers) %>%
    dplyr::arrange(match_id) %>%
    dplyr::mutate(bp_perc = bpSaved / bpFaced,
                  ace_perc = ace / svpt,
                  df_perc = df / svpt,
                  firstin_perc = firstIn / svpt,
                  firstwon_perc = firstWon / svpt,
                  secondwon_perc = secondWon / svpt) %>%
    na.omit()
tennis$outcome <- factor(tennis$outcome)

#make test and training dataset
set.seed(8517)
trainIndex <- createDataPartition(tennis$outcome, p = 0.8, list = FALSE)
tennisTrain <- tennis[trainIndex,]
tennisTest <- tennis[-trainIndex,]


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    #intro text
    output$intro <- renderText({
        "The ATP collects a lot of data from every mens professional tennis match throughout the year. \
        Below are 7 variables that could be used to predict the outcome of a match. In the EXPLORE \
        tab, you can choose one variable at a time to graph against the outcome of the match. \
        For example, graphing rank will look at the rank of the individuals that lost a match \
        versus the rank of the individuals that won a match to see if the higher ranked players \
        always win. In the MODEL tab you will find a list of these variables again, but this time \
        selecting as many as you want, the application will fit a model to predict the match outcome \
        based on the input variables and the predicted values will be printed below. Data was obtained \
        from Jeff Sackmann at https://github.com/JeffSackmann/tennis_atp. A description of common \
        tennis terminology can be found at http://www.onlinetennisinstruction.com/tennisterms.html."
    })
    
    #make ggplot for variable exploration outcome vs. user input
    output$varPlot <- renderPlot({
        v <- as.character(input$vars1)
        if(v == "rank") name <- "Player rank"
        if(v == "ace_perc") name <- "% Aces"
        if(v == "df_perc") name <- "% Double Faults"
        if(v == "firstin_perc") name <- "% First Serves In"
        if(v == "firstwon_perc") name <- "% First Serve Points Won"
        if(v == "secondwon_perc") name <- "% Second Serve Points Won"
        if(v == "bp_perc") name <- "% Break Points Saved"
        
        ggplot(data = tennisTrain, aes_string(x = 'outcome', y = input$vars1)) +
            geom_boxplot() +
            theme_bw() +
            labs(x = "Match Outcome", y = name) #change to name not id
        
        

    })
    
    #Get a new dataframe of values based on user input for model selection
    newdf <- eventReactive(input$go, {
        tennisTrain %>%
            dplyr::select(outcome, one_of(input$vars2))
    })
    
    p <- eventReactive(input$go, {
        paste("Model includes: ", paste(input$vars2, collapse = ", "))
    })

    output$progress <- renderText({
        p()
    })
    
    #run randomforest model and print confusion matrix for user input
    output$model <- renderPrint({
        fit <- randomForest(outcome ~ ., data = newdf())
        print(confusionMatrix(data = predict(fit, newdata = tennisTest), reference = tennisTest$outcome))
    })
})
