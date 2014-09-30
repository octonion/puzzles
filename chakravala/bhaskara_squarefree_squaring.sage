#!/usr/bin/sage -python

from sys import argv
from sage.all import *
from operator import mul, add

class Pell:
  def __init__(self, x, y, D):
    self.x = x
    self.y = y
    self.D = D
  def __str__(self):
    return "(%d, %d, %d)" % (self.x, self.y, self.D)
  def __mul__(self, other):
    return Pell(self.x*other.y+self.y*other.x,
                self.D*self.x*other.x+self.y*other.y, self.D)
  def __pow__(self, n):
    P = Pell(0,1,D)
    F = self
    m = n
    #print(P)
    while m >= 1:
        if (m%2)==1:
            P = P*F
        m = floor(m/2)
        F = F*F
    return P

#def __pow__(a,e,n):
#     num = 1
#     while e >= 1:
#         print(e)
#         if (e%2) == 1:
#             num = (num*a) % n  
#         e = e/2
#         print(e)
#         a = (a*a) % n
#     return num
    
# Solving y^2 - D*x^2 = 1

# Archimedes cattle problem
# Removing factor 2^2*4657^2

#D = 609*7766*2**2*4657**2
d = eval(argv[1])

D = squarefree_part(d)
S = d/D

sD = isqrt(D)

x_init = 1
y_init = sD
h_init = D*x_init**2 - y_init**2

i = (-y_init/x_init) % h_init
m_init = h_init*floor(sD/h_init)+i

if (m_init>sD):
    m_init += -h_init

steps = 0

x = x_init
y = y_init
h = h_init
m = m_init

print
print("[h, m] = [%s, %s]" % (h, m))

while (h not in [1,2,4]):

    #print("[x, y, h, m] = [%s, %s, %s, %s]" % (x, y, h, m))

    x = (m_init*x_init+y_init)/h_init
    y = (D*x_init+m_init*y_init)/h_init

    h = (D-m_init**2)/h_init

    i = (-y/x) % h

    i = (-y/x) % h
    m = h*floor(sD/h)+i

    if (m>sD):
        m += -h

    x_init = x
    y_init = y
    h_init = h
    m_init = m
    steps = steps+1

    print("[h, m] = [%s, %s]" % (h, m))

if (h==2):
    (x,y) = (2*x*y, D*x**2+y**2)
    (x,y) = (x/2, y/2)
#    if (steps % 2)==1:
#        (x,y) = (2*x*y, D*x**2+y**2)
elif (h==4):
    (a, b) = (Rational(x)/2, Rational(y)/2)
    #print(a,b)
    if (a.is_integral() & b.is_integral()):
        (x,y) = (a,b)
    else:
        (a_1, b_1) = (2*a*b, D*a**2+b**2)
        #print(a_1,b_1)
        if (a_1.is_integral() & b_1.is_integral()):
            (x,y) = (a_1,b_1)
        else:
            (x, y) = (a*b_1+a_1*b, b*b_1+D*a*a_1)
            if (steps % 2)==0:
                (x,y) = (2*x*y, D*x**2+y**2)
else:
    if (steps % 2)==0:
        (x,y) = (2*x*y, D*x**2+y**2)

v = y**2-D*x**2
print
print("squarefree equation: %s*x^2 + 1 = y^2" % D)
print("squarefree solution = [%s, %s, %s]" % (x, y, v))
print("steps = %s" % steps)

# Find power for each p^k factor, take LCM

e = 1

if (S>1):

    rS = isqrt(S)
    rS_f = factor(rS)

    powers = []

    A = Pell(x, y, D)
    
    for factor in rS_f:
        i = 1
        M = factor[0]**factor[1]
        
        B = Pell(mod(A.x,M), mod(A.y,M), A.D)
        r = B.x
        
        C = B
        
        while (r>0):
            C = C*B
            r = C.x
            i += 1
        powers.append(i)

    e = lcm(powers)
    #print("power = %s" % e)
    #print(A)
    #foo = A*A
    #print("v = %s" % (foo.y**2-D*foo.x**2))
    B = A**e
    #print(A*A)
    #print(B)
    (x, y) = (floor(B.x/rS), B.y)

v = y**2-d*x**2
print
print("full equation: %s*x^2 + 1 = y^2" % d)
print("full solution = [%s, %s, %s]" % (x, y, v))
print("power = %s" % e)
print(round(log(x, 10)), round(log(y, 10)))
