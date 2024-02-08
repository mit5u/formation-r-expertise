
library(arrow)
library(pryr)
library(doremifasol)
library(fs)
library(glue)
library(duckdb)
library(tidyverse)

conflicted::conflict_prefer("filter", "dplyr")


PATH_DATA <- "data"
PATH_INPUT <- file.path(PATH_DATA, "input")
PATH_FINAL <- file.path(PATH_DATA, "final")
PATH_DOREMIFASOL <- file.path(PATH_INPUT, "doremifasol")

# load(file = file.path(PATH_FINAL, "revenus_boxplot.RData"))
