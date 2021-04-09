
#################################################################
##                       Updating TF-IDF                       ##
#################################################################

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
    replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|(|∞|﹏|．| ～|-。“”！!]","",.)


text <- subset(text, nchar(text$duty) > 20 )

wk <-worker(stop_word = "./code/wMeeingApril_1/stopwords.txt")
corpus <- text %>% mutate(words = map(duty,segment,jieba = wk)) %>% select(c("shixin_id","words"))