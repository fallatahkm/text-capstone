

library(shiny)

shinyUI(fluidPage(
    titlePanel("Text Mining"),
    sidebarLayout(
        sidebarPanel(
            br(),
            submitButton(text = "Go ..."),
            br()
        ),
        mainPanel( h1("Word Predication Program"), br(), 
                   
                   selectInput("doc4","Select ducoment for analysis",
                               c("blogs", "news", "twitter"), selected = " "),
                   textInput("wordinp","Enter word to euditting",value = "love"),
                   textOutput("No_paragraph"),
                   numericInput("paragraph_id", "Select Number of the paragraph you want check",
                                min = 1, max = NA, value = 1 , step = 1),
                   textOutput ("paragraph"),
                   tableOutput("nextword"),
                   
                   numericInput("word_id", "Predict the next word",
                                min = 1, max = 15, value = 1 , step = 1))
        
        
    )
)
)
#############