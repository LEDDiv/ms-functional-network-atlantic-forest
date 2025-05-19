#' ----
#' title: atlantic forest functional network 
#' author: mauricio vancine
#' date: 19-05-2025
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(terra)
library(tmap)

# data --------------------------------------------------------------------

# import hexagons
hex <- terra::vect("01_data/03_vect/hex_sel.gpkg")
hex

# import sdm
sdm <- terra::rast("01_data/Ramphastos toco/03_05_pred_Ramphastos toco_af.tif")
sdm <- round(sdm, 2)
sdm

# map
plot(sdm)
plot(hex, add = TRUE)

# zonal
hex$ramphastos_toco <- terra::zonal(sdm, hex, fun = "median", na.rm = TRUE)
hex

tm_shape(hex) +
  tm_fill(fill = "ramphastos_toco",
          fill.scale = tm_scale_continuous(values = "-spectral"),
          fill.legend = tm_legend(
            position = tm_pos_auto_in()))

