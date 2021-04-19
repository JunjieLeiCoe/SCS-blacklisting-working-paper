rm(list=ls())
library(ggplot2)
library(stargazer)
library(quantmod)



start <- as.Date("2010-01-01")
end <- as.Date("2020-10-01")

trade_code <- c(
  "600606.SS", # * Green Land Coporation Ltd
  "002499.SZ", # * Kelin Environmental Protection Equipment, Inc
  "000571.SZ", # * Sundiro Holding Co., Ltd.
  "002259.SZ", # * Sichuan Shengda Forestry Industry Co., Ltd
  "600666.SS", # * Aurora Optoelectronics Co.,Ltd
  "002356.SZ", # * Shenzhen Hemei Group Co.,LTD
  "600289.SS", # * Bright Oceans Inter-Telecom Corporation
  "002418.SZ", # * Zhe Jiang Kangsheng Co.,Ltd.
  "002766.SZ", # * Shenzhen Soling Industrial Co.,Ltd
  "000677.SZ"  # * CHTC Helon Co., Ltd
)


data <- getSymbols(
  trade_code,
  src = "yahoo", from = start, to = end, na.omit = TRUE)

symbolData <- lapply(trade_code,function(x){
  y <- as.data.frame(get(x))
  colnames(y) <- c("open","high","low","close","volume","adjusted")
  y$date <- rownames(y)
  y$symbol <- x
  y
})


combinedData <- do.call(rbind,symbolData)
rownames(combinedData) <- 1:nrow(combinedData)

 

ggplot(data=combinedData, aes(x=as.Date(date), y=close, color = symbol)) +
  geom_line() + 
  labs(x = "", y = "Daily Close Price (RMB)", 
       title = "Stock performance of 10 blacklisted companies", 
       subtitle = "", 
       caption = "Source: yahoo finance") +  
  scale_x_date(date_labels="%b %y",date_breaks  ="5 month") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position='none')+ 
  annotate(geom = "rect", xmin = as.Date("2019-3-1", "%Y-%m-%d"), 
           xmax = as.Date("2019-12-31", "%Y-%m-%d"),
           ymin = 0, 
           ymax = 50,
           ,fill = "red", alpha = 0.5) + 
  annotate("text", x = as.Date("2019-8-15", "%Y-%m-%d"), y = 40, label = "Blacklisted")
  


