#!/usr/bin/sage -python

from sys import argv
from sage.all import *
from operator import mul, add

print("Archimedes cattle problem")
print

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

# Archimedes cattle problem
# Solving y^2 - d*x^2 = 1

d = 609*7766*2**2*4657**2

print("chakravala algorithm, English version")

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
elif (h==4):
    (a, b) = (Rational(x)/2, Rational(y)/2)
    if (a.is_integral() & b.is_integral()):
        (x,y) = (a,b)
    else:
        (a_1, b_1) = (2*a*b, D*a**2+b**2)
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
    print
    print("powering up!")
    print("powering exponent = %s" % e)
    B = A**e
    (x, y) = (floor(B.x/rS), B.y)

v = y**2-d*x**2
print
print("full equation: %s*x^2 + 1 = y^2" % d)
print("full solution = [%s, %s, %s]" % (x, y, v))

print("x has %s digits, y has %s digits" % (round(log(x, 10)), round(log(y, 10))))


print
cattle = [46200808287018, 33249638308986, 18492776362863, 32793026546940, 32116937723640, 21807969217254, 24241207098537, 15669127269180]
print("fundamental cattle vector: %s" % cattle)

cattle = list(x**2*vector(cattle))
total = reduce(add, cattle)

print
print("total cattle = %s" % total)
print

print("number of digits = %s" % (floor(log(total, 10))+1))
print("last 20 digits = %s" % (total % 10**20))
