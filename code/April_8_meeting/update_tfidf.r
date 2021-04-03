
#################################################################
##                       Updating TF-IDF                       ##
#################################################################
getwd()
# ! windows working directory;
setwd("C:/Users/Admin/Downloads/WebScraper_Research2020S")

rm(list = ls())
library(readr)
library(tm)
library(tidyverse)
library(textclean)
library(jiebaR)
library(tidytext)

text <- read.csv("./data/sample_shanghai/sh_corp.csv", encoding = 'UTF-8')
text <- text[, c("shixin_id", "duty")]

## removing HTML; Emotion; Special Chrs;
text$duty <- text$duty %>%
    replace_html() %>%
    replace_emoticon() %>%
    replace_tag() %>%
    gsub("[a-zA-Z0-9\\.^_<U+311F>|(|8|<U+FE4F>|.| ~|-<U+3002>“”!!]", "", .)

## remove the words that only contains <= 20 words
text <- subset(text, nchar(text$duty) > 20)

wk <- worker(stop_word = "./code/wMeeingApril_1/stopwords.txt")
corpus <- text %>%
    mutate(words = map(duty, segment, jieba = wk)) %>%
    select(c("shixin_id", "words"))


table_tf <- corpus %>%
    unnest(col = words) %>%
    count(shixin_id, words)
head(table_tf)
tfidf_table <- table_tf %>% bind_tf_idf(term = words, document = shixin_id, n = n)


top3 <- tfidf_table %>%
    group_by(shixin_id) %>%
    top_n(3, tf_idf) %>%
    ungroup()
top3

out_df <- head(top3[order(-top3$n), ], 200)
write.csv(out_df, "corp_tfidf.csv")