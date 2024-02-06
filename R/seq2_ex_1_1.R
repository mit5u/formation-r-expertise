donnees_naissance <- telechargerDonnees("NAISSANCES_COM_1019", telDir = PATH_DOREMIFASOL)

# Extraire les deux premiers chiffres du code géographique et les placer
# dans une nouvelle colonne appelée code_geo_reduit
## proposition de code n°1 ----
code_geo_rs <- c()
for (x in donnees_naissance[['CODGEO']]){
  code_geo_r = substr(x,1,2)
  code_geo_rs[[length(code_geo_rs)+1]] <- code_geo_r
}

donnees_naissance$code_geo_reduit <- code_geo_rs

## proposition plus efficace ----

donnees_naissance %>% 
  mutate(code_geo_reduit = str_sub(CODGEO, 1, 2))


## comparaison des temps d'exécution ----
## en comparant les codes copiés-collés
bench::mark(
  code_1 = {
    code_geo_rs <- c()
    for (x in donnees_naissance[['CODGEO']]){
      code_geo_r = substr(x, 1, 2)
      code_geo_rs[[length(code_geo_rs) + 1]] <- code_geo_r
    }
    unlist(code_geo_rs)
  },
  code_2 = {
    donnees_naissance %>% 
      mutate(code_geo_reduit = str_sub(CODGEO, 1, 2)) %>% 
      pull(code_geo_reduit)
  },
  code_3 = {
    donnees_naissance %>% 
      mutate(code_geo_reduit = substr(CODGEO, 1, 2)) %>% 
      pull()
  }
)

## en définissant des expressions à évaluer

code_1 <-  quote({
  code_geo_rs <- c()
  for (x in donnees_naissance[['CODGEO']]){
    code_geo_r = substr(x, 1, 2)
    code_geo_rs[[length(code_geo_rs) + 1]] <- code_geo_r
  }
  unlist(code_geo_rs)
})
code_2 <- quote({
  donnees_naissance %>% 
    mutate(code_geo_reduit = str_sub(CODGEO, 1, 2)) %>% 
    pull(code_geo_reduit)
})

bench::mark(
  boucle_naive = eval(code_1),
  fonction_vectorisee = eval(code_2)
)


