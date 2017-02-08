# Analysis

# Load libraries -----
library(openair)
library(ggplot2)
library(reshape2)
# Load the data -------------
filepath <- '~/data/ODIN_SD/2017-traffic-AK'
load(paste0(filepath,'/odin_traffic_data.RData'))
# Merge the datasets
raw.odin.data <- merge(ODIN.100,ODIN.101,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.102,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.103,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.106,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.107,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.108,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.109,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.110,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.114,by='date',all=TRUE)
raw.odin.data <- merge(raw.odin.data,ODIN.115,by='date',all=TRUE)
# Homogenise the time bases (on the minute)
odin.data <- timeAverage(raw.odin.data,avg.time = '1 min')
odin.data.1hr <- timeAverage(raw.odin.data,avg.time = '1 week')
long.odin.data <- melt(odin.data,id.vars = 'date')
long.odin.data.1hr <- melt(odin.data.1hr,id.vars = 'date')

# 1 minute data ----
# PM1 data
long.pm1 <- long.odin.data[startsWith(as.character(long.odin.data$variable),"PM1."),]
# PM2.5 data
long.pm2.5 <- long.odin.data[startsWith(as.character(long.odin.data$variable),"PM2.5"),]
# PM10 data
long.pm10 <- long.odin.data[startsWith(as.character(long.odin.data$variable),"PM10"),]

long.pm1$log_value <- log(long.pm1$value)
long.pm2.5$log_value <- log(long.pm2.5$value)
long.pm10$log_value <- log(long.pm10$value)
ggplot(long.pm1, aes(x=variable, value)) + 
  geom_boxplot(position=position_dodge(1)) + 
  ylim(c(0,25))

ggplot(long.pm1, aes(x=date,y=value,colour=variable)) +
  geom_line()

# 1 hour data ----
# PM1 data
long.pm1.1hr <- long.odin.data.1hr[startsWith(as.character(long.odin.data.1hr$variable),"PM1."),]
# PM2.5 data
long.pm2.5.1hr <- long.odin.data.1hr[startsWith(as.character(long.odin.data.1hr$variable),"PM2.5"),]
# PM10 data
long.pm10.1hr <- long.odin.data.1hr[startsWith(as.character(long.odin.data.1hr$variable),"PM10"),]

long.pm1.1hr$log_value <- log(long.pm1.1hr$value)
long.pm2.5.1hr$log_value <- log(long.pm2.5.1hr$value)
long.pm10.1hr$log_value <- log(long.pm10.1hr$value)
ggplot(long.pm2.5.1hr, aes(x=variable, value)) + 
  geom_boxplot(position=position_dodge(1))


ggplot(long.pm10.1hr, aes(x=date,y=value,colour=variable)) +
  geom_line()

