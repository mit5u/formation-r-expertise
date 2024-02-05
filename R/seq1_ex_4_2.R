calculer_stat <- function(data, ...) {
  dots <- list(...)
  
  revenus_dep_2014 %>% 
    summarise(across(where(is.numeric), dots)) %>% 
    pivot_longer(cols = everything(),
                 names_to = "variable",
                 values_to = "valeur")
}

calculer_stat(revenus_dep_2014, min, max, median)
calculer_stat(revenus_dep_2014, sd, var, min)
