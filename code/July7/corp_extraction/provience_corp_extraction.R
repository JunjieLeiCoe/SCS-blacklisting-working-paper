rm(list = ls() ) 

# install.packages('RMySQL')
library(RMySQL)
library(DBI)

myDB <-  dbConnect(
  MySQL(), 
  user = 'root',
  host = 'localhost', 
  password = 'lei19961001',
  port = 3306, 
  dbname = 'shiXinDB'
)

dbListTables(myDB)
dbListFields(myDB, 'sx')

# Set the encoding for Rstudio
rs <- dbSendQuery(myDB, 'SET NAMES utf8') 

data <- dbGetQuery(myDB, 'select iname, duty from sx
		   where area = "广东" and sexy = 0')

## duty col --> removing HTML; Emotion; Special Chrs
data$duty <-  data$duty %>% replace_html() %>% replace_emoticon() %>% 
  replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|(|∞|﹏|．| ～|-。“”！!]","",.)

## Only select the texts with more than 20 wds
data <- subset(data, nchar(data$duty) > 20 )

## 同时删除了数字;
x <- "a1~!@#$%^&*(){}_+:\"<>?,./;'[]-=" 
data$duty <- str_replace_all(data$duty, "[[:punct:]]", " ")

getwd()
setwd("/Users/leijunjie/JUNJIE/WebScraper_Research2020S/data/provience_corp_duty")
write.csv(
  data,
  "guangdong.csv"
)
