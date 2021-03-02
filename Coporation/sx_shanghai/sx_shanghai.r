# loading the data frame
data <- read.csv("~/JUNJIE/WebScraper_Research2020S/sx_shanghai.csv")

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
data$reg_date <- as.Date(data$publish_date, "%Y-%m-%d")

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
ggplot(data, aes(x = gender)) +geom_bar()  



## Plot Count of CORP and INDIVIDUAL;
ggplot(data) + geom_histogram(aes(x = publish_date, stat="count", bins = 50) + 
  scale_x_date(date_labels="%b %y", date_breaks = "2 month") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  facet_grid(gender ~. , scales = "free")



## Create a csv file that can let Peter view; 










