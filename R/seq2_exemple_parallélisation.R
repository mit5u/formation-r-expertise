# Définir la fonction de calcul
calc_sum_of_squares <- function(n) {
  return(sum((1:n)^2))
}

# Créer un vecteur de valeurs n
n_values <- 1:150000

# Approche séquentielle

results_sequential <- quote({
  lapply(n_values, FUN = calc_sum_of_squares)
})


# Approche parallèle avec future.apply

results_parallel <- quote({
  future.apply::future_lapply(n_values, FUN = calc_sum_of_squares)
})


# Comparer les temps d'exécution

resultats <- bench::mark( # /!\ quelques minutes d'exécution
  sequentiel = eval(results_sequential),
  parrallel = eval(results_parallel),
  check = FALSE
)

# Afficher les noms des expressions dans le tibble de résultats
resultats$expression <- c("séquentiel", "parallèle")

# Afficher les résultats
print(resultats)
