#!/usr/bin/env python3

import numpy as np
from numpy import linalg as la
import scipy
from scipy import linalg, matrix

def null(A, eps=1e-15):
    u, s, vh = scipy.linalg.svd(A)
    null_mask = (s <= eps)
    null_space = scipy.compress(null_mask, vh, axis=0)
    return scipy.transpose(null_space)

t = np.zeros((8, 8))
t[0,0] = 25.0/26.0
t[0,1] = 1.0/26.0
t[7,0] = 25.0/26.0
t[7,1] = 1.0/26.0
for i in range(1,7):
    t[i,0] = 24.0/26.0
    t[i,1] = 1.0/26.0
    t[i,i+1] = 1.0/26.0

u = t.T-np.eye(8)
n = null(u)

s = sum(n)
n = n/s
print(n)

w = (1/n[7])[0]
print("Covfefe waiting time = {0}".format(w))
