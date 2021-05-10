getwd()
# reset wd;
setwd("~/JUNJIE/WebScraper_Research2020S")

rm(list = ls())
library(tm)
library(tidyverse)
library(textclean)
library(jiebaR)
library(tidytext)

text <- read.csv("./sx_sh_sample.csv")

##  str_extract_all(c("中过任命政府"),
# "([[:alpha:]][[:alpha:]])")
## We only select a sub sample;
## To reduce Computing time;

text <- text[,c("shixin_id","duty", "sexy")]


## duty col --> removing HTML; Emotion; Special Chrs
text$duty <-  text$duty %>% replace_html() %>% replace_emoticon() %>% 
  replace_tag() %>% gsub("[a-zA-Z0-9\\.^_ㄟ|(|∞|﹏|．| ～|-。“”！!]","",.)

## Only select the texts with more than 20 wds
text <- subset(text, nchar(text$duty) > 20 )

## 同时删除了数字;
x <- "a1~!@#$%^&*(){}_+:\"<>?,./;'[]-=" 
text$duty <- str_replace_all(text$duty, "[[:punct:]]", " ")

text <- text[text$sexy < 3, ]
text$gender[text$sexy == 1] <- "MALE"
text$gender[text$sexy == 2] <- "FEMALE"
text$gender[text$sexy == 0] <- "COMPANY"


df_n_DbD <- filter(text, gender != "COMPANY")

df_n_DbD <- mutate(
  text, 
  title = ifelse(gender == "MALE", "FEMALE", gender)
)

frequency <- df_n_DbD %>% 
  mutate(word = str_extract_all(duty, "([[:alpha:]][[:alpha:]])")) %>%
  count(gender, word) %>%
  group_by(gender) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(gender, proportion) %>% 
  gather(gender, proportion, `COMPANY`:`FEMALE`)


library(scales)
ggplot(frequency, aes(x = proportion, y = MALE, 
                           color = abs(MALE  - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~gender, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "PUBG", x = NULL) 




