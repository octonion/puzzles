#!/usr/bin/sage -python

from sage.all import *

# Autoconvert kilometers to miles by moving first digit to end

# Exact rational conversion:
# miles = 1.609344*kilometers

# Let C = 1.609344

# Let kilometers = x*10^n + y, where 0 < x < 10, y < 10^n

# The autoconversion condition is C*kilometers = 10*y + x

# So:

# (1) C*(x*10^n + y) = 10*y + x

# Let D = C*10^9 = 1609344 

# (1) equals D*(x*10^n + y) = (10*y + x)*10^9

# (1) ==> (2) x*(D*10^n) - x*10^9 = y*10^10 - D*y
# ==> (3) x*(D*10^n - 10^9) = y*(10^10 - D)
# ==> (4) x*(1609344*10^n - 10^9) = y*(10^10 - 1609344)

# Let G = gcd(1609344,10^9) = 128

# (4) ==> (5) x*(12573*10^n - 7812500) = y*(78125000 - 12573)

#  ==> (6) x*(12573*10^n - 7812500) = y*78112427
#  ==> 12573*10^n - 7812500 = 0 (mod 78112427)
#  ==> 12573*10^n = 7812500 (mod 78112427)
#  ==> 10^n = 7812500/12573 (mod 78112427)

# To solve: (7) y = x*(12573*10^n - 7812500)/78112427

D = 1609344
A = 7812500
B = 12573
M = 78112427

a=Mod(A,M)
b=Mod(B,M)
c=a/b
n=discrete_log(10,c)
print(n)

# For smallest solution x = 1

x = 1

y = x*(B*10**n - A)/M + 10**n
print(Mod(y,10**10))
print(floor(log(y,10))+1)
print(Mod(y*D/10**9,10**10))

# Uncomment to print solution and the conversion to liters
# Warning: they're enormous

#print(y)
#print
#print(y*D/1000000000)
