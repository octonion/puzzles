library(gmp)

getnextp <- function(pr,d,k) {
  p.values = as.bigz(1:50)
  p.values = p.values[which((p.values+pr) %% k == 0, arr.ind=TRUE)]
  p.tmp = abs(p.values*p.values-d)
  p.values = p.values[which.min(p.tmp)]
  return(p.values)
}

updatek <- function(pr,d,k) {
  return((pr*pr-d) %/% k)
}

getnextx <- function(pr,d,k,x,y) {
  return((pr*x + d*y) %/% abs(k))
}

getnexty <- function(pr,d,k,x,y) {
  return((pr*y + x) %/% abs(k))
}

x.init = as.bigz(1)
y.init = as.bigz(0)
p.init = as.bigz(1)
k.init = as.bigz(1)
d = as.bigz(92)

for(iter in 1:10) {
  k = as.bigz(0)
  while(k != 1) {
    p = getnextp(p.init,d,k.init)
    k = updatek(p,d,k.init)
    cat(" P(i+1),k(r+1) = [",as.character(p),",",as.character(k),"]\n")
    x = getnextx(p,d,k.init,x.init,y.init)
    y = getnexty(p,d,k.init,x.init,y.init)
    x.init = x
    y.init = y
    p.init = p
    k.init = k
  }
  cat("Solution (",as.character(x),",",as.character(y),")\n")
}
