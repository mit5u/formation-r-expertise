x <- 10
y <- 20
z <- 30

f <- function (x, y) {
  x <- x * 2
  y <- x + y
  z <- z * y
  w <- z + y
  return(w)
}
f(5, 3) # 403 : x = 5, y = 3 (valeurs passées en argument)
# et z = 30 (valeur issue de l'enclosing environment)
x # pas modifié par l'exécution de la fonction
