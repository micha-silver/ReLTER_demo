## ----beyond-load-packages, message=FALSE, warning=FALSE------------------------------
pkg_list <- c("sf", "terra", "ReLTER", "tmap")
lapply(pkg_list, require, character.only = TRUE)


## ----beyond-donana-------------------------------------------------------------------
donana = get_ilter_generalinfo(country_name = "Spain",
                              site_name = "Doñana")
donana_id = donana$uri
donana_polygon <- get_site_info(donana_id, category = "Boundaries")
donana_meta <-  get_site_info(donana_id,
                          c("Affiliations", "Contacts", "Parameters"))
# Get the Corine landcover from ODS
donana_clc <- get_site_ODS(donana_id, "clc2018")


## ----beyond-donana-saving------------------------------------------------------------
# For this demo, save to temporary directory
output_dir = tempdir()
saveRDS(donana_meta, file.path(output_dir, "Donana_metadat.Rds"))
# Remove extra columns from polygon
donana_polygon <- donana_polygon[,c("title", "boundaries", "geoCoord", "geoElev.avg")]
st_write(donana_polygon,
         file.path(output_dir, "donana_polygon.gpkg"), append=FALSE)
writeRaster(donana_clc,
            file.path(output_dir, "Donana_Corine2018.tif"),
            overwrite=TRUE)


## docker pull ptagliolato/rocker_relter


## docker run -e PASSWORD=yourpassword -p 8080:8787 \

##   ptagliolato/rocker_relter


## docker pull ptagliolato/rocker_relter:dev__withImprovements

## 

## docker run -e PASSWORD=yourpassword -p 8080:8787 \

##   ptagliolato/rocker_relter:dev__withImprovements


## docker run -d -v $(pwd):/home/rstudio -e PASSWORD=yourpassword \

##   -p 8080:8787 ptagliolato/rocker_relter


## ----get-paradiso--------------------------------------------------------------------
paradiso <- get_ilter_generalinfo(country_name = "Italy",
                                site_name = "Gran Paradiso")
paradiso_id <- paradiso[2,]$uri
paradiso_boundary <- get_site_info(paradiso_id, "Boundaries")


## ----get-srtm------------------------------------------------------------------------
# Get the geodata package
if (!require(geodata)) {
  install.packages("geodata", dependencies = TRUE)
  library(geodata)
}
italy_srtm <- elevation_3s(lon = 7.5, lat = 47.5, path = tempdir())
paradiso_srtm <- mask(crop(italy_srtm, vect(paradiso_boundary)),
                      vect(paradiso_boundary))
names(paradiso_srtm) <- "Elev"


## ----get-gbif------------------------------------------------------------------------
# Download data
ibex <- sp_occurrence("Capra", species = "ibex",
                            ext = ext(paradiso_boundary))
ibex <- ibex[,c("lon", "lat")]
ibex <- ibex[complete.cases(ibex),]
# Convert to `sf`
ibex_points <- st_as_sf(ibex, coords = c("lon", "lat"), crs = "EPSG:4326")


## ----correlation---------------------------------------------------------------------
ibex_elev <- extract(x = paradiso_srtm, y=vect(ibex_points))
ibex_points <- cbind(ibex_points, ibex_elev)
hist(ibex_points$Elev, breaks=20,
     main = "Distribution of Ibex sitings by elevation")


## ----ibex-plot-----------------------------------------------------------------------
# Create hillshade raster
slope <-  terrain(paradiso_srtm, "slope", unit = "radians")
aspect <-  terrain(paradiso_srtm, "aspect", unit="radians")
hill_shade = shade(slope, aspect, angle=35, direction = 310)


## ----ibex-plot2----------------------------------------------------------------------
tm_basemap("OpenStreetMap.Mapnik") +
  tm_shape(hill_shade) +
  tm_raster(alpha = 0.4, palette = "Greys",
            n=8, legend.show = FALSE) +
  tm_shape(paradiso_boundary) +
  tm_borders(col = "purple", lwd = 2) +
  tm_shape(ibex_points) + 
  tm_symbols(size=0.2, col = "red") 

