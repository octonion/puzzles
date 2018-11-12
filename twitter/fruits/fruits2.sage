import sys

N = int(sys.argv[1])

R.<a,b,c> = QQ[]
cubic = a*(a+c)*(a+b)+b*(b+c)*(a+b)+c*(b+c)*(a+c)-N*(a+b)*(a+c)*(b+c)
#P = [-1,1,0]
E = EllipticCurve_from_cubic(cubic, morphism=False)
print(E)

#L = E.change_ring(RR).lift_x(0, all=True)
#print(L)

print
print(E.minimal_model())
print

f = EllipticCurve_from_cubic(cubic, morphism=True)
finv = f.inverse()
#print(f(P))

conductor = E.conductor()
torsion_order = E.torsion_order()
rank = E.rank()
generators = E.gens()

print("conductor = %s" %(conductor))
print("torsion order = %s" %(torsion_order))
print("rank = %s" %(rank))
print("generators = %s" %(generators))

tp = E.torsion_points()
print

if (rank > 1):
    print("Associated elliptic curve has rank > 1")
    good = []
    for g in generators:
        q = finv(g)
        if (g[0] < 0):
            good += [g]

    if len(good)>0:
        print(good)
        print("At least one generator lies on the egg")
        g = good[0]
        exit()
    else:
        print("No generators lie on the egg, no solution")
        exit()
		
elif (rank == 0):
    print("Associated elliptic curve has rank 0")
    print("No solution")
    exit()
else:
    print("Associated elliptic curve has rank 1")
    g = generators[0]
    q = finv(g)
    if (g[0] >= 0):
        print("Generator does not lie on egg, no solution")
        exit()

m = 1
tu = tp[0]
found = False
while not((q[0] > 0) and (q[1] > 0)):
    for t in tp:
        r = finv(g*m+t)
        if ((r[0] > 0) and (r[1] > 0)):
            tu = t
            found = True
            q = r
            break
    if found:
        break
    m += 1
    q = finv(g*m)
    #print(q[0] > 0, q[1] > 0)
    #qn = finv(-g*m)
    #print(qn[0] > 0, qn[1] > 0)

print
print("m = %s" %m)
#print

g = gcd(q[0].denom(),q[1].denom())
sa = q[0]*g
sb = q[1]*g
sc = q[2]*g

print
print("Smallest solution:")
print
#print("a = %s" %sa)
#print("b = %s" %sb)
#print("c = %s" %sc)
#print
ml = max(len(str(sa)),len(str(sb)),len(str(sc)))
print("max %s digits" %ml)

sum = sa/(sb+sc) + sb/(sa+sc) + sc/(sa+sb)
print
print("a/(b+c) + b/(a+c) + c/(a+b) = %s" %sum)


