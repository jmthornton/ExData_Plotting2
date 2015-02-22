# This script produces a plot showing the total PM2.5 emissions from 
# each separate source type in Baltimore City 
# for each of the years 1999, 2002, 2005, and 2008.
# Uses the ggplot2 system.

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

# Filter data to include only Baltimore City (fips code 24510),
# group by year and source type then calculate total emissions
totals <- NEI %>% 
  filter(fips == "24510") %>%
  group_by(type, year) %>%
  summarise(totalEmissions = sum(Emissions))

# Open PNG graphics device
png("plot3.png", width = 768, height = 768)

# Create a faceted point plot showing the total PM2.5 emissions
# per year for each source type with a linear regression line
ggplot(totals, aes(year, totalEmissions)) + 
  facet_grid(. ~ type) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
  guides(colour = FALSE) +
  xlab("Year") +
  ylab("Total PM2.5 Emissions (tons)") +
  ggtitle("Baltimore City, Yearly PM2.5 Emissions by Source Type") +
  theme(plot.title = element_text(size = 16, face = "bold", vjust = 2))

# Close the graphics device
dev.off()