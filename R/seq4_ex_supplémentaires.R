naissances1019 <- telechargerDonnees("NAISSANCES_COM_1019", telDir = PATH_DOREMIFASOL)

# Calcul du nombre de naissances entre 2010 et 2015 dans un département donné ----

nb_nais_dep <- function(df, dep) {
  df %>% 
    mutate(DEP = str_sub(CODGEO, 1, 2)) %>% 
    select(DEP, CODGEO, matches("NAISD1[0-5]")) %>% 
    filter(DEP %in% dep) %>% 
    group_by(DEP) %>% 
    summarise(across(where(is.numeric), sum)) %>% 
    mutate(tot_nais = rowSums(across(where(is.numeric)))) %>% 
    select(DEP, tot_nais)
}
naissances1019 %>% 
  nb_nais_dep(c("01", "02", "03"))

# Déterminer dans un département les communes avec au moins 100 naissances entre 2010 et 2015 ----

filtrer_comm <- function(df, dep, year_start = 2010, year_end = 2015, seuil = 100) {
  # NAISSD entre year_start et year_end
  pattern <- paste0("NAISD[", str_sub(year_start, -2), str_sub(year_end, -2), "]")
  
  df %>% 
    mutate(DEP = str_sub(CODGEO, 1, 2)) %>% 
    filter(DEP %in% dep) %>% 
    mutate(tot_nais = rowSums(across(matches(pattern)))) %>% 
    filter(tot_nais >= seuil) %>% 
    select(CODGEO, matches(pattern))
}

# Sur un département
naissances1019 %>% 
  filtrer_comm(dep = "01")

# Sur un ensemble de départements
liste_dep = sprintf(fmt = "%02d", 1:3)
naissances1019 %>% 
  filtrer_comm(dep = liste_dep)

# Sur un ensemble de département, avec une table par département
map(liste_dep,  ~filtrer_comm(df = naissances1019, dep = .x)) %>% 
  set_names(liste_dep)

# Naissances totales par département ----

naissances1019 %>% 
  mutate(DEP = str_sub(CODGEO, 1, 2)) %>%
  # tranposition : les noms de variables sont une modalité d'une variable (l'année de référence)
  pivot_longer(cols = where(is.numeric), names_to = "annee", values_to = "naissances") %>% 
  group_by(DEP, annee) %>% 
  mutate(annee = paste0("20", str_sub(annee, -2))) %>% 
  # calcul du total par dep x annee
  summarise(sum_nais = sum(naissances)) %>%
  # calcul du total par dep (toutes années confondues)
  summarise(nais_tot = sum(sum_nais))
