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
data <- dbGetQuery(myDB, 'select iname, age, 
                   area, reg_date, publish_date, 
                   sexy from sx')


data$reg_date <- as.Date(data$reg_date, "%Y-%m-%d")
data$publish_date <- as.Date(data$publish_date, "%Y-%m-%d")

library(ggplot2)

# ggplot2 
# density plot 

head(data$age)
# data_age <- data[data$age != 0 & data$age <95 & data$age > 0, ]
data_age <- data[  data$age <99 & data$age >= 0, ]
data_age <- data_age[data_age$sexy == 1 |  data_age$sexy == 2 | data_age$sexy == 0, ]
data_age <- subset(data_age , nchar(area) < 4)
data_age$area[which(data_age$area == "")] <- "暂无"




## Failed; Data is discrete;
# ggplot(data = data_age, 
#        mapping = aes(x = age, fill = 'red', colour = 'red')) + 
#   geom_density(aes(y = ..count..), alpha = 0.3, show.legend = FALSE)  + 
#   labs(title = "Age Distribution of blacklisted individuals (8,095,943 observations)" ) + 
#   scale_y_continuous(labels = scales::comma) + 
#   scale_x_continuous(breaks = c(seq(0, 100, 5))) + 
#   labs(x = "", y = "")


data_age$sexy[data_age$sexy == 0] <- c("CORP")
data_age$sexy[data_age$sexy == 1] <- c('MALE')
data_age$sexy[data_age$sexy == 2] <- c('FEMALE')



table(data_age$sexy)
## FEMALE   MALE 
##  36302  91947 
data_age$sexy <- as.factor(data_age$sexy)

library(stargazer)
stargazer::stargazer(data_age, type = "text")

ggplot(data = data_age, 
       mapping = aes(x = age, fill = sexy, color = sexy)) + 
  geom_histogram(position = "dodge", aes(y = ..count..), alpha = 0.4) + 
  scale_x_continuous(breaks = c(seq(0, 100, 5))) + 
  scale_y_continuous(labels = scales::comma) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=0)) + 
  theme(legend.position = "top") + 
  labs(title = "Gender Distribution (8,057,616 Observations)", x = NULL, y = NULL, 
       fill = 'Gender',  y = "Count", color= 'Gender' ) 




## COUNT ; proportionally stacked 
## Too much information; 
ggplot(data = data_age, 
       mapping = aes(x = age, fill = sexy, color = sexy)) + 
  geom_histogram(position = "dodge", aes(y = ..count..), alpha = 0.4, bins = 50) + 
  scale_x_continuous(breaks = c(seq(0, 100, 10))) + 
  scale_y_continuous(labels = scales::comma) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=0)) + 
  theme(legend.position = "top", text = element_text(family='Kai')) + 
  labs(title = "Gender Distribution by Province", x = NULL, fill = 'Gender',  
       y = "Count", color= 'Gender' ) +
   facet_wrap(~ area, scales = "free")
  


library(tidyverse)
data_age$Year <- format(data_age$publish_date, format="%Y")

df <- as.data.frame(data_age %>% 
  group_by(Year, area) %>% 
  summarise(n = n()))

df <- subset(
  df,
  Year >= 2010
)


## Need to transfer the data from Long to Wide; 
library(reshape)
flourish_df <- reshape(
  df, 
  idvar = "area", 
  timevar = "Year", 
  direction = "wide"
)

write.csv(flourish_df, "race.csv")

ggplot(
  data = df,
  mapping = aes(x = Year, y = n, color = area, group = 1 )
) + geom_point(show.legend = FALSE)  +  geom_line(show.legend = FALSE) + 
  facet_wrap( ~ area, scales = "free") + 
  labs(title = "Blacklisted cases by Province, Year", x = NULL, 
       fill = 'Gender',  y = NULL, color= 'Gender' ) +
    theme(text = element_text(family='Kai'),
          axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=0))





### Output to Flourish



## If else assign AGE GROUP; 

data_age <- data[  data$age <99 & data$age >= 0, ]

df1_gender_area <- data.frame(table(data_age$sexy, data_age$area))

write.csv(df1_gender_area, "gender_area.csv")



data_age$Group <- ifelse(
  data_age$age < 20 & data_age$age != 0, "Under 20",
  ifelse(
    data_age$age >= 20 & data_age$age < 65, "Under 60", 
    ifelse(
      data_age$age >= 65, "Retired", ""
    )
  )
)

tmp <- data.frame(table(data_age$sexy, data_age$Group))



data_age <- data[  data$age <99 & data$age >  0, ]


write.csv(data.frame(table(data_age$sexy, data_age$Group)),
          "age_group.csv")


write.csv(data.frame(table(data_age$sexy, data_age$Group)), "count.csv")


data_age <- data[  data$age == 0, ]

data_age$test <- ifelse(
    grepl('技术', data_age$iname), "Tech", ifelse(
      grepl('房地产', data_age$iname), "Real Estate", ifelse(
        grepl('建筑', data_age$iname), "Construction", ifelse(
          grepl('汽车', data_age$iname), "Car", ifelse(
            grepl('投资', data_age$iname), "Investment", ifelse(
              grepl('管理', data_age$iname), "Management", "Others"
            )
          )
        )
      )
    )
)






test1<- rbind(df1_gender_area, df_area_industry)

write.csv(test1, "test.csv")






