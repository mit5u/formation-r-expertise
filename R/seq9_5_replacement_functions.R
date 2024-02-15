# Fonction qui permet de censurer une variable, c'est à dire de limiter les valeurs à un plafond
`censurer<-` <- function(x, value) {
  x[x > value] <- value
  # x <- pmin(x, value)
  x
}


salaires <- 1:5*1000
censurer(salaires) <- 3500
salaires

