#' ----
#' title: atlantic forest functional network 
#' author: mauricio vancine
#' date: 12-05-2025
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(rgrass)
library(sf)
library(terra)

# mapbiomas ------------------------------------------------------------

# connect
rgrass::initGRASS(gisBase = system("grass --config path", inter = TRUE),
                  gisDbase = "01_data/01_grassdb",
                  location = "newProject",
                  mapset = "PERMANENT",
                  override = TRUE)

# import limit
rgrass::execGRASS("v.in.ogr",
                  flags = c("overwrite"),
                  input = "01_data/00_raw/limit_af_wwf_terr_ecos_biorregions_2017_gcs_wgs84.shp",
                  output = "af_lim")

# import mapbiomas brazil
rgrass::execGRASS("r.in.gdal",
                  flags = "overwrite",
                  input = "01_data/00_raw/brasil_coverage_2023.tif",
                  output = "mapbiomas_brazil_2023")

# import mapbiomas trinacional
rgrass::execGRASS("r.in.gdal",
                  flags = "overwrite",
                  input = "01_data/00_raw/mapbiomas_atlantic_forest_collection4_integration_v1-classification_2023.tif",
                  output = "mapbiomas_af_2023")

# merge mapbiomas brazil and trinacional
# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), res = "00:00:01",
                  n = "-21.83", s = "-29.04", e = "-53.52", w = "-58.33")

# mapcalc
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = paste0("mapbiomas_brazil_", i, "_e = if(mapbiomas_brazil_", i, "> 0, null(), 1)"))

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = paste0("mapbiomas_af_trinacional_", i, "_e = mapbiomas_af_trinacional_", i, "* mapbiomas_brazil_", i, "_e"))

# region
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), vector = "af_lim", res = "00:00:01")

# patch
rgrass::execGRASS(cmd = "r.patch",
                  flags = "overwrite",
                  input = paste0("mapbiomas_af_trinacional_", i, "_e,mapbiomas_brazil_", i),
                  output = paste0("mapbiomas_brazil_af_trinacional_", i))



# export
rgrass::execGRASS(cmd = "g.region", flags = c("a", "p"), raster = "mapbiomas_brazil_af_trinacional_1985", res = "00:00:01")
rgrass::execGRASS(cmd = "r.mask", flags = "overwrite", vector = "af_lim")

# end ---------------------------------------------------------------------
