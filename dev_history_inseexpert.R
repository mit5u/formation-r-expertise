#### Historique du développement du package bac à sable "inseexpert" ####

# 0. Création du package
# File > New Project > New Directory > R Package using devtools

# 1. Modification du fichier DESCRIPTION
file.edit("DESCRIPTION")

# 2. Choix de la licence
usethis::use_mit_license()

# - crée LICENSE et LICENSE.md
# - ajoute LICENSE.md au .Rbuildignore
# - modifie le champ LICENSE dans le fichier DESCRIPTION

# 3. Vérifications sur le package (à lancer autant que nécessaire)
devtools::check()

# - crée le dossier man (vide pour l'instant car on n'a pas de fonctions à documenter)
# - crée un fichier sous /tmp/.../inseexpert.Rcheck/00check.log
# pour décrire les vérifications faites et leurs conclusions
# - affiche une note : fichier non standard détecté (dev_history.R) => à exclure du build
# (voir 4.; Exclusion de fichiers)

# 4. Exclusion de fichiers
usethis::use_build_ignore("dev_history.R")

# 5. Ajout d'une fonction qui calcule l'indice de Herfindahl-Hirschmann
usethis::use_r("calculer_hhi")

# 6. Ajout de la documentation pour la fonction précédente
file.edit("R/calculer_hhi.R") # CTRL+ALT+MAJ+R pour générer le squelette roxygen
devtools::document() # pour créer la page .md correspondante dans le répertoire man

# 7. Ajout de la dépendance au package "stats"
usethis::use_package("stats", type = "Imports")

# - ajoute la ligne stats dans le champ Imports du fichier DESCRIPTION
# - permet d'appeler les fonctions avec stats::nom_fonction()

# 8. Ajout du pré-requis sur la version minimale de R
usethis::use_package("R", type = "Depends", min_version = "4.0")

# 9. exercice : ajouter une fonction
usethis::use_r("calculer_variations")

# 10. exercice : ajouter des données
usethis::use_data_raw("inseexpert_data") # exécuter le script pour créer
# les données : le fichier .Rbuildignore est alors mis à jour pour exclure le dossier data-raw
# Il est recommandé de documenter les données
devtools::load_all()
devtools::check() # 1 warning : objet non documenté

file.edit("R/data.R")
devtools::check() # ok :)

# 11. mise en place du framework de testing
usethis::use_testthat(3)
usethis::use_test("calculer_hhi")

# 12. Ajout de la fonction de production de Cobb-Douglas
usethis::use_r("cobb_douglas_production")
usethis::use_test("cobb_douglas_production")
devtools::check()
usethis::use_package("rlang", type = "Suggests")

# 13. exercice : Ajout de la fonction calculer_propension_moyenne_consommer
usethis::use_r("calculer_propension_moyenne_consommer")
usethis::use_test("calculer_propension_moyenne_consommer")
usethis::use_package("glue", type = "Imports")

devtools::check() # 1 warning : caractères non ASCII détectés
tools::showNonASCIIfile("R/calculer_propension_moyenne_consommer.R")
# identifier les éléments qui soulèvent le warning dans le fichier mis en cause
# stringi::stri_escape_unicode(c("à", "é"))
# ou écrire en anglais pour ne pas avoir d'accents...
file.edit("R/calculer_propension_moyenne_consommer.R")
devtools::check()
