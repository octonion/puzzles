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

# Handle primes common to M and base

M = 10*q-p

f = factor(M)
d = dict(zip(zip(*f)[0],zip(*f)[1]))

g=1
if (2 in d):
   g = g*2**d[2]

if (5 in d):
   g = g*5**d[5]

# p/q*g < 10 or unsolvable

if (p*g) >= 10*q:
   print("No solution")
   sys.exit(0)

x = g
M = M/x

a=Mod(p,M)
b=Mod(q,M)

c=b/a

# Must be at least 2 digits?

n=discrete_log(10,c)

print("Smallest power of n = {0}".format(n))

#s = x*((B*10**n - A)/M + 10**n)

s = (p*10**n - q)/M + x*10**n
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
