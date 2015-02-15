if(!require(ggplot2))
  install.packages("ggplot2")

if(!require(dplyr))
  install.packages("dplyr")

require(ggplot2)
require(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

totals <- NEI %>% 
  filter(fips == "24510") %>%
  group_by(type, year) %>%
  summarise(TotalEmissions = sum(Emissions))

print(ggplot(totals, aes(year, TotalEmissions)) + 
  facet_grid(. ~ type) + 
  geom_point() + 
  geom_smooth(method = "lm"))

