from collections import deque

bound = 20000

queue = deque()
queue.append(3)

found = {3}
paths = {3 : 3}
sqrts = {3 : 0}

while (len(queue)> 0):
    m = queue.pop()
    n = factorial(m).n()
    i = 0
    while (floor(n)>3):
        if (n<bound) and not(floor(n) in found):
            found.add(floor(n))
            queue.appendleft(floor(n))
            paths[floor(n)] = m
            sqrts[floor(n)] = i
        n = sqrt(n)
        i += 1
print(sorted(found))

v = 9
while not(v==3):
    w = paths[v]
    print("{} <- {}! + {} sqrt".format(v,w,sqrts[v]))
    v = w