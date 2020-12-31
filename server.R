


library(shiny)
library(stringr)
library(tidyr)
library(dplyr)
library(tidytext)
library(readr)
############
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",temp)
con_blogs <- unz(temp, "final/en_US/en_US.blogs.txt")
blogs <- readLines(con_blogs,n = 1000)
con_news <- unz(temp, "final/en_US/en_US.news.txt")
news <- readLines(con_news, n = 1000)
con_twitter <- unz(temp, "final/en_US/en_US.twitter.txt")
twitter <- readLines(con_twitter, n = 1000)
unlink(temp)
###########

shinyServer(function(input, output, session) { 
  
  output$No_paragraph <- renderText({ 
    
    author        <-  assign(input$doc4, get(input$doc4)) 
    word_search   <- input$wordinp
    word_sum      <- sum(str_detect( author, word_search, negate = F))
    word_sum
  })
  
  output$paragraph <- renderText({
    author         <-  assign(input$doc4, get(input$doc4))
    word_search    <- input$wordinp
    Prg_No         <- input$paragraph_id
    paragraph_v    <- (word =  str_subset(author,
                      word_search, negate = F))[Prg_No]
    paragraph      <-  unlist(paragraph_v)
    
  })    
  output$nextword <- renderTable({
    author         <-  assign(input$doc4, get(input$doc4))
    word_search    <- input$wordinp
    Prg_No         <- input$paragraph_id
    paragraph_v    <- (word =  str_subset(author,
                      word_search, negate = F))[Prg_No]
    
    word_search_1 <- str_split(word_search," ")[[1]]#
    word_search_2 <-  tail(word_search_1, 1)
    
    word_loc      <- str_locate(paragraph_v, word_search_2)[[1]]
    five_11       <- (word = substr((paragraph_v), word_loc, '1000'))
    
    five_1        <-  tibble(line = 1:length(paragraph_v), text = five_11)
    m             <- input$word_id
    word_sel <- unnest_tokens(five_1,Predicted_Word, text,token = "ngrams", n = m)[1,]
    c(word_sel[,2])
  })
})
