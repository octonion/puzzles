from collections import deque

import numpy as np
from scipy.sparse import coo_matrix

from scipy.sparse.csgraph import floyd_warshall
from scipy.sparse.csgraph import shortest_path

row  = []
col  = []
weights = []

bound = 100000

queue = deque()
queue.append(3)

found = {3}
paths = {3 : 3}
sqrts = {3 : 0}

counts=[0]*10000

tries = 0
while (len(queue)> 0):
    m = queue.pop()
    tries += 1
    n = factorial(m).n()
    i = 1
    while (floor(n)>1):
        if (n<10000):
            counts[floor(n)] += 1
        if (n<bound):
            row += [m]
            col += [floor(n)]
            weights += [i]
        if (n<bound) and not(floor(n) in found):
            found.add(floor(n))
            queue.appendleft(floor(n))
            paths[floor(n)] = m
            sqrts[floor(n)] = i
        n = sqrt(n)
        i += 1

rn = np.max(row)+1
cn = np.max(col)+1

m = coo_matrix((np.array(weights), (np.array(row), np.array(col))), shape=(rn, cn))

dsp = shortest_path(m,directed=True,unweighted=False,indices=[3])

for i in range(2,101):
    if (i in found):
        w = int(dsp[0][i])
    else:
        w = dsp[0][i]
        
    print("{}, {}".format(i,w))
