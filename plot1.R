require(sqldf)

data <- read.csv.sql('household_power_consumption.txt', 
                     sql = "select * from file where Date='1/2/2007' or Date='2/2/2007'", 
                     sep = ";", stringsAsFactors = FALSE)

closeAllConnections()

data['Date'] <- lapply(data['Date'], function(x) {as.Date(strptime(x,"%d/%m/%Y"))})

for (i in 1:nrow(data)) {
    data[i,'Time'] <- format(strptime(paste(data[i,'Date'],data[i,'Time']),
                             "%Y-%m-%d %H:%M:%S"), format = "%H:%M:%S")
}

png(file = 'plot1.png', width = 480, height = 480)
hist(data$Global_active_power, main = "Global Active Power", col = "red", xlab = "Global Active Power (kilowatts)")
dev.off()
