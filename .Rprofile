
library(arrow)
library(pryr)
library(doremifasol)
library(fs)
library(glue)
library(duckdb)
library(RPostgres)
library(assertthat)
library(tidyverse)

conflicted::conflict_prefer("filter", "dplyr")


PATH_DATA <- "data"
PATH_INPUT <- file.path(PATH_DATA, "input")
PATH_FINAL <- file.path(PATH_DATA, "final")
PATH_DOREMIFASOL <- file.path(PATH_INPUT, "doremifasol")
PATH_DVF <- file.path(PATH_INPUT, "dvf")

# load(file = file.path(PATH_FINAL, "revenus_boxplot.RData"))
# source("dev/make_data.R", encoding = "UTF-8") # ~7sec à chaque redémarrage
