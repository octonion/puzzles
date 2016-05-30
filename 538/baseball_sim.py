#!/usr/bin/env python3

import numpy.random
import math

n = 5
intra = 19
inter = 162-(n-1)*intra

sims = 1000000

maxes = []
for i in range(0, sims):
    wins = [0]*n
    for j in range(0, n):
        wins[j] += numpy.random.binomial(inter,0.5,1)[0]
        for k in range(j+1, n):
            w = numpy.random.binomial(intra,0.5,1)
            wins[j] += w[0]
            wins[k] += intra-w[0]
    
    maxes.append(max(wins))

print(numpy.mean(maxes))
