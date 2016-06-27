#!/usr/bin/sage -python

# I believe there are no solutions

from sage.all import *

# Autoconvert kilometers to miles by moving first digit to end

# Exact rational conversion:
# miles = 1.609344*kilometers

# Let C = 1.609344

# Let kilometers = x*10^n + y, where 0 < x < 10, y < 10^n

# The autoconversion condition is C*kilometers = 10*y + x

# So:

# (1) C*(x*10^n + y) = 10*y + x

# Let D = C*10^6 = 1609344 

# (1) equals D*(x*10^n + y) = (10*y + x)*10^6

# (1) ==> (2) x*(D*10^n) - x*10^6 = y*10^7 - D*y
# ==> (3) x*(D*10^n - 10^6) = y*(10^7 - D)
# ==> (4) x*(1609344*10^n - 10^6) = y*(10^7 - 1609344)

# Let G = gcd(1609344,10^6) = 64

# (4) ==> (5) x*(25146*10^n - 15625) = y*(156250 - 25146)

#  ==> (6) x*(25146*10^n - 15625) = y*131104
#  ==> x*(25146*10^n - 15625) = 0 (mod 131104)

# Not possible, as we must have 32|x

# x = 32*x'

#  ==> (32/10*x')*(25146*10^n - 15625) = 0 (mod 131104)
#  ==> 251460*10^n = 156250 (mod 40970)
#  ==> 10^n = 15625/25146 (mod 40970)

# To solve: (7) y = x'*(25146*10^n - 15625)/40970

D = 1609344

A = 15625
B = 25146
M = 40970

a=Mod(A,M)
b=Mod(B,M)
print(a)
print(b)
c=a/b
n=discrete_log(10,c)
print(n)

# For smallest solution x' = 1

x = 1

#y = x*(B*10**n - A)/M + 10**n
#print(Mod(y,10**10))
#print(floor(log(y,10))+1)
#print(Mod(y*D/10**9,10**10))

s = x*(B*10**n - A)/M + 10**n

print(s)
#print(Mod(s,10**10))
print(floor(log(s,10))+1)

t = (s*D)/10**6
print(t)
#print(Mod(t,10**10))
print(floor(log(t,10))+1)

# Uncomment to print solution and the conversion to liters
# Warning: they're enormous

#print(y)
#print
#print(y*D/1000000000)
