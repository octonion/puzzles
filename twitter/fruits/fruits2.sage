import sys

N = int(sys.argv[1])

R.<a,b,c> = QQ[]
cubic = a*(a+c)*(a+b)+b*(b+c)*(a+b)+c*(b+c)*(a+c)-N*(a+b)*(a+c)*(b+c)
E = EllipticCurve_from_cubic(cubic, morphism=False)

f = EllipticCurve_from_cubic(cubic, morphism=True)
finv = f.inverse()

F = E.short_weierstrass_model()

w = E.isomorphism_to(F)
winv = F.isomorphism_to(E)

a2 = F.a2()
a4 = F.a4()
a6 = F.a6()

roots = (x^3+a2*x^2+a4*x+a6).roots()

xs = [x for (x,y) in roots]
cutoff = max(xs)

generators = F.gens()
rank = F.rank()
torsion_order = F.torsion_order()

print("torsion order = %s" %(torsion_order))
print("rank = %s" %(rank))
print("generators = %s" %(generators))

tp = F.torsion_points()
print

if (rank > 1):
    print("Associated elliptic curve has rank > 1")
    good = []
    for g in generators:
        if (g[0] < cutoff):
            good += [g]

    if len(good)>0:
        print(good)
        print("At least one generator lies on the egg")
        g = good[0]
        exit()
    else:
        print("No generators lie on the egg, not solvable")
        exit()
		
elif (rank == 0):
    print("Associated elliptic curve has rank 0")
    print("No solution")
    exit()
else:
    print("Associated elliptic curve has rank 1")
    g = generators[0]
    if not(g[0] < cutoff):
        print("Generator does not lie on egg, not solvable")
        exit()
    else:
        print("Generator lies on egg, solvable")

m = 1
tu = tp[0]
p = g
s = finv(winv(p))
found = False
while not((s[0] > 0) and (s[1] > 0)):
    for t in tp:
        r = finv(winv(p+t))
        if (r[0] > 0) and (r[1] > 0):
            tu = t
            found = True
            break
    if found:
        break
    m += 1
    p += g
    s = finv(winv(p))

print
print("m = %s" %m)

g = gcd(s[0].denom(),s[1].denom())
sa = s[0]*g
sb = s[1]*g
sc = s[2]*g

print
print("Smallest solution:")
#print
#print("a = %s" %sa)
#print("b = %s" %sb)
#print("c = %s" %sc)
print
ml = max(len(str(sa)),len(str(sb)),len(str(sc)))
print("max %s digits" %ml)

sum = sa/(sb+sc) + sb/(sa+sc) + sc/(sa+sb)
print
print("a/(b+c) + b/(a+c) + c/(a+b) = %s" %sum)


