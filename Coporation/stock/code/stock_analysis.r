# * Stock Market Performance (Black Listing)

# * Clear Global Env
rm(list = ls())
setwd("~/Downloads/stock/code")

# *  Import libraries
library(ggplot2)
library(stargazer)
library(quantmod)


df <- read.csv("../../data/green_land.csv")
stargazer(
    df,
    type = "text"
)

df$Date <- as.Date(df$Date)

# * plot1 Greenland Holding Corporation Limited
ggplot(
    data = df, aes(x = Date, y = Close)
) +
    geom_line(color = "blue") +
    labs(
        x = "Date",
        y = "Daily Close Price",
        title = "Overview: Green_Land Holding Corporation Limited",
        subtitle = "Trading Code: 600606",
        captions = "Source: yahoo finance"
    ) +
    scale_x_date(date_labels = "%b %y", date_break = "3 month") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))