##------------------------------------------------------------------------------
## Installing packages
##------------------------------------------------------------------------------

## ----intro-packages, message=FALSE--------------------------------------------
# Install some standard spatial packages from CRAN
if (!require("sf", quietly = TRUE))
  install.packages("sf")
if (!require("terra", quietly = TRUE))
  install.packages("terra")
#if (!require("knitr", quietly = TRUE))
#  install.packages("knitr")
#if (!require("glue", quietly = TRUE))
#  install.packages("glue")
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")

## ----install-ReLTER, message=FALSE--------------------------------------------
# Install the dev version of ReLTER for use new function
if (!require("ReLTER", quietly = TRUE))
  remotes::install_github("ropensci/ReLTER", force = TRUE)

## ----intro-loading, message=FALSE, warning=FALSE------------------------------
# Convenient way to load list of packages
pkg_list <- c("sf", "terra", "ReLTER", "tmap", "leaflet")
lapply(pkg_list, require, character.only = TRUE)

##------------------------------------------------------------------------------
## Initial example
##------------------------------------------------------------------------------

## ----site_info----------------------------------------------------------------
lakeMaggiore <- ReLTER::get_site_info(
  deimsid = "https://deims.org/f30007c4-8a6e-4f11-ab87-569db54638fe",
  category = "Boundaries"
)
lakeMaggiore


## ----lakeMaggioreMap----------------------------------------------------------
leaflet(lakeMaggiore) %>%
  addProviderTiles(provider = "CartoDB.PositronNoLabels",
                  group = "Basemap", layerId = 123) %>%
  addTiles("http://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}.png") %>% 
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5)


## ----lakeMaggioreOtherInfo----------------------------------------------------
siteInfo <- ReLTER::get_site_info(
  deimsid = "https://deims.org/f30007c4-8a6e-4f11-ab87-569db54638fe",
  category = c("Affiliations")
)
print(siteInfo$affiliation.projects[[1]])

##------------------------------------------------------------------------------
## Second example
##------------------------------------------------------------------------------

## ----activityMarPiccolo-------------------------------------------------------
activityNoMap <- ReLTER::get_activity_info(
  activityid =
  "https://deims.org/activity/8786fc6d-5d70-495c-b901-42f480182845",
  show_map = FALSE
)
activityNoMap


## ----activityMarPiccoloMap----------------------------------------------------
activityMap <- ReLTER::get_activity_info(
  activityid =
  "https://deims.org/activity/8786fc6d-5d70-495c-b901-42f480182845",
  show_map = TRUE
)


## ----dataset------------------------------------------------------------------
tDataset <- get_dataset_info(
  datasetid = "https://deims.org/dataset/38d604ef-decb-4d67-8ac3-cc843d10d3ef",
  show_map = TRUE
)
tDataset

##------------------------------------------------------------------------------
## Third example
##------------------------------------------------------------------------------

## ----adv-missing--------------------------------------------------------------
# Multiple sites in the KISKUN region of Hungary
kiskun <- ReLTER::get_ilter_generalinfo(country_name = "Hungary",
                              site_name = "KISKUN")
# How many sites?
print(paste("In Kiskun region: ", length(kiskun$title), "sites"))


## ----adv-missing2-------------------------------------------------------------
(kiskun$title)
# Which site? Bugac-Bocsa
bugac_id <- kiskun[7,]$uri
bugac_details <- ReLTER::get_site_info(bugac_id,"Contacts")
(bugac_details$generalInfo.siteManager[[1]]['name'])


## ----adv-missing-boundary-----------------------------------------------------
bugac_polygon <- ReLTER::get_site_info(bugac_id, "Boundaries")
str(bugac_polygon)
# No geometry


## ----adv-paradiso-------------------------------------------------------------
paradiso <- ReLTER::get_ilter_generalinfo(country_name = "Italy",
                              site_name = "Gran Paradiso")
(paradiso$title)

# Choose the second
paradiso_id <- paradiso[2,]$uri
paradiso_details <- ReLTER::get_site_info(paradiso_id, "Contacts")
# Multiple names for metadata:
paradiso_details$generalInfo.metadataProvider[[1]]['name']


## ----adv-paradiso-info--------------------------------------------------------
# But what about funding agency
paradiso_details$generalInfo.fundingAgency

##------------------------------------------------------------------------------
## Additional plots
##------------------------------------------------------------------------------

## ----adv-pie-params, warning=FALSE, message=FALSE-----------------------------
ReLTER::produce_site_parameters_pie("https://deims.org/8129fed1-37b3-48e6-b786-d416917acc72")


## ----adv-waffle-params, warning=FALSE, message=FALSE--------------------------
ReLTER::produce_site_parameters_waffle("https://deims.org/8129fed1-37b3-48e6-b786-d416917acc72")


##------------------------------------------------------------------------------
## eLTER Network example
##------------------------------------------------------------------------------

## ----relter-site_map, warning=FALSE, message=FALSE----------------------------

# Example of Lake Maggiore site
sitesNetwork <- ReLTER::get_network_sites(
  networkDEIMSID = "https://deims.org/network/7fef6b73-e5cb-4cd2-b438-ed32eb1504b3"
)
# In the case of Italian sites are selected only true sites and excluded the
# macrosites.
sitesNetwork <- (sitesNetwork[!grepl('^IT', sitesNetwork$title),])
sf::st_crs(sitesNetwork) = 4326
tmap::tmap_mode("plot")
siteMap <- ReLTER::produce_site_map(
  deimsid = "https://deims.org/f30007c4-8a6e-4f11-ab87-569db54638fe",
  countryCode = "ITA",
  listOfSites = sitesNetwork,
  gridNx = 0.7,
  gridNy = 0.35
)
siteMap
tmap::tmap_mode("view")


##------------------------------------------------------------------------------
## Acquiring EO data
##------------------------------------------------------------------------------

## ----adv-balaton-ods----------------------------------------------------------
# Get DEIMS ID for Kis-Balaton site 
kis_balaton <- ReLTER::get_ilter_generalinfo(country_name = "Hungary",
                              site_name = "Kis-Balaton")
kb_id = kis_balaton$uri
kb_polygon = ReLTER::get_site_info(kb_id, "Boundaries")

# Now acquire landcover and NDVI from ODS
kb_landcover = ReLTER::get_site_ODS(kb_id, dataset = "landcover")
kb_ndvi_summer = ReLTER::get_site_ODS(kb_id, "ndvi_summer")


## ----adv-balaton-plot---------------------------------------------------------
# Plot maps
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(kb_polygon) +
  tm_borders(col = "purple") + 
  tm_shape(kb_ndvi_summer) +
  tm_raster(alpha=0.7, palette = "RdYlGn")


## ----adv-balaton-plot2--------------------------------------------------------
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(kb_polygon) +
  tm_borders(col = "purple") + 
  tm_shape(kb_landcover) +
  tm_raster(alpha=0.7, palette = "Set1")


## ----adv-companhia------------------------------------------------------------
lezirias <- ReLTER::get_ilter_generalinfo(country_name = "Portugal",
                              site_name = "Companhia")
lezirias_id = lezirias$uri
lezirias_polygon = ReLTER::get_site_info(lezirias_id, "Boundaries")

# Now acquire spring NDVI from OSD
lezirias_ndvi_spring = ReLTER::get_site_ODS(lezirias_id, "ndvi_spring")


## ----adv-companhia-plot-------------------------------------------------------
# Plot maps
tmap::tm_basemap("OpenStreetMap.Mapnik") + 
  tmap::tm_shape(lezirias_polygon) +
  tmap::tm_borders(col = "purple") + 
  tmap::tm_shape(lezirias_ndvi_spring) +
  tmap::tm_raster(alpha=0.7, palette = "RdYlGn")


## ----adv-save-----------------------------------------------------------------
class(lezirias_ndvi_spring)
terra::writeRaster(x = lezirias_ndvi_spring,
            filename = "lezirias_ndvi_spring.tif",
            overwrite = TRUE)

##------------------------------------------------------------------------------
## Additional metadata
##------------------------------------------------------------------------------

## ----research-topics----------------------------------------------------------
lter_slovakia_id <- "https://deims.org/networks/3d6a8d72-9f86-4082-ad56-a361b4cdc8a0"
slv_research_topics <- ReLTER::get_network_research_topics(lter_slovakia_id)
ecosystem_items <- grepl(pattern = "ecosystem",
                         slv_research_topics$researchTopicsLabel,
                         fixed = TRUE)
# Here is the filtered list
print(slv_research_topics[ecosystem_items,])


## ----related-resources--------------------------------------------------------
print(get_network_related_resources(lter_slovakia_id))


##------------------------------------------------------------------------------
## Coming soon....
##------------------------------------------------------------------------------

## ----adv-GOF, warning=FALSE, message=FALSE, eval=FALSE------------------------
## # DEIMS.iD of eLTER site Gulf Of Venice (GOV)
## GOVid <- "https://deims.org/758087d7-231f-4f07-bd7e-6922e0c283fd"
## resGOV <- ReLTER::get_site_speciesOccurrences(
##        deimsid = GOVid,
##        list_DS = "obis", show_map = TRUE, limit = 10)


## ----Saldur, warning=FALSE, message=FALSE, eval=FALSE-------------------------
## # DEIMS.iD of eLTER the Saldur River Catchment site
## saldur_id <- "https://deims.org/97ff6180-e5d1-45f2-a559-8a7872eb26b1"
## occ_SRC <- ReLTER::get_site_speciesOccurrences(
##        deimsid = saldur_id,
##        list_DS = c("gbif", "inat"), show_map = TRUE, limit = 100)


## ----export, warning=FALSE, message=FALSE, eval=FALSE-------------------------
## library(dplyr)
## saldurid <- "https://deims.org/97ff6180-e5d1-45f2-a559-8a7872eb26b1"
## resSaldur <- ReLTER::get_site_speciesOccurrences(
##   deimsid = saldurid, list_DS = c("gbif", "inat"), show_map = FALSE, limit = 20,
##   exclude_inat_from_gbif = TRUE)
## # iNaturalist
## tblSaldur_inat <- tibble::as_tibble(resSaldur$inat)
## outInat <- tblSaldur_inat %>%
##   ReLTER::map_occ_inat2elter(deimsid = saldurid)
## ReLTER::save_occ_eLTER_reporting_Archive(outInat)


##------------------------------------------------------------------------------
## Additional network metadata
##------------------------------------------------------------------------------

## ----networkGenInfo-----------------------------------------------------------
listITAsites <- ReLTER::get_network_sites(
  networkDEIMSID =
    "https://deims.org/network/7fef6b73-e5cb-4cd2-b438-ed32eb1504b3"
)
ITAsites <- listITAsites[!grepl('^IT', listITAsites$title),]
print(ITAsites[1:10, ])

## ----networkMap---------------------------------------------------------------
sitesLago <- ITAsites[grepl("Lago", ITAsites$title),]
# Subset just a few
sitesLago <- sitesLago[c(1,21),]

allSiteContact <- lapply(as.list(sitesLago$uri),
                         function(i) {
                           siteContact <- ReLTER::get_site_info(i, category = "Contacts")
                           print(siteContact$generalInfo.siteManager[[1]]$name)
                           print(siteContact$generalInfo.siteManager[[1]]$email)
                         })

## ----adv-greece-network-------------------------------------------------------
lter_greece_id = "https://deims.org/networks/83453a6c-792d-4549-9dbb-c17ced2e0cc3"
lter_greece <- ReLTER::produce_network_points_map(
  networkDEIMSID = lter_greece_id,
  countryCode = "GRC")

## ----adv-greece-plot----------------------------------------------------------
grc <- readRDS("gadm36_GRC_0_sp.rds")  # available from `produce_network_points_map()

tmap::tm_shape(grc) +
  tmap::tm_borders(col = "purple", lwd = 2) +
  tmap::tm_grid(alpha = 0.4) +
  lter_greece


##------------------------------------------------------------------------------
## Docker option
##------------------------------------------------------------------------------

## Docker
## docker pull ptagliolato/rocker_relter


## docker run -e PASSWORD=yourpassword -p 8080:8787 \

##   ptagliolato/rocker_relter


## docker pull ptagliolato/rocker_relter:dev__withImprovements

## 
## docker run -e PASSWORD=yourpassword -p 8080:8787 \

##   ptagliolato/rocker_relter:dev__withImprovements


## docker run -d -v $(pwd):/home/rstudio -e PASSWORD=yourpassword \

##   -p 8080:8787 ptagliolato/rocker_relter

