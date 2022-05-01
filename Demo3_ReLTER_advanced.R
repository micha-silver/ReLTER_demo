## ----adv-packages, message=FALSE, warning=FALSE--------------------------------------
pkg_list <- c("sf", "terra", "ReLTER", "tmap")
lapply(pkg_list, require, character.only = TRUE)
tmap_options(check.and.fix = TRUE)
tmap_mode("view")


## ----adv-missing---------------------------------------------------------------------
# Multiple sites in the KISKUN region of Hungary
kiskun <- get_ilter_generalinfo(country_name = "Hungary",
                              site_name = "KISKUN")
# How many sites?
print(paste("In Kiskun region: ", length(kiskun$title), "sites"))


## ----adv-missing2--------------------------------------------------------------------
(kiskun$title)
# Which site? Bugac-Bocsa
bugac_id <- kiskun[7,]$uri
bugac_details <- get_site_info(bugac_id,"Contacts")
(bugac_details$generalInfo.siteManager[[1]]['name'])


## ----adv-missing-boundary------------------------------------------------------------
bugac_polygon <- get_site_info(bugac_id, "Boundaries")
str(bugac_polygon)
# No geometry


## ----adv-paradiso--------------------------------------------------------------------
paradiso <- get_ilter_generalinfo(country_name = "Italy",
                              site_name = "Gran Paradiso")
(paradiso$title)

# Choose the second
paradiso_id <- paradiso[2,]$uri
paradiso_details <- get_site_info(paradiso_id,"Contacts")
# Multiple names for metadata:
paradiso_details$generalInfo.metadataProvider[[1]]['name']


## ----adv-paradiso-info---------------------------------------------------------------
# But what about funding agency
paradiso_details$generalInfo.fundingAgency


## ----adv-balaton-ods-----------------------------------------------------------------
# Get DEIMS ID for Kis-Balaton site 
kis_balaton <- get_ilter_generalinfo(country_name = "Hungary",
                              site_name = "Kis-Balaton")
kb_id = kis_balaton$uri
kb_polygon = get_site_info(kb_id, "Boundaries")

# Now acquire landcover and NDVI from ODS
kb_landcover = get_site_ODS(kb_id, dataset = "landcover")
kb_ndvi_summer = get_site_ODS(kb_id, "ndvi_summer")


## ----adv-balaton-plot----------------------------------------------------------------
# Plot maps
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(kb_polygon) +
  tm_borders(col = "purple") + 
  tm_shape(kb_ndvi_summer) +
  tm_raster(alpha=0.7, palette = "RdYlGn")


## ----adv-balaton-plot2---------------------------------------------------------------
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(kb_polygon) +
  tm_borders(col = "purple") + 
  tm_shape(kb_landcover) +
  tm_raster(alpha=0.7, palette = "Set1")


## ----adv-companhia-------------------------------------------------------------------
lezirias <- get_ilter_generalinfo(country_name = "Portugal",
                              site_name = "Companhia")
lezirias_id = lezirias$uri
lezirias_polygon = get_site_info(lezirias_id, "Boundaries")

# Now acquire spring NDVI from OSD
lezirias_ndvi_spring = get_site_ODS(lezirias_id, "ndvi_spring")


## ----adv-companhia-plot--------------------------------------------------------------
# Plot maps
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(lezirias_polygon) +
  tm_borders(col = "purple") + 
  tm_shape(lezirias_ndvi_spring) +
  tm_raster(alpha=0.7, palette = "RdYlGn")


## ----adv-save------------------------------------------------------------------------
class(lezirias_ndvi_spring)
writeRaster(x = lezirias_ndvi_spring,
            filename = "lezirias_ndvi_spring.tif",
            overwrite = TRUE)


## ----adv-pie-params, warning=FALSE, message=FALSE------------------------------------
produce_site_parameters_pie(kb_id)


## ----adv-waffle-params, warning=FALSE, message=FALSE---------------------------------
produce_site_parameters_waffle(kb_id)


## ----adv-greece-network--------------------------------------------------------------
lter_greece_id = "https://deims.org/networks/83453a6c-792d-4549-9dbb-c17ced2e0cc3"
lter_greece <- produce_network_points_map(lter_greece_id, "GRC")
grc <- readRDS("gadm36_GRC_0_sp.rds")  # available from `produce_network_points_map()


## ----adv-greece-plot-----------------------------------------------------------------
tm_basemap("OpenStreetMap.Mapnik") + 
  tm_shape(lter_greece) + 
  tm_dots(col = "blue", size=0.08) +
  tm_shape(grc) + 
  tm_borders(col = "purple", lwd=2) +
  tm_grid(alpha = 0.4) +
  tm_scale_bar(position = c("right", "bottom"))

