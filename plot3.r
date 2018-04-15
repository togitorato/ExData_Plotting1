#Get the data set address
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

filename = "project_data.zip"

#Download data set if it does not exist already.
if (!file.exists(filename)){
        download.file(url, destfile = filename, mode = "wb")
}

#Unzip the file
if (!file.exists("household_power_consumption")){
        unzip(filename)
}

#Read the lines and determine which ones to extract from the data set.
lines <- readLines("household_power_consumption.txt")
good <- grep("^[12]/2/2007", substr(lines, 1,8))

#Read and construct the table with respect to desired lines.
table <- read.table(text = lines[good], header = TRUE, sep = ";", na.strings = "?", 
                    col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
                                  "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                    stringsAsFactors = FALSE)

#Check if correct lines are read or not.
head(table)
tail(table)
#It seems correct.

#Combine the data and time variables to obtain full time information. Then transform into date class.
table$realDate = paste(table$Date, table$Time)
table$realDate = strptime(table$realDate, "%d/%m/%Y %H:%M:%S")

#Plot
png(filename = "plot3.png", width = 480, height = 480, units = "px")
with(table, plot(realDate, Sub_metering_1, type = "l", col = "black", ylab = "Energy sub metering", xlab = ""))
with(table, lines(realDate, Sub_metering_2, col = "red"))
with(table, lines(realDate, Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
