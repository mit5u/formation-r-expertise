
# Exercice complémentaire séquence 2 ----
naissances1019 <- doremifasol::telechargerDonnees("NAISSANCES_COM_1019",
                                                  telDir = PATH_DOREMIFASOL)
## ----
# Créer une fonction R qui effectue une analyse statistique simple sur le
# dataframe naissance1019. Par exemple, vous pouvez calculer la moyenne,
# l’écart-type ou tout autre indicateur pertinent.

# compute_stats <- function(data, variable, ..., na.rm = TRUE) {
#   dots <- rlang::list2(...)
#   data %>% 
#     reframe(across(all_of(variable), dots, na.rm = na.rm))
# }
# compute_stats(naissances1019, c("NAISD10", "NAISD11" ), sd, mean, na.rm = TRUE)

compute_mean <- function(data, variable, na.rm = TRUE) {
  # data %>% 
  #   summarise(mean({{variable}}, na.rm = na.rm))
  # /!\ ko si on veut passer plusieurs colonnes avec future_lapply() ensuite
  mean(data[[variable]], na.rm = TRUE)
}
compute_mean(naissances1019, "NAISD10")

## ----
# spécifiez les noms des colonnes à analyser
columns_to_analyze <- c("NAISD10", "NAISD11", "NAISD12")

# Utilisez future_lapply pour appliquer la fonction en parallèle
parallel_means <- future.apply::future_lapply(eval(columns_to_analyze), FUN = compute_mean, data = naissances1019) %>% 
  set_names(glue::glue("{columns_to_analyze}_mean"))
parallel_means
