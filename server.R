
library(shiny)
library(stringr)
library(tidytext)
library(tidyr)
library(dplyr)
library(readr)
library(janeaustenr)
library(ggplot2)
library(qdapRegex)
############
data("stop_words")
nrc_data <-  get_sentiments("nrc")
##############################
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",temp)
con_blogs <- unz(temp, "final/en_US/en_US.blogs.txt")
blogs <- readLines(con_blogs,n = 100)
con_news <- unz(temp, "final/en_US/en_US.news.txt")
news <- readLines(con_news, n = 100)
con_twitter <- unz(temp, "final/en_US/en_US.twitter.txt")
twitter <- readLines(con_twitter, n = 100)
unlink(temp)
###########

shinyServer(function(input, output, session) { 

output$No_paragraph <- renderText({ 

    author        <-  assign(input$doc4, get(input$doc4)) #news#input$
    word_search   <- input$wordinp
    word_sum      <- sum(str_detect( author, word_search, negate = F))
    word_sum
})

output$paragraph <- renderText({
  author         <-  assign(input$doc4, get(input$doc4)) #input$enword
  word_search    <- input$wordinp
  Prg_No         <- input$paragraph_id
  paragraph_v    <- (word =  str_subset(author,
                    word_search, negate = F))[Prg_No]
  paragraph      <-  unlist(paragraph_v)
  
})    
output$nextword <- renderTable({
  author         <-  assign(input$doc4, get(input$doc4)) #input$enword
  word_search    <- input$wordinp
  Prg_No         <- input$paragraph_id
  paragraph_v    <- (word =  str_subset(author,
                    word_search, negate = F))[Prg_No]
  word_loc      <- str_locate(paragraph_v, word_search)[[1]]
  five_11       <- (word = substr((paragraph_v), word_loc, '1000'))
  five_1        <-  tibble(line = 1:length(paragraph_v), text = five_11)
  m             <- input$word_id
 word_sel <- unnest_tokens(five_1,word, text,token = "ngrams", n = m)[1,]
    word_sel
})

##################

data_blogs <- tibble(line = 1:length(blogs), text = blogs)%>%
  unnest_tokens(word, text,token = "ngrams", n = 1)%>%
  anti_join(stop_words, by = "word")%>%
  mutate( author = factor("blogs"))

data_news <-tibble(line = 1:length(news), text = news)%>%
  unnest_tokens(word, text,token = "ngrams", n = 1)%>%
  anti_join(stop_words, by = "word")%>%
  mutate( author = factor("news"))

data_twitter <-tibble(line = 1:length(twitter), text = twitter)%>%
  unnest_tokens(word, text,token = "ngrams", n = 1)%>%
  anti_join(stop_words, by = "word")%>%
  mutate( author = factor("twitter"))

MegData <- bind_rows(data_blogs,data_news,data_twitter)

Meg_plot <- head(MegData, 5)

  
  output$distPlot2 <- renderPlot({
  DMing <- MegData %>% 
    inner_join(nrc_data, by = "word") %>%
    filter(word != "NA")%>%
    count(word,sentiment, author, sort = T)%>%
    ungroup()
  
  plot_DMing <- DMing%>%
    filter(n > input$n1_id)%>%
    ggplot(aes(word,n, fill = sentiment))+ geom_col()+ xlab("words")+
    ylab("Number")+ coord_flip() + facet_wrap( ~ author) 
  plot_DMing
})
  
  output$distPlot3 <- renderPlot({
    DMing <- MegData %>% 
      inner_join(nrc_data, by = "word") %>%
      filter(word != "NA")%>%
      count(word,sentiment, author, sort = T)%>%
      ungroup()
  sent_data <-  DMing %>%
    group_by(sentiment)%>%
    filter(sentiment%in% c(input$sent_1,input$sent_2))%>%
    top_n(input$n2_id)%>%
    ungroup()%>%
    mutate(word = reorder(word,n))%>%
    ggplot(aes(word,n,fill = sentiment))+
    geom_col(show.legend = F)+
    facet_wrap(~sentiment,scales = "free_y")+
    labs(y = "sentiment", x= NULL)+ coord_flip()
  sent_data
}) 
 #############
 output$box1 <- renderTable({

    DMing <- MegData %>%
      inner_join(nrc_data, by = "word") %>%
      filter(word != "NA")%>%
      count(word,sentiment, author, sort = T)%>%
      ungroup()
    sent_count <- aggregate(n ~ author +sentiment ,DMing, length )%>%
      spread(author,n)
     tibble(sent_count)
  
  })
output$distfram <- renderPlot({
  DMing <- MegData %>%
    inner_join(nrc_data, by = "word") %>%
    filter(word != "NA")%>%
    count(word,sentiment, author, sort = T)%>%
    ungroup()
  sent_count <- aggregate(n ~ author +sentiment ,DMing, length )%>%
    spread(author,n)
  tibble(sent_count)
sent_table <- mutate(sent_count, total= blogs+news+twitter)
  ggplot(sent_table,aes(sentiment, total, fill = sentiment))+
    geom_col(show.legend = F)


})
})
  
  
