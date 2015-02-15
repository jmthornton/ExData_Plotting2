if(!require(ggplot2))
  install.packages("ggplot2")

if(!require(dplyr))
  install.packages("dplyr")

require(ggplot2)
require(dplyr)

print("Reading data...")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

totals <- NEI[NEI$SCC %in% filter(SCC, grepl("[Vh]ehicles", SCC.Level.Three))$SCC,] %>%
  filter(fips == "24510" | fips == "06037") %>%
  group_by(fips, year) %>%
  summarise(TotalEmissions = sum(Emissions))

print(ggplot(totals, aes(year, TotalEmissions)) + 
        facet_grid(. ~ fips) +
        geom_point() + 
        geom_smooth(method = "lm"))