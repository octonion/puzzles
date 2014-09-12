#!/usr/bin/sage -python

from sys import argv
from sage.all import *
from operator import mul, add

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
    print(a,b)
    if (a.is_integral() & b.is_integral()):
        (x,y) = (a,b)
    else:
        (a_1, b_1) = (2*a*b, D*a**2+b**2)
        print(a_1,b_1)
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

if (S>1):
    rS = isqrt(S)
    r = x % rS
    (a,b) = (x, y)
    i = 0
    while (r>0):
        (x, y) = (a*y+b*x, D*a*x+b*y)
        r = x % rS
        i += 1
    x = x/rS

v = y**2-d*x**2
print
print("full equation: %s*x^2 + 1 = y^2" % d)
print("full solution = [%s, %s, %s]" % (x, y, v))
print("power = %s" % i)
print(round(log(x, 10)), round(log(y, 10)))
