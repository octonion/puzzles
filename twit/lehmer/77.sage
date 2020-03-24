
for p in Partitions(77, max_slope=-1):
    s = sum([1.0/i for i in p])
    if (abs(s-1.0)<1.0/100000):
        print(p),
        print(": reciprocal sum = {0}".format(sum([1/i for i in p])))
