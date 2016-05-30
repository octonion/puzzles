#!/usr/bin/env python3

import numpy.random
import math

n = 5
sigma = math.sqrt(162.0/4)

sims = 1000000

maxes = []
for i in range(0, sims):
    maxes.append(max(numpy.random.normal(81.0,sigma,n)))

print(numpy.mean(maxes))

