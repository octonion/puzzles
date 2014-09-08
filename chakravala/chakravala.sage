#!/usr/bin/sage -python

from sys import argv
from sage.all import *
from operator import mul, add

def update_p(pr,d,k):
  s = round(sqrt(pr))
  diff = (pr + s) % abs(k)
  low = s-diff
  high = low+abs(k)
  if (low < 1):
    return(high)
  else:
    if abs(low*low-d)<=abs(high*high-d):
        return(low)
    else:
        return(high)

def update_k(pr,d,k):
    return((pr*pr-d)/k)

def update_x(pr,d,k,x,y):
    return((pr*x + d*y)/abs(k))

def update_y(pr,d,k,x,y):
  return((pr*y + x)/abs(k))

x_init = 1
y_init = 0
p_init = 1
k_init = 1

# Archimedes cattle problem
# Removing factor 2^2*4657^2

d = 609*7766

k = 0
steps = 0

while (k != 1):
    p = update_p(p_init, d, k_init)
    k = update_k(p, d, k_init)
    print("[p, k] = [%s, %s]" % (p,k))
    x = update_x(p, d, k_init, x_init, y_init)
    y = update_y(p, d, k_init, x_init, y_init)
    x_init = x
    y_init = y
    p_init = p
    k_init = k
    steps = steps+1

print("Solution = [%s, %s]" % (x,y))
print("Steps = %s" % steps)
