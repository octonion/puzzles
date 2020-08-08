import numpy as np

from itertools import groupby

s = 250
k = 3
die = np.array(range(0,k))

total=0.0
n = 500000
for i in range(0,n):
    x = np.random.choice(k, s)
    total += max(sum(1 for _ in l) for n, l in groupby(x))

print(total/n)
