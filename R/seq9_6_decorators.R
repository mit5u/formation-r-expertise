# exemple ----
ajouter_message_appel <- function(f) {
  wrapper <- function(...) {
    cat("Calling function", ensym(f), "now !\n")
    cat(f(...) + 1)
    cat("\nOne-off errors are hard =)\nHere are the actual results :\n")
    f(...)
  }
  return(wrapper)
}

sin_with_message <- ajouter_message_appel(sin)
sin_with_message(1:5)

# exercices ----
## doubler le résultat d'une fonction ----
double_result <- function(f) {
  wrapper <- function(...) {
    2 * f(...)
  }
  return(wrapper)
}
double_sum <- double_result(sum)
identical(double_sum(1:10), 2 * sum(1:10))

## multiplier par n le résultat d'une fonction ----
multiply_by_n <- function(f, n) {
  wrapper <- function(...) {
    n * f(...)
  }
  return(wrapper)
}
chad_sum <- multiply_by_n(sum, 3)
chad_sum(1:10)

beta_sum <- multiply_by_n(sum, 0.5)
beta_sum(1:10)

## afficher la durée d'exécution d'une fonction ----
display_runtime <- function(f) {
  wrapper <- function(...) {
    tic <- Sys.time()
    val <- f(...)
    toc <- Sys.time()
    message(sprintf("%f seconds elapsed", toc - tic))
    return(val)
  }
  return(wrapper)
}
verbose_sin <- display_runtime(sin)
verbose_sin(1:10)

## afficher les arguments utilisés dans l'appel d'une fonction ----
display_arguments <- function(f) {
  wrapper <- function(...) {
    message(glue("Calling function {ensym(f)} with arguments {rlang::list2(...)}"))
    f(...)
  }
  return(wrapper)
}
verbose_tan <- display_arguments(tan)
verbose_tan(1:2)

## afficher un avertissement de dépréciation ----
display_deprecation_warning <- function(f) {
  wrapper <- function(...) {
    warning(glue("Function {ensym(f)} is deprecated. Please use a good function instead."))
    f(...)
  }
  return(wrapper)
}
deprecated_sum <- display_deprecation_warning(sum)
deprecated_sum(1:10)
