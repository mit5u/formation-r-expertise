library(tidyverse)
library(glue)


# Exercice 2.1 ------------------------------------------------------------
## Créer une fonction qui calcule la moyenne de la part d’imposition (PIMP14)
# des départements dont le revenu médian (MED14) fait partie des plus élevés.
# Le pourcentage de départements à considérer est un argument dont la valeur
# par défaut est 50%.

f <- function(prop_dep = .5) {
  revenus_dep_2014 %>% 
    filter(MED14 > quantile(MED14, prop_dep)) %>% # alternative ci-dessous :
    #   slice_max(MED14, prop = prop_dep) %>% 
    summarise(mean(PIMP14))
}
f()


# Exercice 2.2 ------------------------------------------------------------
## Créer une fonction prenant en compte un nombre arbitraire d’arguments et
# qui calcule le nombre total de personnes composant les ménages fiscaux
# (NBPERSMENFISC14) des départements (LIBGEO) utilisés comme arguments lors de
# l’appel de la fonction.

f2 <- function(...) { # en entrée, une liste de LIBGEO de longueur arbitraire
  # dots <- c(...) # sans les !!!, la fonction renvoie 0 avec list() ou list2()
  # mais le résultat est ok avec c() sans !!!
  dots <- rlang::list2(...)
  
  revenus_dep_2014 %>% 
    filter(LIBGEO %in% dots) %>% 
    summarise(sum(NBPERSMENFISC14, na.rm = TRUE))
}

f2("Ain")
f2("Ain", "Aisne", "Allier")

## Calculer le nombre total de personnes composant les ménages fiscaux des
# départements d’outre-mer présents dans la base de données.

libgeo_dom <- revenus_dep_2014 %>% filter(str_detect(CODGEO, "^97")) %>% pull(LIBGEO)
f2(!!!libgeo_dom)


# Exercice 2.3 ------------------------------------------------------------
## Créer une liste contenant tous les noms des départements métropolitains
# en utilisant la colonne LIBGEO de la base de données revenus_dep_2014.

libgeo_fm <- revenus_dep_2014 %>% 
  filter(!str_detect(CODGEO, "^97")) %>% 
  pull(LIBGEO)

f2(!!!libgeo_fm)

## Vérifier que les sommes calculées des résidents fiscaux d’outre-mer et
# métropolitains sont cohérentes.

identical(f2(libgeo_fm) + f2(libgeo_dom),
          f2(revenus_dep_2014$LIBGEO))


# Exercice 2.6 ------------------------------------------------------------
## Créer une infix function permettant de comparer le taux de pauvreté (TP6014)
# de deux départements donnés

`%compare_pauvrete%` <- function(dep1, dep2) {
  tx_pauv_dep1 <- revenus_dep_2014 %>%
    filter(LIBGEO %in% dep1) %>% 
    pull(TP6014)
  tx_pauv_dep2 <- revenus_dep_2014 %>%
    filter(LIBGEO %in% dep2) %>% 
    pull(TP6014)

  msg <- case_when(tx_pauv_dep1 > tx_pauv_dep2 ~ glue("{dep1} a un taux de
                                                      pauvreté plus élevé que
                                                      {dep2}."),
            tx_pauv_dep1 < tx_pauv_dep2 ~ glue("{dep1} a un taux de pauvreté
                                               plus faible que {dep2}."),
            tx_pauv_dep1 == tx_pauv_dep2 ~ glue("{dep1} et {dep2} ont le même
                                                taux de pauvreté."),
            TRUE ~ glue("Pas de comparaison possible entre les taux de pauvreté
                        départementaux pour {dep1} et {dep2}."))
  message(msg)
}

"Puy-de-Dôme" %compare_pauvrete% "Ain" # >
"Puy-de-Dôme" %compare_pauvrete% "Allier" # <
"Puy-de-Dôme" %compare_pauvrete% "Puy-de-Dôme" # =
