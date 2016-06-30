#!/usr/bin/sage -python

from sage.all import *
import sys

# Multiply A by C to get B by moving first digit of A to end

# Exact rational conversion:
# C*A = B

# Let A = x*E^n + y, where 0 < x < E, y < E^n

# The parasitic condition is C*A = E*y + x

# So:

# (1) C*(x*E^n + y) = E*y + x

# Assume C = p/q

# (1) equals p*(x*E^n + y) = q*(E*y + x)

# (1) ==> (2) x*(p*E^n) - x*q = y*E*q - p*y
# ==> (3) x*(p*E^n - q) = y*(E*q - p)

# For now assume gcd(p,q,E) = 1

# Let M = E*q-p

#  ==> p*E^n - q = 0 (mod M)
#  ==> p*E^n = q (mod M)
#  ==> E^n = q/p (mod M)

# To solve: (5) y = x*(q*E^n - p)/M

E = floor(sys.argv[1])

p = floor(sys.argv[2])
q = floor(sys.argv[3])

g = gcd(p,q)
p = p/g
q = q/g

# Need to divide modulus by gcd(E*q-p,M)
# For smallest solution

M = (E*q-p)
x = gcd(M,E)
M = M/x

a=Mod(p,M)
b=Mod(q,M)

c=b/a

n=discrete_log(E,c)

print("Smallest power of n = {0}".format(n))

# floor(log((B*E**n - A)/M + E**n))+1 digits
# floor(log((E**(n+m+1)-A)/M))+1
# floor(log((E**(n+m+1)-A)/M))+1
# log(E**(n+m+1)-E**m)-log(M)+1
# log(E**m*(E**(n+1)-1))-log(M)+1

#s = x*((B*E**n - A)/M + E**n)

#d = E
#e = 20
#w = E**e

#s = -Mod(A,w)/Mod(M,w)
s = x*((p*E**n - q)/M + E**n)
#sd = floor(n+m+1-log(M,E))+1
sd = floor(log(s,E)+1)

#print("Max {0} digits of number are {1}".format(d,Mod(s,E**d)))
print("Number = {0}".format(s.str(base=E)))
print("Number has {0} digits".format(sd))

#t = Mod(floor(s)/E**m,w)*Mod(D,w)
#t = s*p/q
#td = floor(n+m+1-log(M,E)+log(D,E)-m)+1

#print("Max {0} digits of result are {1}".format(d,Mod(t,E**d)))
#print("Result has {0} digits".format(td))
#print("Result = {0}".format(t))
