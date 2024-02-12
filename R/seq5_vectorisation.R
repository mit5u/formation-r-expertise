# vectoriser ----
# Calculez la somme cumulée pour chaque variable
sum_cum_pop <- function(data) {
  nb_lignes <- nrow(data)
  pop_sum_cum_2016 <- data[1, "population_2016"]
  pop_sum_cum_2017 <- data[1, "population_2017"]
  for (i in 2:nb_lignes) {
    pop_sum_cum_2016 <- pop_sum_cum_2016 + data[i, "population_2016"]
    pop_sum_cum_2017 <- pop_sum_cum_2017 + data[i, "population_2017"]
  }
  return(c(
    "population_2016" = pop_sum_cum_2016, 
    "population_2017" = pop_sum_cum_2017))
}

# version vectorisée ----
sum_cum_pop_vec <- function(data) {
  data %>% 
    summarise(population_2016 = sum(population_2016),
              population_2017 = sum(population_2017))
}

# jeu de données de test ----
set.seed(123)
data <- data.frame(
  population_2016 = rnorm(100, mean = 50000, sd = 10000),
  population_2017 = rnorm(100, mean = 50000, sd = 10000)
)
bench::mark(
  code_initial = {sum_cum_pop(data)},
  code_vectorise = {sum_cum_pop_vec(data)},
  check = FALSE # vecteur nommé vs tibble => outputs pas identiques
  )
