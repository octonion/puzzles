#!/usr/bin/python3

import numpy as np

def null(a, rtol=1e-15):
    u, s, v = np.linalg.svd(a)
    rank = (s > rtol*s[0]).sum()
    return rank, v[rank:].T.copy()

# To balance:
# Combustion of butane
# C4H10 + O2 -> CO2 + H2O

A = np.matrix('4 0; 10 0; 0 2')
B = np.matrix('1 0; 0 2; 2 1')

# Moore-Penrose pseudoinverse

C = np.linalg.pinv(A,1e-15)

# A*A^+ has rank 1

D = A.dot(C)
print(np.linalg.matrix_rank(D))

d = D.shape[0]
I = np.identity(d)

L = null(D-I)

print(L)

# Null space is spanned by [2 5 0] and [0 0 1]

# Column space is spanned by [1 0 2] and [0 2 1]

# Intersection is:
# 2x*[2 5 0] + 13x*[0 0 1]
# 4y*[1 0 2] + 5y*[0 2 1]

# Balanced equation is:

# 2*C4H10 + 13*O2 -> 8*CO2 + 10*H2O
