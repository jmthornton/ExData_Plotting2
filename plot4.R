# This script produces a plot showing the total PM2.5 emission from 
# coal combustion sources in the United States
# for each of the years 1999, 2002, 2005, and 2008.
# Uses the ggplot2 plotting system.

# Load required libraries
if(!require(ggplot2))
  install.packages("ggplot2")

if(!require(dplyr))
  install.packages("dplyr")

require(ggplot2)
require(dplyr)

# Read data
# Assumes files summarySCC_PM25.rds and Source_Classification_Code.rds are in the working directory
print("Reading data...")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Filter the SCC data to produce a set of SCC codes
# related to coal combustion.
# The filter criteria is: EI.Sector contains the word "coal"
filt <- SCC %>%
  filter(grepl("[Cc]oal", EI.Sector))

# Filter data by the SCC codes produced above,
# group by year and calculate total emissions,
# then scale by 1e3 to obtain result in kilo-tons
totals <- NEI %>%
  filter(SCC %in% filt$SCC) %>%
  group_by(year) %>%
  summarise(totalEmissions = sum(Emissions)) %>%
  mutate(totalEmissions = totalEmissions / 1e3)

# Open PNG graphics device
png("plot4.png", width = 768, height = 768)

# Create a point plot and add a linear regression line
ggplot(totals, aes(year, totalEmissions)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE) +
  xlab("Year") +
  ylab("Total PM2.5 Emissions (ktons)") +
  ggtitle("United States,\nYearly PM2.5 Emissions from Coal Combustion-Related Sources") +
  theme(plot.title = element_text(size = 16, face = "bold", vjust = 2)) +
  theme(axis.title.x = element_text(face = "bold")) +
  theme(axis.title.y = element_text(face = "bold", vjust = 1.0))

# Close the graphics device
dev.off()