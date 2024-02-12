# base revenus filosofi ---- 
revenus_dep_2014 <- telechargerDonnees("FILOSOFI_DEP",
                                       date = 2014,
                                       telDir = PATH_INPUT)
# base naissances filosofi ----
naissances1019 <- telechargerDonnees("NAISSANCES_COM_1019", telDir = PATH_DOREMIFASOL)

# base revenus fictive ----
set.seed(123)
n <- 10000
revenus <- data.frame(
  id = 1:n,
  age = sample(18:60, n, replace = TRUE),
  genre = sample(c("Homme", "Femme"), n, replace = TRUE),
  revenu = rnorm(n, mean = 45000, sd = 15000),
  possede_permis = sample(c("oui", "non"), n, replace = TRUE),
  niveau_education = sample(c("Brevet", "Bac", "Bac +3", "Bac +5"), n, replace = TRUE),
  poids = runif(n, min = 50, max = 100)
)
# Définition d'une fonction pour générer un numéro de téléphone aléatoire dans un format donné
generer_numero_telephone <- function() {
  # Formats possibles pour le numéro de téléphone
  formats <- c("+336XXXXXXXX", "06XXXXXXXX", "06.XX.XX.XX.XX", "06 XX XX XX XX")
  
  # Choix d'un format aléatoire parmi les formats spécifiés
  format_aleatoire <- sample(formats, 1)
  
  # Remplacement des 'X' par des chiffres aléatoires
  while (str_detect(format_aleatoire, "X")) {
    format_aleatoire <- str_replace(format_aleatoire, "X", as.character(sample(0:9, 1)))
  }
  
  return(format_aleatoire)
}

# Génération d'un vecteur de 10000 numéros de téléphone aléatoires
numeros_telephone_aleatoires <- replicate(n, generer_numero_telephone())
revenus$telephone <- numeros_telephone_aleatoires