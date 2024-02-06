load(file = file.path(PATH_FINAL, "revenus_boxplot.RData"))

calculer_stat <- function(data, ...) {
  dots <- rlang::list2(...)
  
  revenus_dep_2014 %>% 
    reframe(across(where(is.numeric), dots)) %>% 
    # comment suffixer les variables avec la fonction-résumé utilisée ?
    pivot_longer(cols = everything(),
                 names_to = "variable",
                 values_to = "valeur")
}

calculer_stat(revenus_dep_2014, min, max, median)
calculer_stat(revenus_dep_2014, sd, var, min)
