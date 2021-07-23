from collections import deque

R = RealField(400)
one = R(1)

bound = 1000000

lb = ln(bound)

queue = deque()
queue.append(3)

found = {3}
paths = {3 : 3}
sqrts = {3 : 0}

while (len(queue)> 0):
    m = queue.pop()
    x = log_gamma(m+one)

    i = 0
    p = ceil(log(x/lb,2))
    q = max(p,0)

    i += q

    n = round(exp(x/2^q))

    while (floor(n)>3):
        if not(floor(n) in found):
            found.add(floor(n))
            queue.appendleft(floor(n))
            paths[floor(n)] = m
            sqrts[floor(n)] = i
        n = sqrt(n)
        i += 1

print()

for i in range(3,1000000):
    if not(i in found):
        print("Lowest value not constructed was {} ".format(i),end="")
        break
print()
print()

v = 9
while not(v==3):
    w = paths[v]
    print("{} <- {}! + {} sqrt".format(v,w,sqrts[v]))
    v = w

#print()

#v = 3004
#v = 10509
#v = 22701
#v = 75592
