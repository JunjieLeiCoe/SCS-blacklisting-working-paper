rm(list = ls())

library(stargazer)

myurl <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSlgk7b5SzbowsX8pUBgqB9nqNUM0YYq-s8jSF-C8nZSUOeW2qWBnXK_vLAjYk9Lnbt0RwcOoJ1Tm_m/pub?output=csv"
df <- read.csv(url(myurl))

# descriptive statistics;
stargazer(
  df, 
  type = "text"
)

# Transfer factor var to numeric; prepare for regression;
df$population_wan_2018 <- gsub(",","", df$population_wan_2018)
df$gdp_i <- gsub(",","", df$gdp_i)

df$population_wan_2018 <- as.numeric(as.character(df$population_wan_2018))
df$gdp_i <- as.numeric(as.character(df$gdp_i))

# Transfer first-half
# & second-half instead of index
df$doing_business <- ifelse(df$do_business_index_rank <=15, "Easy_top_15", "hard_top_15")
df$cost <- ifelse(df$cost <= 15, "Easy_business_top_15", "Expensive_start_business")


#################################################################
##             Predictor: Blacklisted Corporations             ##
#################################################################

reg0 <- lm(
  data = df, 
  df$corporation ~ df$population_wan_2018 + gdp_i + male
)


# regression - 1 that only includes the population in 10,000;
reg1 <- lm(
  data = df, 
  df$corporation ~ df$population_wan_2018 + gdp_i + male + female
)

# regression - 2; Includes doing business index.
reg2 <- lm(
  data = df, 
  df$corporation ~ df$population_wan_2018 + gdp_i + male + female + df$doing_business
)

# regression - 3; 
reg3 <- lm(
  data = df, 
  df$corporation ~ df$population_wan_2018 + gdp_i + male + female +  df$cost
)


stargazer(reg1, type  = "text")
stargazer(reg2, type = "text")
stargazer(reg3, type = "text")


stargazer(
  reg0,
  reg1, 
  reg2, 
  reg3, 
  type="text"
)

