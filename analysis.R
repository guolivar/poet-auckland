# Analysis

# Load libraries -----
library(openair)
library(ggplot2)
library(reshape2)
library(readr)
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
# Homogenise a time bases
all.odin.data <- timeAverage(raw.odin.data,avg.time = '1 min')

# Separate the data into chunks per metric
pm10.odin <- all.odin.data[,c('date',names(all.odin.data)[startsWith(names(all.odin.data),"PM10.")])]
write_csv(pm10.odin,paste0(filepath,'/pm10.csv'))
pm2.5.odin <- all.odin.data[,c('date',names(all.odin.data)[startsWith(names(all.odin.data),"PM2.5")])]
write_csv(pm2.5.odin,paste0(filepath,'/pm2.5.csv'))
Temperature.odin <- all.odin.data[,c('date',names(all.odin.data)[startsWith(names(all.odin.data),"Tempera")])]
write_csv(Temperature.odin,paste0(filepath,'/Temperature.csv'))
RH.odin <- all.odin.data[,c('date',names(all.odin.data)[startsWith(names(all.odin.data),"RH")])]
write_csv(RH.odin,paste0(filepath,'/RH.csv'))

odin.data.1hr <- timeAverage(all.odin.data,avg.time = '1 hour')

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
ggplot(long.pm10, aes(x=variable, value)) + 
  geom_boxplot(position=position_dodge(1)) +
  ylab("Daily PM10") +
  xlab("")


ggplot(long.pm10, aes(x=date,y=value,colour=variable)) +
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

# Time Variation plots ----------------
timeVariation(all.odin.data,pollutant = c('PM2.5.101','PM2.5.100','PM2.5.110','PM2.5.103','PM2.5.108'))
timeVariation(all.odin.data,pollutant = c('PM2.5.101','PM2.5.110','PM2.5.114'))

