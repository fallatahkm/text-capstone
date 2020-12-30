#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
    titlePanel("Text Control"),
    sidebarLayout(
        sidebarPanel(
            br(),
            submitButton(text = "Go ..."),
            br()
        ),
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("General Information", br(),
                                 tableOutput("box1"),
                                 tableOutput("box11"),
                                 
                                 br(),
                                 plotOutput("distfram")),
                        
                        tabPanel("General Ploting", br(),
                                 numericInput("n1_id", "number of word repeated less than: "
                                              ,min = 5, max = NA, step = 5, value = 10),
                                 plotOutput("distPlot2")),
                        
                        tabPanel("Sentiments compersion Ploting", br(),
                                 numericInput("n2_id", "number of word repeated less than: "
                                              ,min = 5, max = NA, step = 5, value = 10),
                                 selectInput("sent_1","Select ducoment for analysis",
                                             list("anger", "anticipation","disgust","fear","joy",
                                                  "negative", "positive", "sadness", "surprise",
                                                  "trust"), selected = "positive"),
                                 selectInput("sent_2","Select ducoment for analysis",
                                             list("anger", "anticipation","disgust","fear","joy",
                                                  "negative", "positive", "sadness", "surprise",
                                                  "trust"), selected = " negative "),
                                 plotOutput("distPlot3")),
                        
                        tabPanel("Word Predication", br(), 
                                # textInput("enword", "Enter Author Name", value = "enter author name"),
                                 selectInput("doc4","Select ducoment for analysis",
                                              c("blogs", "news", "twitter"), selected = " "),
                                 textInput("wordinp","Enter word to euditting",value = "love"),
                                 textOutput("No_paragraph"),
                                 numericInput("paragraph_id", "Select Number of the paragraph you want check",
                                              min = 1, max = NA, value = 1 , step = 1),
                                 textOutput ("paragraph"),
                                 tableOutput("nextword"),
                                 
                                 numericInput("word_id", "Predict the next word",
                                              min = 1, max = 15, value = 2 , step = 1))
                        
                        
            )
        )
    )))
