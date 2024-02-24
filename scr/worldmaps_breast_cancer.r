#######################
# Libraries and Setups
#######################

library(plotly)
library(ggplot2)
library(dplyr)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)

data.dir <- "data/raw"
out.dir <- "outputs/figures"

#######################
# Importing Raw Data
#######################

file <- file.path(data.dir, "dataset-asr-inc-both-sexes-in-2022-breast.csv")
data <- read_csv(file)

#######################
# Creating Map Datas
#######################

# Get world map data with rnaturalearth
world <- ne_countries(scale = "medium", returnclass = "sf")
data$Alpha.3.code <- data$`Alpha‑3 code`

# Merge dataset with the world map data
world_data <- merge(world, data, by.x = "iso_a3", by.y = "Alpha.3.code", all.x = TRUE)
world_data <- world_data[-which(world_data$iso_a3 == "-99"), ]

#######################
# Plot function body
#######################

# Define the colors and breaks for the color scale
colors <- c("#f7fcf5", "#e5f5e0", "#c7e9c0", "#a1d99b", "#74c476", "#41ab5d", "#238b45", "#006d2c", "#00441b")
breaks <- c(0, 112.4, 140.1, 187.5, 258.5, 462.5, max(world_data$`ASR (World) per 100 000`, na.rm = TRUE))

# Plot the choropleth map with the custom color scale
g <- ggplot(data = world_data) +
  geom_sf(aes(fill = `ASR (World) per 100 000`)) +
  scale_fill_gradientn(colors = colors, breaks = breaks, na.value = "grey50") +
  labs(title = "Incidence: Age-Standardized Rate by Country for Breast Cancer in 2022",
       fill = "ASR (World)\nper 100,000") +
  theme_minimal()

# Saving figure
ggsave(file = file.path(out.dir,'worldmap_incidence_breast.png'), g, width = 12, height = 10)

