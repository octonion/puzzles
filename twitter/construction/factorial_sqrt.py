from collections import deque
from math import factorial, isqrt

bound = 20000

queue = deque()
queue.append(3)

found = {3}
paths = {3 : 3}
sqrts = {3 : 0}

while (len(queue)> 0):
    m = queue.pop()
    n = factorial(m)
    i = 0
    while (n>3):
        if (n<bound) and not(n in found):
            found.add(n)
            queue.appendleft(n)
            paths[n] = m
            sqrts[n] = i
        n = isqrt(n)
        i += 1
        
for i in range(3,1000):
    if not(i in found):
        print("{} ".format(i),end="")
print()
print()

v = 9
while not(v==3):
    w = paths[v]
    print("{} <- {}! + {} sqrt".format(v,w,sqrts[v]))
    v = w
