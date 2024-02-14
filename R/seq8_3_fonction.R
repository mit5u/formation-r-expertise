# Filtrer l'ensemble des transactions sur une période donnée pour des départements choisis

# Input : un dataframe, un ensemble de départements à étudier
# et une année (entier)
# Output : un dataframe contenant les informations filtrées

filtrer_transaction_dpt <- function(data, liste_deps, annee = 2016) {
  
  # Filtrer le dataframe en fonction des départements spécifiés
  data_filtre <- data %>%
    filter(coddep %in% {{liste_deps}})
  
  # Filtrer sur les années >= à l'argument annee
  data_annee <- data_filtre %>%
    filter(anneemut >= annee)
  
  # Renvoyer le dataframe filtré
  return(data_annee)
}

# Transactions en Lorraine après 2016
# appel explicite
# filtrer_transaction_dpt(dvf_GE_mut, "54", "55", "57", "88")
filtrer_transaction_dpt(dvf_GE_mut, liste_deps = c("54", "55", "57", "88"))
# utilisation de la liste
filtrer_transaction_dpt(dvf_GE_mut, departements_lorrains, annee = 2018)
