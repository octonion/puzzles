from collections import deque

from sage.graphs.graph_input import from_dict_of_lists
from sage.graphs.distances_all_pairs import distances_all_pairs

bound = 1000000

queue = deque()
queue.append(3)

found = {3}
paths = {3 : 3}
sqrts = {3 : 0}
edges = []

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
            edges += [(m,floor(n),i)]
        if (n<bound) and not(floor(n) in found):
            found.add(floor(n))
            queue.appendleft(floor(n))
            paths[floor(n)] = m
            sqrts[floor(n)] = i
        n = sqrt(n)
        i += 1

d = DiGraph(edges,weighted=True,loops=True)
#dap = distances_all_pairs(d)

for i in range(4,1001):
    if (i in d.vertices()):
        l = d.shortest_simple_paths(3, i, by_weight=True, report_edges=True, report_weight=True, labels=True)
        p=next(l)
        w = p[0]
        print("{}, {}".format(i,w))
    else:
        print("{}, no path".format(i))

#522,702,878,890,993

#l = d.shortest_simple_paths(3, 522, by_weight=True, report_edges=True, report_weight=True, labels=True)
#print(next(l))

#l = d.shortest_simple_paths(3, 702, by_weight=True, report_edges=True, report_weight=True, labels=True)
#print(next(l))

#for i,p in enumerate(l):
#    print(i,p)
#    if i>5:
#        exit()
#)algorithm="Feng")))
exit()

#for i in range(2,501):
#    t_p = (log(log((i+1)))-log(log(i))).n(32)/log(2).n(32)
#    a_p = counts[i].n(32)/tries.n(32)
#    print("{}: {}/{}, t_p = {}, a_p = {}".format(i,counts[i],tries,t_p,a_p))

#print()
#for i in range(2,1000):
#    if counts[i]==0:
#        print(i,end=" ")
#print()
#    v = w
    
#print()
#v = 878
#while not(v==3):
#    w = paths[v]
#    print("{} <- {}! + {} sqrt".format(v,w,sqrts[v]))
#    v = w

#print()
#v = 890
#while not(v==3):
#    w = paths[v]
#    print("{} <- {}! + {} sqrt".format(v,w,sqrts[v]))
#    v = w

#print()
#v = 993
#while not(v==3):
#    w = paths[v]
#    print("{} <- {}! + {} sqrt".format(v,w,sqrts[v]))
#    v = w
