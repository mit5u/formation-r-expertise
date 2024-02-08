naissances1019 <- telechargerDonnees("NAISSANCES_COM_1019", telDir = PATH_DOREMIFASOL)

# Définition des fonctions ----

# Fonction rowSums à laquelle on ajoute une attente de 1 seconde pour allonger artificiellement l'exécution
long_rowSums <- function(...){
  Sys.sleep(1)
  rowSums(...)
}

# df désigne ici le dataframe contenant les données
# cette fonction retourne le dataframe df privé des lignes pour lesquelles la somme des naissances est inférieure à 100
# et trie le dataframe selon le nombre de naissances
filtrer_moins_100 <- function(df){
  
  df_moins_100 <- df %>%
    mutate(nb_naissances = long_rowSums(.[-1], na.rm=TRUE)) %>%
    filter(nb_naissances < 100) %>%
    arrange(nb_naissances)
  
  
  return(df_moins_100)
}

# profilage avec Rprof() ----

Rprof("Rprof.out", memory.profiling = TRUE)

naissances_moins_100_profilage <- naissances1019 %>%
  filtrer_moins_100(.)

Rprof(NULL)

summaryRprof("Rprof.out", memory = "none")


# profilage avec profvis::profvis() ----

profvis::profvis({

  naissances_moins_100_profilage <- naissances1019 %>%
    filtrer_moins_100(.)

})
