require(sqldf)
require(lubridate)

#extract required dates
data <- read.csv.sql('household_power_consumption.txt', 
                     sql = "select * from file where Date='1/2/2007' or Date='2/2/2007'", 
                     sep = ";", stringsAsFactors = FALSE)

closeAllConnections()

#convert to Date class
data['Date'] <- lapply(data['Date'], function(x) {as.Date(strptime(x,"%d/%m/%Y"))})

#convert time to POSIXct class
for (i in 1:nrow(data)) {
    data[i,'Time'] <- ymd_hms(paste(data[i,'Date'],data[i,'Time'],sep = " "))
}

png(file = 'plot2.png', width = 480, height = 480)

#plot line graph
with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Global_active_power, type = "l", xlab = "",ylab = "Global Active Power (kilowatts)"))

dev.off()
