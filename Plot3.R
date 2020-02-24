
### Plot 3

## Get the data for the project
filename <- "exdata_data_household_power_consumption.zip"
fileURL <- "https://www.coursera.org/learn/exploratory-data-analysis/peer/ylVFo/course-project-1"
## Download and unzip the dataset:
if (!file.exists(filename)){
        download.file(fileURL, filename, method="curl")
}
# # !!This isn't workng - getting "error 1 in extracting from zip file"
# #   Had to unzip manually
# if (!file.exists("household_power_consumption.txt")) { 
#         unzip(filename) 
# }

## Read in the full power consumption file
# Read file into table
#! Spent a lot of time trying to remove default column namez (V1...); Used header switch
full_HPC <- read.table("./household_power_consumption.txt", sep=";", header=T, na.strings = "?",  
                       # Date
                       colClasses = c("character", 
                                      # Time
                                      "character", 
                                      # Global_active_power
                                      "double",    
                                      # Global_reactive_power
                                      "double",    
                                      # Voltage
                                      "double",    
                                      # Global_intensity
                                      "double", 
                                      # Sub_metering_1
                                      "numeric",   
                                      # Sub_metering_2
                                      "numeric",   
                                      # Sub_metering_3
                                      "numeric" ))  
#Load lubridate package to manipulate dates and times
library(lubridate)
# Create vector with reformatted dates from "col 1 "Date" 
date_FHPC <- as.Date(full_HPC[,1],format='%d/%m/%Y')
# Write formatted dates to first ("Date") column 
full_HPC[ ,1] <- date_FHPC

# Get the rows for 2007-02-01 and 2007-02-02
HPC_1and2Feb <- subset(full_HPC, Date == '2007-02-01' | Date == '2007-02-02')

# !!suppress the rowname after subsetting
# rownames(HPC_1and2Feb) <- c()  # maybe don't need this?


# Combine and format date/time for plot 2 (uses sub-metering)
date_time <- strptime(paste(HPC_1and2Feb$Date, HPC_1and2Feb$Time), 
                      format = "%Y-%m-%d %H:%M:%S")

# Create the line graph for plot 3
# Create png file of proper dimensions
png("plot3.png", width = 480, height = 480, units = "px")

# Plot line graph and create labels
with(HPC_1and2Feb, plot(date_time, Sub_metering_1, col = "purple", type = "l",
                        xlab = " ",
                        ylab = "Energy sub metering"))
with(lines(date_time, HPC_1and2Feb$Sub_metering_2, col = "red"))
with(lines(date_time, HPC_1and2Feb$Sub_metering_3, col = "blue"))
# Create legend in top right
legend("topright", lwd=1, col = c("purple", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Turn off the graphics device
dev.off()
