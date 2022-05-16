## ----setup, include = FALSE---------------------------------------------------
html_tag_audio <- function(file, type = c("wav")) {
  type <- match.arg(type)
  htmltools::tags$audio(
    controls = "",
    htmltools::tags$source(
      src = file,
      type = glue::glue("audio/{type}", type = type)
    )
  )
}


## ----relter-citation, message=FALSE, results='hide'---------------------------
citation("ReLTER")

## To cite the 'ReLTER' package in publications use:
##
##   Alessandro Oggioni, Micha Silver, Luigi Ranghetti & Paolo Tagliolato.
##   (2021). oggioniale/ReLTER: ReLTER v1.1.0 (1.1.0). Zenodo.
##   https://doi.org/10.5281/zenodo.5576813
##
## A BibTeX entry for LaTeX users is
##
##   @software{alessandro_oggioni_2021_5576813,
##   author       = {Alessandro Oggioni and Micha Silver and
##                   Luigi Ranghetti and Paolo Tagliolato},
##   title        = {ropensci/ReLTER: ReLTER v1.1.0},
##   year         = 2022,
##   publisher    = {Zenodo},
##   version      = {1.1.0},
##   doi          = {10.5281/zenodo.5576813},
##   url          = {https://doi.org/10.5281/zenodo.5576813}
## }


## ----relter-donana------------------------------------------------------------
donana <- ReLTER::get_ilter_generalinfo(country_name = "Spain",
                              site_name = "Doñana")
donana_id = donana$uri


## ----relter-plot-donana-------------------------------------------------------
donana_id <- "https://deims.org/bcbc866c-3f4f-47a8-bbbc-0a93df6de7b2"
donana_polygon <- ReLTER::get_site_info(donana_id, category = "Boundaries")
tm_basemap("OpenStreetMap.Mapnik") +
  tm_shape(donana_polygon) +
  tm_fill(col = "blue", alpha = 0.3)


## ----relter-kinord-info-------------------------------------------------------
loch_kinord_id <- "https://deims.org/9fa171d2-5a24-40d3-9c06-b3f9e9d0f270"
loch_kinord_details <- ReLTER::get_site_info(loch_kinord_id,
                                 c("Contacts", "EnvCharacts", "Parameters"))

print(paste("Site manager:",
            loch_kinord_details$generalInfo.siteManager[[1]]['name'],
            loch_kinord_details$generalInfo.siteManager[[1]]['email']))


## ----relter-kinord-metadata---------------------------------------------------
# Metadata contact:
(loch_kinord_details$generalInfo.metadataProvider[[1]]['name'])

glue("Average air temperature: ",
            loch_kinord_details$envCharacteristics.airTemperature.avg)
glue("Annual precipitation: ",
            loch_kinord_details$envCharacteristics.precipitation.annual)


## ----relter-kinord-geobonbiome------------------------------------------------
glue("GeoBonBiome:",
            loch_kinord_details$envCharacteristics.geoBonBiome[[1]])
# Parameters:
kable(head(loch_kinord_details$parameter[[1]], 12))


## ----rlter-related_resources--------------------------------------------------
tSiteRelatedResources <- ReLTER::get_site_info(
  deimsid = "https://deims.org/f30007c4-8a6e-4f11-ab87-569db54638fe",
  category = "RelateRes"
)
kable(tSiteRelatedResources$relatedResources[[1]])

