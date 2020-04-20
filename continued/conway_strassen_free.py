# 609*7766*2**2*4657**2
# D = 609*7766

import sys
import math

D = int(sys.argv[1])
print(f"D = {D}")

s = math.floor(math.sqrt(D))
a = 1

# Reduced form

m = math.floor(math.sqrt(2+D))
b = 2*m
c = m**2-D

sD = math.floor(math.sqrt(b**2-4*a*c))

if c<0:
  d = (b+sD)//(-2*c)
  d = -d
else:
  d = (b+sD)//(2*c)

p11 = 0
p12 = 1
p21 = -1
p22 = -d

i = 0

while (c!=1):
  i += 1
  a1 = c
  b1 = -b+2*c*d
  c1 = a-b*d+c*d**2
  a = a1
  b = b1
  c = c1

  if c<0:
    d = (b+sD)//(-2*c)
    d = -d
  else:
    d = (b+sD)//(2*c)

  dp12 = d*p12
  dp22 = d*p22
  
  q = p21
  r = p11
  p11 = p12
  p12 = -r+dp12
  p21 = p22
  p22 = dp22-q

print(f"Steps = {i}")

print(f"x = {abs(p11+m*p21)}")
print(f"y = {abs(p21)}")
