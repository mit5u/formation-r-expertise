# factorial ----
factorial <- function(n) {
  assert_that(as.integer(n) == n, msg = "n should be an integer")
  if(n == 0){
    1
  } else {
    n * factorial(n - 1)
  }
}
# factorial(4)
# factorial(8/2)
# factorial(4.1)

# fibonacci ----

fibonacci <- function(n) {
  assert_that(as.integer(n) == n, msg = "n should be an integer")
  if(n %in% 1:2) {
    1
  } else {
    fibonacci(n-1) + fibonacci(n-2)
  }
}
# fibonacci(12)

# using {memoise} to increase performance ----
fibo_mem <- memoise(fibonacci)
# fibo_mem(12)

bench::mark(
  recurs = {
    map(1:10, fibonacci)
  },
  recurs_mem = {
    map(1:10, fibo_mem)
  }
)

fact_mem <- memoise(factorial)

bench::mark(
  recurs = {
    map(1:10, factorial)
  },
  recurs_mem = {
    map(1:10, fact_mem)
  }
)
