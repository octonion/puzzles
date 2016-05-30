#!/usr/bin/env python3

import numpy.random
import math

n = 5
sigma = math.sqrt(162.0/4)
maxes = []
for i in range(1,1000000):
    maxes.append(max(numpy.random.binomial(162,0.5,n)))

print(numpy.mean(maxes))
