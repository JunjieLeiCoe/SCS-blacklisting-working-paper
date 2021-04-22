library(reshape2)
library(data.table)
library(ggplot2)

rm(list = ls())
setwd("~/JUNJIE/WebScraper_Research2020S")

gdp_province <- read.csv("data/20yrs_GDPbyProvince.csv")
count_province <- read.csv("data/by_province_count.csv")

# data melt wide to long; 

gdp_province_long <- melt(setDT(gdp_province), 
                          id.vars = c("地区"), variable.name = "year")
gdp_province_long$year <- as.character(gdp_province_long$year)
gdp_province_long$year <- gsub('X', '', gdp_province_long$year)
gdp_province_long$year <- gsub('年', '', gdp_province_long$year)

test <- reshape(gdp_province_long, idvar = "地区", timevar = "year", direction = "wide")

colnames(test) <- c(
  "area", 
  2019, 
  2018, 
  2017, 
  2016, 
  2015, 
  2014, 
  2013, 
  2012, 
  2011, 
  2010, 
  2009, 
  2008, 
  2007, 
  2006, 
  2005, 
  2004, 
  2003, 
  2002, 
  2001
)

gdp_province_long$year <- as.Date(gdp_province_long$year, format =  "%Y")
gdp_province_long$Year <- format(gdp_province_long$year, format="%Y")

colnames(gdp_province_long) <- c(
  "area", 
  "date", 
  "value", 
  "Year"
)

ggplot(
  data = gdp_province_long ,
  aes(x = as.numeric(Year)
      , y = value, color = area )
)  + geom_line(show.legend = FALSE) + geom_point(show.legend = FALSE) + 
  theme(text = element_text(family='Kai') )   + facet_wrap(~ area, scales = "free")

library(tidyverse)
gdp_province_long <- gdp_province_long[order(Year),] 
        
growth <- ddply(gdp_province_long,"area",transform,
    Growth=c(NA,exp(diff(log(value)))-1))


ggplot(
  data = growth ,
  aes(x = as.numeric(Year)
      , y = Growth, color = area )
)  + geom_line(show.legend = FALSE) + geom_point(show.legend = FALSE) + 
  theme(text = element_text(family='Kai') )   + facet_wrap(~ area, scales = "free") + 
  labs(
    x = NULL, 
    Y = NULL, 
    title = "Growth Rate by province"
  )



# -------------------------


