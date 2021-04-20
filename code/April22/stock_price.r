rm(list = ls())

library(tidyverse)
library(tidyquant)
library(timetk)
library(tibbletime)

symbols <-  c(
    "000001.SS",
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

prices <- getSymbols(symbols, 
                     src = 'yahoo', 
                     from = "2012-12-31",
                     to = "2020-04-16",
                     auto.assign = TRUE, 
                     warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`(symbols)

prices_weekly <- to.weekly(prices, indexAt = "last", OHLC = FALSE)


asset_returns_dplyr_byhand <- prices %>% 
  to.monthly(indexAt = "last", OHLC = FALSE) %>% 
  tk_tbl(preserve_index = TRUE, rename_index = "date") %>%
  gather(asset, returns, -date) %>% 
  group_by(asset) %>%  
  mutate(returns = (log(returns) - log(lag(returns)))) %>%
  spread(asset, returns) %>% 
  select(date, symbols)


colnames(asset_returns_dplyr_byhand) <- c(
  "date",
  "Ind.Stock",
  "Comp1",
  "Comp2",
  "Comp3",
  "Comp4",
  "Comp5",
  "Comp6",
  "Comp7",
  "Comp8",
  "Comp9",
  "Comp10"
)



asset_returns_long_format <- 
  asset_returns_dplyr_byhand %>% 
  gather(asset, returns, -date)


plot <- asset_returns_long_format

ggplot(data = plot, 
       aes(x = plot$date, y = plot$returns, color = asset)) + geom_line() + 
  geom_point() + 
  scale_x_date(date_labels="%b %y",date_breaks  ="3 month") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position='none', 
        axis.title.x = element_blank()) + 
  geom_vline(xintercept = as.Date("2019-1-1", "%Y-%m-%d"), color = "red") + 
  facet_grid(vars(asset),  scales = "free") + labs(y = "Return(log)")
  

