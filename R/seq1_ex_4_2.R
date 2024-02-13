load(file = file.path(PATH_FINAL, "revenus_boxplot.RData"))

calculer_stat <- function(data, ...) {
    dots <- rlang::dots_list(...,
                             .named = TRUE, # pour avoir en colonne le noms des fonctions correspondantes, plutôt qu'un numéro
                             .homonyms = "first")
    
    data %>%
        reframe(across(where(is.numeric),
                       dots)
        ) %>% 
        pivot_longer(cols = everything(),
                     names_to = c("variable", "stat"),
                     names_pattern = "(.*)_(.*)"
        ) %>% 
        pivot_wider(id_cols = everything(),
                    names_from = "stat",
                    values_from = "value")
}

calculer_stat(revenus_dep_2014, min, max, median)

# les fonctions custom peuvent être définies en amont
cv <- function(x, na.rm = TRUE) {
    sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}
revenus_dep_2014 %>% 
    calculer_stat(sd, sum, cv)
# on peut aussi utiliser des fonctions anonymes à la volée, mais le résultat sera laid :
revenus_dep_2014 %>% 
    calculer_stat(sd,
                  sum,
                  (\(x) return(sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)))
    )
