# Exercice complémentaire  ----
## une fonction f qui renvoie "Hello world" quand on appelle f()()() ----
`f()()` <- function() {
  print("Hello world!")
}

`f()()`() # c'est drôle mais c'est pas exactement ça qu'on voulait appeler

f <- function() {
  f1 <- function() {
    f2 <- function() {
      print("Hello world!")
    }
    return(f2)
  }
  return(f1)
}
f()
f()()
f()()()

## une fonction g qui renvoie x quand on appelle g(x)()() ----
g <- function(x) {
  g1 <- function() {
    g2 <- function() {
      return(x)
    }
    return(g2)
  }
  return(g1)
}
g(x = 1:10)()()
