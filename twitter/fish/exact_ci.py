import numpy as np
from scipy.stats import hypergeom

# n - unknown population size

# Desired confidence level
p = 95/100

# Marked in first group
m = 24
# Caught in second group
c = 19
# Tagged in second group
t = 3

print("Lincoln-Petersen estimator = ",(m*c/t))
print("Chapman estimator = ",((m+1)*(c+1)/(t+1)-1))

lower=None
upper=None
for n in range(m+c-t,20000):
    n_lower = hypergeom.ppf(1/2-p/2,n,m,c)
    n_upper = hypergeom.ppf(1/2+p/2,n,m,c)
    #print(n_lower,n_upper)
    if lower==None and round(n_lower)==t:
        lower=n
    if upper==None and round(n_upper)==t:
        upper=n
        break

print(p,"-level confidence interval is (",lower,upper,")")

p = 0/100

lower=None
upper=None
for n in range(m+c-t,20000):
    n_lower = hypergeom.ppf(1/2-p/2,n,m,c)
    n_upper = hypergeom.ppf(1/2+p/2,n,m,c)
    #print(n_lower,n_upper)
    if lower==None and round(n_lower)==t:
        lower=n
    if upper==None and round(n_upper)==t:
        upper=n
        break

print("Squeezed estimator bounds = (",lower,upper,")")
