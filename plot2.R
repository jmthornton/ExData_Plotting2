# This script produces a plot showing the total PM2.5 emission from all sources 
# in Baltimore City (fips code 24510) for each of the years 1999, 2002, 2005, and 2008.
# Uses the base plotting system.

# Load required libraries
if(!require(dplyr))
  install.packages("dplyr")

require(dplyr)

# Read data
# Assumes file summarySCC_PM25.rds is in the working directory
print("Reading data...")
NEI <- readRDS("summarySCC_PM25.rds")

# Filter data to include only Baltimore City (fips code 24510)
# Calculate total emissions per year group and
# scale by 1e3 to obtain result in kilo-tons
totals <- NEI %>% 
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(totalEmissions = sum(Emissions)) %>%
  mutate(totalEmissions = totalEmissions / 1e3)

# Open PNG graphics device
png("plot2.png", width = 768, height = 768)

# Create the plot and add a linear regression line
with(totals, {
  plot(totalEmissions ~ year
       ,main = "Baltimore City, Yearly PM2.5 Emissions"
       ,xlab = "Year"
       ,ylab = "Total PM2.5 Emissions (ktons)")
  abline(lm(totalEmissions ~ year), col = "red")
  legend("topright", lty = 1, col = "red", legend = "Linear regression")
})

# Close the graphics device
dev.off()