library(gmp)
library(Rmpfr)

update_p <- function(pr,d,k) {
  s = .mpfr2bigz(round(sqrt(.bigz2mpfr(pr))))
  diff = (pr + s) %% abs(k)
  low = s-diff
  high = low+abs(k)
  if (low < 1) {
      return(high)
  } else {
      p.values = c(low,high)
      p.tmp = abs(p.values*p.values-d)
      p.values = p.values[which.min(p.tmp)]
      return(p.values)
  }
}

update_k <- function(pr,d,k) {
  return((pr*pr-d) %/% k)
}

update_x <- function(pr,d,k,x,y) {
  return((pr*x + d*y) %/% abs(k))
}

update_y <- function(pr,d,k,x,y) {
  return((pr*y + x) %/% abs(k))
}

x.init = as.bigz(1)
y.init = as.bigz(0)
p.init = as.bigz(1)
k.init = as.bigz(1)

# Archimedes cattle problem
# Removing factor 2^2*4657^2

d = as.bigz(609*7766)

k = as.bigz(0)
steps = 0

while(k != 1) {
    p = update_p(p.init, d, k.init)
    k = update_k(p, d, k.init)
    cat("[ p, k ] = [",as.character(p),",",as.character(k),"]\n")
    x = update_x(p, d, k.init, x.init, y.init)
    y = update_y(p, d, k.init, x.init, y.init)
    x.init = x
    y.init = y
    p.init = p
    k.init = k
    steps = steps+1
}
cat("Solution = [",as.character(x),",",as.character(y),"]\n")
cat("Steps = ",steps,"\n")
