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



## PLOT 1 - Histogram for Global Active Power

hist(data$Global_active_power, 
     main = "Global Active Power", 
     col = "red", 
     xlab = "Global Active Power (kilowatts)")

# Copy to a PNG file
dev.copy(png, file = "plot1.png")
dev.off()
