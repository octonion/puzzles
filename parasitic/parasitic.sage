#!/usr/bin/sage -python

from sage.all import *

# Multiply A by C to get B by moving first digit of A to end

# Exact rational conversion:
# C*A = B

# Let A = x*10^n + y, where 0 < x < 10, y < 10^n

# The parasitic condition is C*A = 10*y + x

# So:

# m = implied power of C

# (1) C*(x*10^n + y) = 10*y + x

# Let D = C*10^m

# (1) equals D*(x*10^n + y) = (10*y + x)*10^m

# (1) ==> (2) x*(D*10^n) - x*10^m = y*10^{m+1} - D*y
# ==> (3) x*(D*10^n - 10^m) = y*(10^{m+1} - D)

# For now assume gcd(D,10^m) = 1

# Let M = 10^{m+1} - D

#  ==> D*10^n - 10^m = 0 (mod M)
#  ==> D*10^n = 10^m (mod M)
#  ==> 10^n = 10^m/D (mod M)

# To solve: (5) y = x*(D*10^n - 10^m)/M

D = 2263348517438173216473
m = 21

# More generally, divide by gcd() here

A = 10**m
B = D
M = 10**(m+1)-D

#p = euler_phi(M)

a=Mod(A,M)
b=Mod(B,M)

c=a/b

n=discrete_log(10,c)

#if (n==0):
#   n += p
#end

print("Smallest power of n = {0}".format(n))

# For smallest solution x = 1

x = 1

# floor(log((B*10**n - A)/M + 10**n))+1 digits
# floor(log((10**(n+m+1)-A)/M))+1
# floor(log((10**(n+m+1)-A)/M))+1
# log(10**(n+m+1)-10**m)-log(M)+1
# log(10**m*(10**(n+1)-1))-log(M)+1

#s = x*((B*10**n - A)/M + 10**n)

d = 10
e = 20
w = 10**e

#s = -Mod(A,w)/Mod(M,w)
#s = x*((B*10**n - A)/M + 10**n)
sd = floor(n+m+1-log(M,10))+1

#print("Max {0} digits of number are {1}".format(d,Mod(s,10**d)))
#print("Number = {0}".format(s))
print("Number has {0} digits".format(sd))

#t = Mod(floor(s)/10**m,w)*Mod(D,w)
#t = (s*D)/10**m
td = floor(n+m+1-log(M,10)+log(D,10)-m)+1

#print("Max {0} digits of result are {1}".format(d,Mod(t,10**d)))
print("Result has {0} digits".format(td))
#print("Result = {0}".format(t))
