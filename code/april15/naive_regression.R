rm(list = ls())
library(stargazer)

myurl <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSlgk7b5SzbowsX8pUBgqB9nqNUM0YYq-s8jSF-C8nZSUOeW2qWBnXK_vLAjYk9Lnbt0RwcOoJ1Tm_m/pub?output=csv"
df    <- read.csv(url(myurl))
head(df)

df$population_wan_2018 <- gsub(",","",df$population_wan_2018)
df$blacklisting <- gsub(",","",df$blacklisting)
df$population_wan_2018 <- as.numeric(as.character(df$population_wan_2018))
df$blacklisting <- as.numeric(as.character(df$blacklisting))

stargazer(df, type = "latex",
          omit.summary.stat = c("p25", "p75"))


sapply(df, class)




ols <- lm(gdp_i ~ blacklisting + 
            population_wan_2018 + 
            incomeCategory, data = df) 


stargazer(ols, 
          type = "latex")

ols_2 <- lm(
  blacklisting ~ do_business_index_rank + 
    registering_property + 
    enforcing_contracts, 
  data = df
)

stargazer(
  ols_2 , 
  type = "latex"
)


