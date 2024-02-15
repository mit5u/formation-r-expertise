# function factory ----

make_power_fun <- function(pow) {
  function(x) {
    x**pow
  }
}

square <- make_power_fun(2)
hammer <- 8
square(hammer)
square(1:5)

cube <- make_power_fun(3)
sd(cube(iris$Sepal.Length))

