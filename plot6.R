# This script produces a plot showing the total PM2.5 emission from 
# motor vehicle sources in Baltimore City (fips code 24510) and
# Los Angeles County (fips code 06037) for each of the years 1999, 2002, 2005, and 2008.
# Uses the ggplot2 plotting system.

# Load required libraries
if(!require(ggplot2))
  install.packages("ggplot2")

if(!require(dplyr))
  install.packages("dplyr")

require(ggplot2)
require(dplyr)

# Read data
# Assumes file summarySCC_PM25.rds is in the working directory
print("Reading data...")
NEI <- readRDS("summarySCC_PM25.rds")

# Note: filter criteria used for motor vehicle sources
# is type == ON-ROAD

# Filter data by fips code and type,
# create text labels for the fips codes,
# group by year and area and calculate total emissions
totals <- NEI %>%
  filter(type == "ON-ROAD" & (fips == "24510" | fips == "06037")) %>%
  mutate(area = factor(fips, labels =c("Los Angeles County", "Baltimore City"))) %>%
  group_by(area, year) %>%
  summarise(totalEmissions = sum(Emissions))

# Open PNG graphics device
png("plot6.png", width = 768, height = 768)

# Create a faceted line plot showing the total PM2.5 emissions
# per year from motor vehicle sources for each area
ggplot(totals, aes(year, totalEmissions)) + 
  facet_grid(area ~ ., scales = "free_y") +
  geom_point() +
  geom_line(aes(colour = area)) +
  guides(colour = FALSE) +
  xlab("Year") +
  ylab("Total PM2.5 Emissions (tons)") +
  ggtitle("Baltimore City and Los Angeles County,\nYearly PM2.5 Emissions from Motor Vehicle Sources") +  
  theme(plot.title = element_text(size = 16, face = "bold", vjust = 2)) +
  theme(axis.title.x = element_text(face = "bold")) +
  theme(axis.title.y = element_text(face = "bold", vjust = 1.0))

# Close the graphics device
dev.off()