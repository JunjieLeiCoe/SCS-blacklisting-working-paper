##################################################################
##                           NLP CORP                           ##
##################################################################
rm(list = ls())
library(tm)
library(tidyverse)
library(textclean)
library(jiebaR)
library(tidytext)

text <- read.csv("./data/sh_corp.csv")
text <- text[,c("shixin_id","duty")]

## removing HTML; Emotion; Special Chrs;
text$duty <-  text$duty %>% replace_html() %>% replace_emoticon() %>% 
  replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|()|∞|﹏|．| ～|-。“”！! ( )] , .;","",.)

## remove the words that only contains <= 20 words
text <- subset(text, nchar(text$duty) > 20 )

wk <-worker(stop_word = "./data/stopwords.txt")
corpus <- text %>% mutate(words = map(duty,segment,jieba = wk)) %>% select(c("shixin_id","words"))


vocab <- names(term.table)    

table_tf <- corpus %>% unnest(col = words) %>% count(shixin_id,words)
head(table_tf)
tfidf_table <- table_tf %>% bind_tf_idf(term = words,document = shixin_id,n = n)


top3 <- tfidf_table %>% group_by(shixin_id) %>% top_n(3,tf_idf) %>% ungroup();top3

out_df <- head(top3[order(-top3$n), ], 200)
write.csv(out_df, "corp_tfidf.csv")



##################################################################
##                           NLP MALE                           ##
##################################################################
rm(list = ls())
library(tm)
library(tidyverse)
library(textclean)
library(jiebaR)
library(tidytext)

text <- read.csv("./data/sh_m.csv")
text <- text[,c("shixin_id","duty")]

## removing HTML; Emotion; Special Chrs;
text$duty <-  text$duty %>% replace_html() %>% replace_emoticon() %>% 
  replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|(|∞|﹏|．| ～|-。“”！!]","",.)

## remove the words that only contains <= 20 words
text <- subset(text, nchar(text$duty) > 20 )

wk <-worker(stop_word = "./code/wMeeingApril_1/stopwords.txt")
corpus <- text %>% mutate(words = map(duty,segment,jieba = wk)) %>% select(c("shixin_id","words"))


table_tf <- corpus %>% unnest(col = words) %>% count(shixin_id,words)
head(table_tf)
tfidf_table <- table_tf %>% bind_tf_idf(term = words,document = shixin_id,n = n)


top3 <- tfidf_table %>% group_by(shixin_id) %>% top_n(3,tf_idf) %>% ungroup();top3

out_df <- head(top3[order(-top3$n), ], 200)
write.csv(out_df, "sh_male_tfidf.csv")




##################################################################
##                           NLP FEMALE                         ##
##################################################################
rm(list = ls())
library(tm)
library(tidyverse)
library(textclean)
library(jiebaR)
library(tidytext)

text <- read.csv("./data/sh_f.csv")
text <- text[,c("shixin_id","duty")]

## removing HTML; Emotion; Special Chrs;
text$duty <-  text$duty %>% replace_html() %>% replace_emoticon() %>% 
  replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|(|∞|﹏|．| ～|-。“”！!]","",.)

## remove the words that only contains <= 20 words
text <- subset(text, nchar(text$duty) > 20 )

wk <-worker(stop_word = "./code/wMeeingApril_1/stopwords.txt")
corpus <- text %>% mutate(words = map(duty,segment,jieba = wk)) %>% select(c("shixin_id","words"))

table_tf <- corpus %>% unnest(col = words) %>% count(shixin_id,words)
head(table_tf)
tfidf_table <- table_tf %>% bind_tf_idf(term = words,document = shixin_id,n = n)

top3 <- tfidf_table %>% group_by(shixin_id) %>% top_n(3,tf_idf) %>% ungroup();top3

out_df <- head(top3[order(-top3$n), ], 200)
write.csv(out_df, "sh_female_tfidf.csv")


## /** https://docs.google.com/spreadsheets/d/1XW2SxNyHb0vwdd_CkeLUWo5auyg6DQOFxiafOjnAuVs/edit?usp=sharing