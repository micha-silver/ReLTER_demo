## ----relter-loading, message=FALSE, warning=FALSE------------------------------------
# Convenient way to load list of packages
pkg_list <- c("sf", "terra", "ReLTER", "tmap")
lapply(pkg_list,require, character.only = TRUE)
tmap_options(check.and.fix = TRUE)
tmap_mode("view")


## ----relter-maintainer---------------------------------------------------------------
library(ReLTER)
maintainer("ReLTER")


## ----relter-citation-----------------------------------------------------------------
citation("ReLTER")


## ----relter-functions----------------------------------------------------------------
ls("package:ReLTER")


## ----relter-donana-------------------------------------------------------------------
donana = get_ilter_generalinfo(country_name = "Spain",
                              site_name = "Doñana")
(donana_id = donana$uri)


## ----relter-plot-donana--------------------------------------------------------------
donana_polygon <- get_site_info(donana_id, category = "Boundaries")
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(donana_polygon) +
  tm_fill(col = "blue", alpha = 0.3)


## ----relter-kinord-info--------------------------------------------------------------
loch_kinord <- get_ilter_generalinfo(country_name = "United K",
                              site_name = "Loch Kinord")
(loch_kinord_id = loch_kinord$uri)
loch_kinord_details <- get_site_info(loch_kinord_id,
                                 c("Contacts", "EnvCharacts", "Parameters"))

print(paste("Site manager:",
            loch_kinord_details$generalInfo.siteManager[[1]]['name'],
            loch_kinord_details$generalInfo.siteManager[[1]]['email']))


## ----relter-kinord-metadata----------------------------------------------------------
# Metadata contact:
(loch_kinord_details$generalInfo.metadataProvider[[1]]['name'])
print(paste("Average air temperature:",
            loch_kinord_details$envCharacteristics.airTemperature.avg))
print(paste("Annual precipitation:",
            loch_kinord_details$envCharacteristics.precipitation.annual))


## ----relter-kinord-geobonbiome-------------------------------------------------------
print(paste("GeoBonBiome:",
            loch_kinord_details$envCharacteristics.geoBonBiome[[1]]))
# Parameters:
head(loch_kinord_details$parameter[[1]]['parameterLabel'], 12)


## ----elter-slovakia------------------------------------------------------------------
lter_slovakia_id = "https://deims.org/networks/3d6a8d72-9f86-4082-ad56-a361b4cdc8a0"

network_research_topics <- get_network_research_topics(lter_slovakia_id)
head(network_research_topics$researchTopicsLabel, 20)


## ----relter-slovakia-network---------------------------------------------------------
lter_slovakia_sites <- get_network_sites(lter_slovakia_id)
lter_slovakia_sites$title


## ----relter-slovakia-map-------------------------------------------------------------
lter_slovakia <- produce_network_points_map(lter_slovakia_id, "SVK")
svk <- readRDS("gadm36_SVK_0_sp.rds")  # downloaded by produce_network_points_map()
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(lter_slovakia) + 
  tm_dots(col = "blue", size=0.04) +
  tm_shape(svk) + 
  tm_borders(col = "purple", lwd = 0.6) +
  tm_grid(alpha = 0.4) +
  tm_scale_bar(position = c("right", "bottom"))

