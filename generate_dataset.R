# Generate datasets

# Load libraries -----
library(openair)
library(readr)

# Process the files -------------
# set the data path
filepath <- '~/data/ODIN_SD/2017-traffic-AK'
# get the files to process
files <- list.files(filepath,pattern = 'ODIN*')
# load the time corrections information
time_corrections <- read.delim(paste0(filepath,'/time_corrections.txt'))
# put "realtime" in the correct time zone
time_corrections$real_time <- as.POSIXct(time_corrections$real_time,tz = 'Etc/GMT-12')
# create a vector with the serial numbers of the instruments
serialn <- substr(files,1,8)
# load the calibration factors from file
pm_corrections <- read.csv(paste0(filepath,'/odin_calibration.csv'))
# Iterate through all the files in the folder
for (file in files){
  # Extract the serial number from the filenames
  odin_sn <- substr(file,1,8)
  # Get the right time
  time_id <- max(1,which(time_corrections$serialn == odin_sn))
  raw_data <- read.delim(paste0(filepath,'/',file))
  raw_data$date <- as.POSIXct(paste(raw_data$Day,raw_data$Time),tz='Etc/GMT-12')
  Real_time <- time_corrections$real_time[time_id]
  print(odin_sn)
  print(raw_data$date[1])
  print(Real_time)
  tdiff <- (as.POSIXct(Real_time,format = '%Y-%m-%d %H:%M:%S') - raw_data$date[1])
  print(tdiff)
  raw_data$date <- raw_data$date + tdiff
  print(strftime(raw_data$date[1],format = '%Y-%m-%d %H:%M:%S %Z'))
  raw_data$FrameLength <- NULL
  # Subset data only when they were in the field
  raw_data <- subset(raw_data,subset=(date>='2016-12-07')&(date<='2017-02-05'))
  # Get the correction coefficients
  corr_id.pm10 <- max(1,which(pm_corrections$serialn == odin_sn & pm_corrections$name == 'PM10'))
  slope.pm10 <- pm_corrections$slope[corr_id.pm10]
  intercept.pm10 <- pm_corrections$intercept[corr_id.pm10]
  corr_id.pm2.5 <- max(1,which(pm_corrections$serialn == odin_sn & pm_corrections$name == 'PM2.5'))
  slope.pm2.5 <- pm_corrections$slope[corr_id.pm2.5]
  intercept.pm2.5 <- pm_corrections$intercept[corr_id.pm2.5]
  # Correct the PM data
  # PM10
  raw_data$PM10 <- intercept.pm10 + slope.pm10 * raw_data$PM10
  # PM2.5
  raw_data$PM2.5 <- intercept.pm2.5 + slope.pm2.5 * raw_data$PM2.5
  names(raw_data) <- c(paste(names(raw_data)[1:13],substr(odin_sn,5,8),sep=''),'date')
  eval(parse(text=paste0(odin_sn," <- raw_data")))
}
save(list=serialn,file=paste0(filepath,'/odin_traffic_data.RData'))
