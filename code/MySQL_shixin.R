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
data <- dbGetQuery(myDB, 'select iname, age, area, reg_date, publish_date from sx')





