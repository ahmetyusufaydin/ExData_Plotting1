#install.packages("tidyverse")

library(tidyverse)

# Read data
data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)

## DATA CLEANING

# Convert Date to date format and filter for needed dates
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

data <- data %>% filter(Date == "2007-02-01" | Date == "2007-02-02")

# Create a combined datetime variable and drop old ones
data$datetime <- strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

data <- data %>% select(-(Date:Time))

# Convert missing values (?) to NA
data[1:7] <- data[1:7] %>% dplyr::na_if("?")

# Convert character variables into numeric
char_columns <- sapply(data, is.character)             
data[ , char_columns] <- as.data.frame(apply(data[ ,char_columns], 2, as.numeric))



## Plot 4 - Multiple Graph
par(mfrow = c(2,2))

# Plot [1,1]
with(data, plot(datetime,Global_active_power, type = "l", 
                ylab = "Global Active Power",
                xlab = ""))

# Plot [1,2]
with(data, plot(datetime,Voltage, type = "l"))


# Plot [2,1]
with(data, plot(datetime,Sub_metering_1, type = "l",
                ylab = "Energy Sub metering", xlab = ""))
with(data, lines(datetime,Sub_metering_2, col = "red"))
with(data, lines(datetime,Sub_metering_3, col = "blue"))
legend("topright", legend = names(data[5:7]), 
       bty = "n", lty = 1, col = c("black","red","blue"))


# Plot [2,2]
with(data, plot(datetime,Global_reactive_power, type = "l"))


# Copy to a PNG file
dev.copy(png, file = "plot4.png")
dev.off()