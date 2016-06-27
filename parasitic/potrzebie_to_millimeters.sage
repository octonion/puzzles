#!/usr/bin/sage -python

from sage.all import *

# Autoconvert pounds to kilograms by moving first digit to end

# Exact rational conversion:
# potrzebie = 2.263348517438173216473*mm

# Let C = 2.263348517438173216473

# Let mm = x*10^n + y, where 0 < x < 10, y < 10^n

# The autoconversion condition is C*mm = 10*y + x

# So:

# (1) C*(x*10^n + y) = 10*y + x

# Let D = C*10^21 = 2263348517438173216473

# (1) equals D*(x*10^n + y) = (10*y + x)*10^21

# (1) ==> (2) x*(D*10^n) - x*10^21 = y*10^22 - D*y
# ==> (3) x*(D*10^n - 10^21) = y*(10^22 - D)
# ==> (4) x*(2263348517438173216473*10^n - 10^21) = y*7736651482561826783527

#  ==> 2263348517438173216473*10^n - 10^21 = 0 (mod 7736651482561826783527)
#  ==> 2263348517438173216473*10^n = 10^21 (mod 7736651482561826783527)
#  ==> 10^n = 10^21/2263348517438173216473 (mod 7736651482561826783527)

# To solve: (5) y = x*(2263348517438173216473*10^n - 10^21)/7736651482561826783527

D = 2263348517438173216473

A = 10**21
B = 2263348517438173216473
M = 7736651482561826783527

a=Mod(A,M)
b=Mod(B,M)
c=a/b
n=discrete_log(10,c)
print("Smallest power of n = {0}".format(n))

# For smallest solution x = 1

x = 1

# floor(log((B*10**n - A)/M + 10**n))+1 digits
# floor(log((10**(n+22)-A)/M))+1
# floor(log((10**(n+22)-A)/M))+1
# log(10**(n+22)-10**21)-log(M)+1
# log(10**21*(10**(n+1)-1))-log(M)+1

#s = x*((B*10**n - A)/M + 10**n)

d = 40
e = 100
m = 10**e

s = -Mod(A,m)/Mod(M,m)
sd = floor(n+22-log(M,10))+1

print("Last {0} digits of potrzebie are {1}".format(d,Mod(s,10**d)))
print("Potrzebie has {0} digits".format(sd))

t = Mod(floor(s)/10**21,10**e)*Mod(D,10**e)
td = floor(n+22-log(M,10)+log(D,10)-21)+1

print("Last {0} digits of millimeters are {1}".format(d,Mod(t,10**d)))
print("Millimeters has {0} digits".format(td))
