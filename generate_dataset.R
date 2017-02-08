# Generate datasets

# Load libraries -----
library(openair)

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
# Iterate through all the files in the folder
for (file in files){
  # Extract the serial number from the filenames
  odin_sn <- substr(file,1,8)
  # Get the right time
  time_id <- max(1,which(time_corrections$serialn == odin_sn))
  eval(parse(text=paste0(odin_sn," <- read.delim(paste0(filepath,'/',file))")))
  eval(parse(text=paste0(odin_sn,"$date <-as.POSIXct(paste(",odin_sn,"$Day,",odin_sn,"$Time),tz='Etc/GMT-12')")))
  Real_time <- time_corrections$real_time[time_id]
  print(odin_sn)
  eval(parse(text=paste0("print(",odin_sn,"$date[1])")))
  print(Real_time)
  eval(parse(text=paste0("tdiff <- (as.POSIXct(Real_time,format = '%Y-%m-%d %H:%M:%S') - ",odin_sn,"$date[1])")))
  print(tdiff)
  eval(parse(text=paste0(odin_sn,"$date <- ",odin_sn,"$date + tdiff")))
  eval(parse(text=paste0("print(strftime(",odin_sn,"$date[1],format = '%Y-%m-%d %H:%M:%S %Z'))")))
  eval(parse(text=paste0(odin_sn,"$FrameLength <- NULL")))
  eval(parse(text=paste0(odin_sn," <- subset(",odin_sn,",subset=(date>='2016-12-07')&(date<='2017-02-05'))")))
  eval(parse(text=paste0("names(",odin_sn,") <- c(paste(names(",odin_sn,")[1:13],substr('",odin_sn,"',5,8),sep=''),'date')")))
  
  c(paste(names(ODIN.100)[1:13],'.100',sep=""),'date')
}
save(list=serialn,file=paste0(filepath,'/odin_traffic_data.RData'))
