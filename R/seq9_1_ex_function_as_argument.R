make_affine_fun <- function(x, slope, intercept = 0) {
  return(x * slope + intercept)
}

#' Compute values of a function for integers between 1 and 5
#'
#' @param fun affine function to compute values on
#' @param ... other arguments passed on to fun
#'
#' @return numeric vector giving f(n) with n integer between 1 and 5
#' @export
#'
#' @examples
give_fun_value_1_5 <- function(fun, ...) {
  return(fun(1:5, ...))
}
give_fun_value_1_5(fun = make_affine_fun, slope = 2, intercept = 1)
give_fun_value_1_5(fun = sin)
give_fun_value_1_5(fun = (\(x) 1/x))
give_fun_value_1_5(fun = (\(x) paste(x, 'is awesome!'))) # not type safe!
