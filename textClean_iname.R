getwd()
# reset wd;
setwd("~/JUNJIE/WebScraper_Research2020S")

rm(list = ls())
library(tm)
library(tidyverse)
library(textclean)
library(jiebaR)
library(tidytext)

text <- read.csv("./data/sh_corp.csv")

## We only select a sub sample;
## To reduce Computing time;
## text <- text %>% sample_n(2000)
text <- text[,c("shixin_id","iname")]

## duty col --> removing HTML; Emotion; Special Chrs
text$name <-  text$iname %>% replace_html() %>% replace_emoticon() %>% 
  replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|(|∞|﹏|．| ～|-。“”！!]","",.)

## Only select the texts with more than 20 wds
text <- subset(text, nchar(text$name) > 4 )

## 同时删除了数字;
x <- "a1~!@#$%^&*(){}_+:\"<>?,./;'[]-=" 
text$name <- str_replace_all(text$name, "[[:punct:]]", " ")



# --------- 可 output raw data HERE --------
##
## Perform TF-IDF; 
## With filtered words;
##



## 分词
library(jiebaR)
wk <-worker("mix") #建立模型分词
words <- segment(text$name, wk)

tab <- table(words)
tab <- sort(tab, decreasing = TRUE)

## 去掉单个字的词语
tab2 <- tab[stringr::str_length(names(tab)) > 1]



## 发现常用 停止词;
head(knitr::kable(as.data.frame((tab2))), 100)

t <- readLines('data/stopwords_name.txt')
stopwords <- c(NULL)

for (i in 1:length(t)){
  stopwords[i] <- t[i]
}

words_filtered <- filter_segment(
  words, 
  stopwords
)

freq <- sort(
  table(words_filtered), 
  decreasing = T
)

freq_head <- freq[stringr::str_length(names(freq)) > 1]
pie(head(freq_head,15),family='STXihei')

freq_head <- freq[stringr::str_length(names(freq)) > 2]
pie(head(freq_head,15),family='STXihei')



freq_tail <- freq[stringr::str_length(names(freq)) > 2]
pie(tail(freq_tail, 10), family="STXihei")



freq_wcloud <- freq[stringr::str_length(names(freq)) > 2]

mydata=data.frame(word=names(freq_wcloud),
                  freq=as.vector(freq_wcloud),
                  stringsAsFactors= F)
library(wordcloud2)

wordcloud2(
  mydata,
  size = 1.5
)







