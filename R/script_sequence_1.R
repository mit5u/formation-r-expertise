# Import packages ---------------------------------------------------------

library(tidyverse)
library(doremifasol)


# Parametrage -------------------------------------------------------------

PATH_DATA <- "data"
PATH_INPUT <- file.path(PATH_DATA, "input")
PATH_FINAL <- file.path(PATH_DATA, "final")


# Import donnees ----------------------------------------------------------

revenus_dep_2014 <- telechargerDonnees("FILOSOFI_DEP",
                                       date = 2014,
                                       telDir = PATH_INPUT)
head(revenus_dep_2014)


# boxplot -----------------------------------------------------------------
## 1.3
COULEUR_PRIMAIRE <- "#052337"
COULEUR_SECONDAIRE <- "#39eab9"

# Analyses ------------------------------

creer_boxplot <- function(data, colonne) {
  
  p <- ggplot(data, aes(x = 1, y = data[[colonne]])) +
    geom_boxplot(color = COULEUR_PRIMAIRE, fill = COULEUR_SECONDAIRE) +  
    geom_point(aes(y = median(data[[colonne]])), color = COULEUR_PRIMAIRE, size = 3) +  
    labs(title = paste("Boîte à moustaches de", colonne)) +
    theme_minimal()
  
  print(p)
}


creer_boxplot(revenus_dep_2014, "MED14")
# variables locales : data, colonne, p
# variables globales : creer_boxplot, COULEUR_PRIMAIRE, COULEUR_SECONDAIRE
# (cf ls())

## 1.5.1 ----
save(revenus_dep_2014, creer_boxplot, file = file.path(PATH_FINAL, "revenus_boxplot.RData"))

# /!\ par défaut, load() charge les objets dans l'environnement parent
# (et écrase ainsi les objets pré-existants de même nom, le cas échéant)

# my_env <- new.env()
# rm(creer_boxplot)
# load(file.path(PATH_FINAL, "revenus_boxplot.RData"), envir = my_env)
