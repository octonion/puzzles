#!/usr/bin/sage -python

from sage.all import *
import sys

# Multiply A by C to get B by moving first digit of A to end

# Exact rational conversion:
# C*A = B

# Let A = x*10^n + y, where 0 < x < 10, y < 10^n

# The parasitic condition is C*A = 10*y + x

# So:

# (1) C*(x*10^n + y) = 10*y + x

# Assume C = p/q

# (1) equals p*(x*10^n + y) = q*(10*y + x)

# (1) ==> (2) x*(p*10^n) - x*q = y*10*q - p*y
# ==> (3) x*(p*10^n - q) = y*(10*q - p)

# For now assume gcd(p,q,10) = 1

# Let M = 10*q-p

#  ==> p*10^n - q = 0 (mod M)
#  ==> p*10^n = q (mod M)
#  ==> 10^n = q/p (mod M)

# To solve: (5) y = x*(q*10^n - p)/M

# Gallons to liters

#p = 3785411784
#q = 1000000000

p = floor(sys.argv[1])
q = floor(sys.argv[2])

g = gcd(p,q)
p = p/g
q = q/g

# Need to divide modulus by gcd(10*q-p,M)
# For smallest solution

M = (10*q-p)
x = gcd(M,10)
M = M/x

a=Mod(p,M)
b=Mod(q,M)

c=b/a

n=discrete_log(10,c)

print("Smallest power of n = {0}".format(n))

# floor(log((B*10**n - A)/M + 10**n))+1 digits
# floor(log((10**(n+m+1)-A)/M))+1
# floor(log((10**(n+m+1)-A)/M))+1
# log(10**(n+m+1)-10**m)-log(M)+1
# log(10**m*(10**(n+1)-1))-log(M)+1

#s = x*((B*10**n - A)/M + 10**n)

#d = 10
#e = 20
#w = 10**e

#s = -Mod(A,w)/Mod(M,w)
s = x*((p*10**n - q)/M + 10**n)
#sd = floor(n+m+1-log(M,10))+1
sd = floor(log(s,10)+1)

#print("Max {0} digits of number are {1}".format(d,Mod(s,10**d)))
print("Number = {0}".format(s))
print("Number has {0} digits".format(sd))

#t = Mod(floor(s)/10**m,w)*Mod(D,w)
#t = s*p/q
#td = floor(n+m+1-log(M,10)+log(D,10)-m)+1

#print("Max {0} digits of result are {1}".format(d,Mod(t,10**d)))
#print("Result has {0} digits".format(td))
#print("Result = {0}".format(t))
