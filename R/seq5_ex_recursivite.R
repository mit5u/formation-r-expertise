carre_recursif <- function(base, iterations) {
  if (iterations == 0) {
    return(base)
  } else {
    resultat <- base^2
    browser()
    return(carre_recursif(resultat, iterations - 1))
  }
}

resultat <- carre_recursif(2, 5)
