## ----setup1, include=FALSE-----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----packages, message=FALSE---------------------------------------------------------
# Install some standard spatial packages from CRAN
if (!require("sf", quietly = TRUE))
  install.packages("sf")
if (!require("terra", quietly = TRUE))
  install.packages("terra")

# package from Bioconductor
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()
BiocManager::install("EBImage")


## ----from-github---------------------------------------------------------------------
# Install development package from github
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")

if (!require("ReLTER", quietly = TRUE))
  remotes::install_github("ropensci/ReLTER")


## ----loading-------------------------------------------------------------------------
# Convenient way to load list of packages
pkg_list <- c("sf", "terra", "ReLTER", "tmap")
lapply(pkg_list, require, character.only = TRUE)


## ----spatial-packages----------------------------------------------------------------
remotes::install_github("rspatial/geodata")
library(geodata)
slv <- gadm("Slovakia", level=2, path=tempdir())
# Convert to `sf` for plotting
slv <- st_as_sf(slv)
slv_precip <- worldclim_country("Slovakia",
                                var = "prec", path = tempdir())


## ----slovakia-map--------------------------------------------------------------------
# Use OpenStreetMaps as background
tm_basemap("OpenStreetMap.Mapnik") +
  tm_shape(slv) +
  tm_borders(col = "purple", lwd = 2) +
  tm_shape(slv_precip$SVK_wc2.1_30s_prec_1) +
  tm_raster(palette = "YlGnBu", alpha=0.7)


## ----slovakia-map2-------------------------------------------------------------------
tm_basemap("OpenStreetMap.Mapnik") +
  tm_shape(slv) +
  tm_borders(col = "purple", lwd = 2) +
  tm_shape(slv_precip$SVK_wc2.1_30s_prec_8) +
  tm_raster(palette = "YlGnBu", alpha=0.7)

