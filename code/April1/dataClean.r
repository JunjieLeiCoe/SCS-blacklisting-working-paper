# loading the data frame
rm(list = ls())
data <- read.csv("./data/sx_sh.csv")

## /** The first part is to separate the data -- Individuals, Male, Female and Corp **/

# Data Cleaning
###########################################################################
###########################################################################
###                                                                     ###
###                            DATA CLEANING                            ###
###                                                                     ###
###########################################################################
###########################################################################
# rename 
colnames(data)[7] <- "gender"

# Date format transfer;
data$reg_date <- as.Date(data$reg_date, "%Y-%m-%d")
data$publish_date <- as.Date(data$publish_date, "%Y-%m-%d")

# Filter out meaningless gender; 
#0     1     2     3     5     8 12988 13751 14125 14776 14923 15376 16492 16605 16665 16820 
#57529 92116 36377    19    72     9     1     1     1     1     1     1     1     1     1     1 

data <- data[data$gender < 3, ]
data$gender[data$gender == 1] <- "MALE"
data$gender[data$gender == 2] <- "FEMALE"
data$gender[data$gender == 0] <- "COMPANY"

# COMPANY  FEMALE    MALE 
#  57529   36377   92116 

#Split the data to 3 parts and store them in RAM;
MALE <- subset(data, gender == "MALE")
FEMALE <- subset(data, gender == "FEMALE")
CORP <- subset(data, gender == "COMPANY")
INDIVIDUAL <- subset(data, gender != "COMPANY")

# Run a EDA; 
###########################################################################
###########################################################################
###                                                                     ###
###                                E D A                                ###
###                                                                     ###
###########################################################################
###########################################################################

## Stargazer Descriptive Analysis;
library(stargazer)
stargazer(
  data, 
  type = "text"
)

#===========================================================================================
#  Statistic    N         Mean          St. Dev.      Min   Pctl(25)    Pctl(75)       Max    
#-------------------------------------------------------------------------------------------
#  X        186,133   93,067.000      53,732.110      1     46,534      139,600     186,133  
#shi xin id 186,133 413,856,726.000 307,183,647.000 2,685 102,877,338 702,498,896 705,015,269
#age        186,133     136.351       45,755.780      0        0          48      19,740,505 
#sex        186,133      1.798          118.801       0        0           1        16,861   
#-------------------------------------------------------------------------------------------

# Separate INDIVIDUAL listings && COPORATION listing;
library(ggplot2)
ggplot(data, aes(x = gender)) + geom_bar()  

## Plot Count of CORP and INDIVIDUAL;
# Case Published_date
ggplot(data) + geom_histogram(aes(x = publish_date), bins = 200, alpha=0.5, fill = "red") + 
  scale_x_date(date_labels="%b %y", date_breaks = "2 month") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  facet_grid(gender ~. , scales = "free") + 
  labs(x = "Publish Date for blacklisting cases", y = "")


data_date <- subset(
  data, 
  data$reg_date > "2010-01-01" & data$reg_date < "2019-01-01"
)

# Case Registration_date
ggplot(data_date) + geom_histogram(aes(x = reg_date), bins = 200, alpha=0.5, fill = "blue") + 
  scale_x_date(date_labels="%b %y", date_breaks = "2 month") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  facet_grid(gender ~. , scales = "free") + 
  labs(x="Registration Date for blacklisting cases", y = "") 


# 
# library(ggplot2)
# library(scales)
# 
# me$variable2 <- as.character(me$variable)
# me$variable2[me$variable2 %in% c("Temp. Max.","Temp. Min.")] <- "Temp. Max./Min."
# 
# ggplot() + geom_line(data=subset(me, variable=="Umid. Relat."), aes(Data, value), color="blue") +
#   geom_smooth(data=subset(me, variable=="Umid. Relat."), aes(Data, value), , color="blue") +
#   geom_line(data=subset(me, variable=="Vel. Vento"), aes(Data, value), color="gray20") +
#   geom_smooth(data=subset(me, variable=="Vel. Vento"), aes(Data, value), color="gray20") +
#   geom_line(data=subset(me, variable==c("Temp. Max.", "Temp. Min.")), aes(Data, value, colour=variable)) +
#   geom_smooth(data=subset(me, variable==c("Temp. Max.", "Temp. Min.")), aes(Data, value, colour=variable)) +
#   geom_bar(stat="identity", data=subset(me, variable=="Precipitação"), aes(Data, value), fill="blue") +
#   facet_grid(variable2~., scales="free_y") +
#   scale_x_date(breaks = date_breaks("months"), labels = date_format("%b")) +
#   theme(legend.position="none")







##################################################################
## AVERAGE TIME DiFFERENCE; 
library(tidyverse)
sample_1000_male <- MALE %>% sample_n(1000)
sample_1000_male$diff_d <- sample_1000_male$publish_date - sample_1000_male$reg_date
sample_1000_male$diff_d <- as.numeric(sample_1000_male$diff_d)
stargazer(sample_1000_male, type = "text", median = TRUE)
#============================================================================================================
#  Statistic   N        Mean          St. Dev.       Min     Pctl(25)      Median       Pctl(75)        Max    
#------------------------------------------------------------------------------------------------------------
#  X         1,000   89,432.350      54,330.720      420      43,153      85,740.5      137,967.2     186,094  
# shixin_id 1,000 388,460,957.000 310,865,823.000 137,905 99,899,307.0 516,734,484.0 702,376,040.0 704,999,142
# age       1,000     44.285          11.538         0         35           44            52           89     
# diff_d    1,000     332.030         634.166        0        30.8          89           174.2        3,398   
#------------------------------------------------------------------------------------------------------------
##################################################################











