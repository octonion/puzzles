import numpy as np
import itertools
import random

var('n')

def remainder_ev(d,r):
    
    k = len(d)
    m = min(d)
    eq=sum((1-d[i])^n for i in range(0,k))==r
    #print(min(1,r)/m,max(k,k/r)/m)
    ev = eq.find_root(min(1,r)/m,max(k,k/r)/m)
    #ev = eq.find_root(1,1000)
    return(ev)

def power_ev(d,p):

    r = min(d)
    s = 0
    pev = 0
    for x in d:
        #s += exp(x/r-1)
        s += (x/r)^2
        pev += 1/s
    return(pev/r)

def digamma1_ev(d):

    r = min(d)
    a = 0.0
    for x in d:
        a = a+exp(1-x/r)

    # Analytic continuation of harmonic series
    h = psi(float(a)+1) + euler_gamma.n()
    return(h/r)

def digamma2_ev(d):

    k = len(d)
    r = min(d)
    a = 0.0
    for i in range(0,k):
        a = a + ((1-d[i])/(1-r))^(1/r)

    h = psi(float(a)+1) + euler_gamma.n()
    return(h/r)

def schelling_ev(d):

    k = len(d)
    ev = 0
    m = 1
    for i in range(0,k-m+1):
        sets = itertools.combinations(d, m+i)
        for s in sets:
            ev += (-1)^i * binomial(m-1+i,m-1) * 1/sum(s)
    return(ev)

def schelling_var(d,ev):

    k = len(d)
    pvar = 0
    m = 1
    for i in range(0,k-m+1):
        sets = itertools.combinations(d, m+i)
        for s in sets:
            pvar += (-1)^i * binomial(m-1+i,m-1) * 1/(sum(s))^2

    var = 2*(pvar - ev*(ev+1)/2)
    return(var)

#p = np.array([1/8]*8)

# Blood type probabilities example

print()
print("Blood type probabilities example.")
d = np.array([0.33,0.07,0.09,0.02,0.03,0.01,0.37,0.08])

# We're assuming our array of probabilities is sorted
d.sort()

ev = schelling_ev(d)
print()
print("Schelling exact EV =",ev)

s = 0
for x in d:
    s += (1-x)^ev
print("Schelling EV expected missing =",s)

var = schelling_var(d,ev)
print("Schelling exact VAR =",var)

print()
ev = remainder_ev(d,1/exp(1))
print("Remainder 1/e EV =",ev)
ev = remainder_ev(d,1/2)
print("Remainder 1/2 EV =",ev)
ev = remainder_ev(d,1/exp(euler_gamma))
print("Remainder 1/e^γ EV =",ev)

ev = power_ev(d,2)
print()
print("Power 2 method =", ev)

ev = digamma1_ev(d)
print()
print("Digamma 1 EV = ",ev)

ev = digamma2_ev(d)
print()
print("Digamma 2 EV = ",ev)

# Uniform U(0,1) example
print()
print("Uniform U(0,1) n=20 example.")

d = np.random.uniform(0,1,20)
d = d/sum(d)

d.sort()

d.sort()

ev = schelling_ev(d)
print()
print("Schelling exact EV =",ev)

s = 0
for x in d:
    s += (1-x)^ev
print("Schelling EV expected missing =",s)

var = schelling_var(d,ev)
print("Schelling exact VAR =",var)

print()
ev = remainder_ev(d,1/exp(1))
print("Remainder 1/e EV =",ev)
ev = remainder_ev(d,1/2)
print("Remainder 1/2 EV =",ev)
ev = remainder_ev(d,1/exp(euler_gamma))
print("Remainder 1/e^γ EV =",ev)

ev = power_ev(d,2)
print()
print("Power 2 method =", ev)

ev = digamma1_ev(d)
print()
print("Digamma 1 EV = ",ev)

ev = digamma2_ev(d)
print()
print("Digamma 2 EV = ",ev)

# Exponential E(1) example
print()
print("Exponential E(1) n=20 example.")

d = np.random.exponential(1,20)
d = d/sum(d)

d.sort()

ev = schelling_ev(d)
print()
print("Schelling exact EV =",ev)

s = 0
for x in d:
    s += (1-x)^ev
print("Schelling EV expected missing =",s)

var = schelling_var(d,ev)
print("Schelling exact VAR =",var)

print()
ev = remainder_ev(d,1/exp(1))
print("Remainder 1/e EV =",ev)
ev = remainder_ev(d,1/2)
print("Remainder 1/2 EV =",ev)
ev = remainder_ev(d,1/exp(euler_gamma))
print("Remainder 1/e^γ EV =",ev)

ev = power_ev(d,2)
print()
print("Power 2 method =", ev)

ev = digamma1_ev(d)
print()
print("Digamma 1 EV = ",ev)

ev = digamma2_ev(d)
print()
print("Digamma 2 EV = ",ev)
