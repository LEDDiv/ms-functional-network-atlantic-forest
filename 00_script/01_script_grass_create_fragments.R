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

# install addon
rgrass::execGRASS(cmd = "g.extension", flags = "a")

# forest and vegetation na
rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_af_trinacional_2023_forest_na = if(mapbiomas_brazil_af_trinacional_2023_forest == 1, 1, null())")

rgrass::execGRASS(cmd = "r.mapcalc",
                  flags = "overwrite",
                  expression = "mapbiomas_brazil_af_trinacional_2023_natural_na = if(mapbiomas_brazil_af_trinacional_2023_natural == 1, 1, null())")

# patches
rgrass::execGRASS(cmd = "r.clump",
                  flags = c("d", "overwrite"),
                  input = "mapbiomas_brazil_af_trinacional_2023_forest_na",
                  output = "mapbiomas_brazil_af_trinacional_2023_forest_na_patches")

rgrass::execGRASS(cmd = "r.clump",
                  flags = c("d", "overwrite"),
                  input = "mapbiomas_brazil_af_trinacional_2023_natural_na",
                  output = "mapbiomas_brazil_af_trinacional_2023_natural_na_patches")

# area
rgrass::execGRASS(cmd = "r.area",
                  flags = "overwrite",
                  input = "mapbiomas_brazil_af_trinacional_2023_forest_na_patches",
                  output = "mapbiomas_brazil_af_trinacional_2023_forest_na_patches_area")

rgrass::execGRASS(cmd = "r.area",
                  flags = "overwrite",
                  input = "mapbiomas_brazil_af_trinacional_2023_natural_na_patches",
                  output = "mapbiomas_brazil_af_trinacional_2023_natural_na_patches_area")

# export
rgrass::execGRASS(cmd = "r.out.gdal", 
                  flags = "overwrite", 
                  input = "mapbiomas_brazil_af_trinacional_2023_forest_na_patches",
                  output = "01_data/mapbiomas_brazil_af_trinacional_2023_forest_na_patches.tif",
                  format = "GTiff",
                  createopt = "COMPRESS=DEFLATE,ZLEVEL=9,TILED=YES")

rgrass::execGRASS(cmd = "r.out.gdal", 
                  flags = "overwrite", 
                  input = "mapbiomas_brazil_af_trinacional_2023_forest_na_patches_area",
                  output = "01_data/mapbiomas_brazil_af_trinacional_2023_forest_na_patches_area.tif",
                  format = "GTiff",
                  createopt = "COMPRESS=DEFLATE,ZLEVEL=9,TILED=YES")

rgrass::execGRASS(cmd = "r.out.gdal", 
                  flags = "overwrite", 
                  input = "mapbiomas_brazil_af_trinacional_2023_natural_na_patches",
                  output = "01_data/mapbiomas_brazil_af_trinacional_2023_natural_na_patches.tif",
                  format = "GTiff",
                  createopt = "COMPRESS=DEFLATE,ZLEVEL=9,TILED=YES")

rgrass::execGRASS(cmd = "r.out.gdal", 
                  flags = "overwrite", 
                  input = "mapbiomas_brazil_af_trinacional_2023_natural_na_patches_area",
                  output = "01_data/mapbiomas_brazil_af_trinacional_2023_natural_na_patches_area.tif",
                  format = "GTiff",
                  createopt = "COMPRESS=DEFLATE,ZLEVEL=9,TILED=YES")

# end ---------------------------------------------------------------------
