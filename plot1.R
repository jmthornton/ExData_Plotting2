if(!require(dplyr))
  install.packages("dplyr")

require(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

totals <- NEI %>%
  group_by(year) %>%
  summarise(TotalEmissions = sum(Emissions))

with(totals, {
  plot(TotalEmissions ~ year, main = "Total Emissions Per Year", xlab = "Year", ylab = "Total Emissions")
  abline(lm(TotalEmissions ~ year), col = "red")
})