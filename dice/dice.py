#!/usr/bin/python3

import numpy as np

# Transition matrix

T = np.zeros((7,7))

for i in range(0,6):
    T[i][i] = i/6.0
    T[i][i+1] = (6.0-i)/6.0

T[6][6]=1.0

rolls = 5

# Outcome matrix

O = np.linalg.matrix_power(T,rolls)

# Expected number of different outcomes

E = 0.0
for i in range(1,7):
    E = E+i*O[0][i]

print(E)
