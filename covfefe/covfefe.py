#!/usr/bin/env python3

import numpy as np
from numpy import linalg as la

t = np.zeros((8, 8))
t[0,0] = 25.0/26.0
t[0,1] = 1.0/26.0
t[7,0] = 25.0/26.0
t[7,1] = 1.0/26.0
for i in range(1,7):
    t[i,0] = 24.0/26.0
    t[i,1] = 1.0/26.0
    t[i,i+1] = 1.0/26.0

u = la.matrix_power(t, 1000000)
print("Steady state probabilities:")
print()
for i in range(0,8):
    print("  {0} = {1}".format(i,u[0,i]))
print()

print("Covfefe waiting time = {0}".format(1/u[0,7]))
