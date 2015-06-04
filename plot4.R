require(sqldf)
require(lubridate)

#extract required dates
data <- read.csv.sql('household_power_consumption.txt', 
                     sql = "select * from file where Date='1/2/2007' or Date='2/2/2007'", 
                     sep = ";", stringsAsFactors = FALSE)

closeAllConnections()

#convert to date class
data['Date'] <- lapply(data['Date'], function(x) {as.Date(strptime(x,"%d/%m/%Y"))})

#convert time to POSIXct class
for (i in 1:nrow(data)) {
    data[i,'Time'] <- ymd_hms(paste(data[i,'Date'],data[i,'Time'],sep = " "))
}

png(file = 'plot4.png', width = 480, height = 480)

#create matrix of 2 x 2 plotting window
par(mfrow=c(2,2))

#top left plot
with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Global_active_power, type = "l", xlab = "",ylab = "Global Active Power"))

#top right plot
with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Voltage, type = "l", xlab = "datetime",ylab = "Voltage"))

#bottom left plot
with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Sub_metering_1, type = "l", xlab ="", ylab = "Energy sub metering"))
with(data,lines(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Sub_metering_2,type="l",col = "red"))
with(data,lines(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Sub_metering_3,type="l",col = "blue"))
#create and reduce size of legend in subplot
legend('topright', bty= 'n', lty = rep(1,3), col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#bottom right plot
with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Global_reactive_power, type = "l", xlab = "datetime",ylab = "Global_reactive_power"))


dev.off()