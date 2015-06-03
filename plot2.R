require(sqldf)
require(lubridate)

data <- read.csv.sql('household_power_consumption.txt', 
                     sql = "select * from file where Date='1/2/2007' or Date='2/2/2007'", 
                     sep = ";", stringsAsFactors = FALSE)

closeAllConnections()

data['Date'] <- lapply(data['Date'], function(x) {as.Date(strptime(x,"%d/%m/%Y"))})

data$Time1 <- as.POSIXct("2015-01-01", tz = "UTC")
data <- transform(data, Time1 = as.POSIXct(Time1))

for (i in 1:nrow(data)) {
    data[i,'Time'] <- ymd_hms(paste(data[i,'Date'],data[i,'Time'],sep = " "))
}

png(file = 'plot2.png', width = 480, height = 480)

with(data,plot(as.POSIXct(as.numeric(Time),origin = "1970-01-01", tz= "UTC"),Global_active_power, type = "l", xlab = "",ylab = "Global Active Power (kilowatts)"))

dev.off()
