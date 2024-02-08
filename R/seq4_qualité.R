
# Justesse du code --------------------------------------------------------

# Import des données
naissances1019 <- telechargerDonnees("NAISSANCES_COM_1019", telDir = PATH_DOREMIFASOL)

# Sélection des lignes avec un CODGEO strictement inférieur à 2000
naissances_CODGEO_moins_2000 <- naissances1019 %>%
  # filter(as.numeric(CODGEO) < 2000) # introduit des NA sur les CODGEO de Corse
  # filter(CODGEO < "02000") # un peu crade mais fonctionne
  filter(substr(CODGEO, 1, 2) == "01") # au moins c'est clair

naissances_CODGEO_moins_2000 %>% 
  arrange(desc(CODGEO)) %>% 
  slice(1) %>% # le plus grand est 01457, c'est bien inférieur à 2000
  pull(CODGEO) < 2000 # le test


# Robustesse du code ------------------------------------------------------
make_histogram_compar <- function(df, codgeo = "CODGEO", var_comp = "NAISD", year1, year2) {
  var_a_garder <- c(codgeo, paste0(var_comp, c(str_sub(year1, -2),
                                               str_sub(year2, -2))
  ))
  
  df %>% 
    select(all_of(var_a_garder)) %>% 
    # si une variable est numérique, on regarde si on a eu plus de 10 naissances
    mutate(across(where(is.numeric), function(x) (x > 10))) %>% 
    pivot_longer(cols = setdiff(var_a_garder, codgeo), names_to = "annee_naissance", values_to = "plus_de_10") %>%
    # on considère que les NA sont inférieurs à 10
    replace_na(list(plus_de_10 = FALSE)) %>%
    # représentation graphique
    ggplot(aes(x = plus_de_10)) +
    geom_histogram(stat = "count") +
    facet_grid(~annee_naissance)
  # //TODO : afficher le vrai nom des variables (NAISD_17 et non NAISD "indice" 17)
  # (les labels des facettes interprètent le _ du nom de variable)
}

naissances1019 %>% 
  make_histogram_compar(year1 = 2016, year2 = 2017)
naissances1019 %>% 
  make_histogram_compar(codgeo = "CODGEO", var_comp = "NAISD",
                        year1 = 2018, year = 2019)

# Robustesse - exercice ---------------------------------------------------

# Objectif du code : trouver les 10 communes (hors de Paris)
# avec le plus de naissances. Afficher dans un tableau

naissances1019 %>% 
  filter(str_sub(CODGEO, 1 ,2) != "75") %>% 
  # rowwise() %>% 
  # mutate(tot_NAIS = sum(c_across(starts_with("NAISD")), na.rm = TRUE)) %>% # avec rowwise(), bcp plus lent
  mutate(tot_NAIS = rowSums(across(starts_with("NAISD")))) %>%
  select(CODGEO, tot_NAIS) %>% 
  arrange(desc(tot_NAIS)) %>% 
  slice(1:10)

# tic()
# villes_nb_naissances <- data.frame(
#   CODGEO = NULL,
#   NB_NAIS = NULL
# )
# 
# paris <- c("75101", "75102", "75103", "75104", "75105",
#            "75106", "75107", "75108", "75109", "75110",
#            "75111", "75112", "75113", "75114", "75115",
#            "75116", "75117", "75118", "75119", "75120",
#            "75056")
# 
# for (id in naissances1019$CODGEO){ # c'est un banger tellement c'est lent lol
#   if (id %in% paris){
#     next
#   }
#   else {
#     CODGEO <- id
#     NB_NAIS <- naissances1019$NAISD10[naissances1019$CODGEO == id] +
#       naissances1019$NAISD11[naissances1019$CODGEO == id] +
#       naissances1019$NAISD12[naissances1019$CODGEO == id] +
#       naissances1019$NAISD13[naissances1019$CODGEO == id] +
#       naissances1019$NAISD14[naissances1019$CODGEO == id] +
#       naissances1019$NAISD15[naissances1019$CODGEO == id] +
#       naissances1019$NAISD16[naissances1019$CODGEO == id] +
#       naissances1019$NAISD17[naissances1019$CODGEO == id] +
#       naissances1019$NAISD18[naissances1019$CODGEO == id] +
#       naissances1019$NAISD19[naissances1019$CODGEO == id]
#     villes_nb_naissances <- villes_nb_naissances %>%
#       rbind(c(CODGEO, NB_NAIS))
#   }
# }
# 
# colnames(villes_nb_naissances) <- c("CODGEO", "NB_NAIS")
# villes_triees <- villes_nb_naissances %>% 
#   mutate(NB_NAIS = as.numeric(NB_NAIS)) %>% 
#   arrange(desc(NB_NAIS))
# 
# villes_top_10 <- villes_triees %>%
#   slice_head(n = 10)
# 
# villes_top_10
# toc()


# Efficacité du code ------------------------------------------------------


