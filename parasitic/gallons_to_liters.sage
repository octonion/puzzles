#!/usr/bin/sage -python

from sage.all import *

# Autoconvert gallons to liters by moving first digit to end

# Exact rational conversion:
# gallons = 3.785411784*liters

# Let C = 3.785411784

# Let gallons = x*10^n + y, where 0 < x < 10, y < 10^n

# The autoconversion condition is C*gallons = 10*y + x

# So:

# (1) C*(x*10^n + y) = 10*y + x

# Let D = C*10^9 = 3785411784

# (1) equals D*(x*10^n + y) = (10*y + x)*10^9

# (1) ==> (2) x*(D*10^n) - x*10^9 = y*10^10 - D*y
# ==> (3) x*(D*10^n - 10^9) = y*(10^10 - D)
# ==> (4) x*(3785411784*10^n - 10^9) = y*(10^10 - 3785411784)

# Let G = gcd(3785411784,10^9) = 8

# (4) ==> (5) x*(473176473*10^n - 125000000) = y*(1250000000 - 473176473)

#  ==> (6) x*(473176473*10^n - 125000000) = y*776823527
#  ==> 473176473*10^n - 125000000 = 0 (mod 776823527)
#  ==> 473176473*10^n = 125000000 (mod 776823527)
#  ==> 10^n = 125000000/473176473 (mod 776823527)

# To solve: (7) y = x*(473176473*10^n - 125000000)/776823527

D = 3785411784

A = 125000000
B = 473176473
M = 776823527

a=Mod(A,M)
b=Mod(B,M)
c=a/b
n=discrete_log(10,c)
print(n)

# For smallest solution x = 1

x = 1

y = x*(B*10**n - A)/M + 10**n
print(Mod(y,10000000000000))
print(floor(log(y,10)))
print(Mod(y*D/1000000000,10000000000000))

# Uncomment to print solution and the conversion to liters
# Warning: they're enormous

#print(y)
#print
#print(y*D/1000000000)
