#!/usr/bin/sage -python

from sage.all import *

# Autoconvert pounds to kilograms by moving first digit to end

# Exact rational conversion:
# kilograms = 0.45359237*pounds

# Let C = 0.45359237

# Let pounds = x*10^n + y, where 0 < x < 10, y < 10^n

# The autoconversion condition is C*pounds = 10*y + x

# So:

# (1) C*(x*10^n + y) = 10*y + x

# Let D = C*10^8 = 45359237

# (1) equals D*(x*10^n + y) = (10*y + x)*10^8

# (1) ==> (2) x*(D*10^n) - x*10^8 = y*10^9 - D*y
# ==> (3) x*(D*10^n - 10^8) = y*(10^9 - D)
# ==> (4) x*(45359237*10^n - 10^8) = y*954640763

#  ==> 45359237*10^n - 10^8 = 0 (mod 954640763)
#  ==> 45359237*10^n = 10^8 (mod 954640763)
#  ==> 10^n = 10^8/45359237 (mod 954640763)

# To solve: (5) y = x*(45359237*10^n - 10^8)/954640763

D = 45359237

A = 10**8
B = 45359237
M = 954640763

a=Mod(A,M)
b=Mod(B,M)
c=a/b
n=discrete_log(10,c)
print("Smallest power of n = {0}".format(n))

# For smallest solution x = 1
# For smallest solution with both numbers the same length, x = 3

x = 3

s = x*((B*10**n - A)/M + 10**n)
print("Last 10 digits of pounds are {0}".format(Mod(s,10**10)))
print("Pounds has {0} digits".format(floor(log(s,10))+1))

t = (s*D)/10**8
print("Last 10 digits of kilograms are {0}".format(Mod(t,10**10)))
print("Kilograms has {0} digits".format(floor(log(t,10))+1))

# Uncomment to print solution and the conversion to liters
# Warning: they're enormous

#print(s)
#print
#print(t)
