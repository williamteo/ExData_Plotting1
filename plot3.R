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

png(file = 'plot3.png', width = 480, height = 480)

#plot line graph
with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Sub_metering_1, type = "l", xlab ="", ylab = "Energy sub metering"))
with(data,lines(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Sub_metering_2,type="l",col = "red"))
with(data,lines(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Sub_metering_3,type="l",col = "blue"))
#create legend
legend('topright', lty = c(1,1,1), col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()