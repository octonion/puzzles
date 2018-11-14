import sys

N = int(sys.argv[1])

prec = int(sys.argv[2])

l1 = (3-12*N-4*N^2-(2*N+5)*sqrt(4*N^2+4*N-15))/2
u1 = -2*(N+3)*(N+sqrt(N^2-4))

l2 = -2*(N+3)*(N-sqrt(N^2-4))
u2 = -4*(N+3)/(N+2)

#print(l1,u1,l2,u2)

R.<a,b,c> = QQ[]
cubic = a*(a+c)*(a+b)+b*(b+c)*(a+b)+c*(b+c)*(a+c)-N*(a+b)*(a+c)*(b+c)
E = EllipticCurve_from_cubic(cubic, morphism=False)

f = EllipticCurve_from_cubic(cubic, morphism=True)
finv = f.inverse()

ES = E.short_weierstrass_model()
F = ES.change_weierstrass_model([3,12*N^2+36*N-9,0,0])

w = E.isomorphism_to(F)
winv = F.isomorphism_to(E)

RF = RealField(prec)
G = F.change_ring(RF)

generators = F.gens()
rank = len(generators) #F.rank()
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
        if (g[0] < 0):
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
    if not(g[0] < 0):
        print("Generator does not lie on egg, not solvable")
        exit()
    else:
        print("Generator lies on egg, solvable")

gg = G([RF(g[0]),RF(g[1]),RF(g[2])])
m = 1
tu = tp[0]
p = gg
found = False
while True: #not(p[0]>l1 and p[0]<u1) and not(p[0]>l2 and p[0]<u2):
    for t in tp:
        r = p+G(t)
        if (r[0]>l1 and r[0]<u1) or (r[0]>l2 and r[0]<u2):
            #print(m,r[0],float((m*g+t)[0]))
            tu = t
            found = True
            break
    if found:
        break
    m += 1
    p += G(g)

print
print("m = %s" %m)
exit()
s = finv(winv(m*g+tu))

g = gcd(s[0].denom(),s[1].denom())
sa = s[0]*g
sb = s[1]*g
sc = s[2]*g

print
print("Smallest solution:")
print
print("a = %s" %sa)
print("b = %s" %sb)
print("c = %s" %sc)
print
ml = max(len(str(sa)),len(str(sb)),len(str(sc)))
print("max %s digits" %ml)

sum = sa/(sb+sc) + sb/(sa+sc) + sc/(sa+sb)
print
print("a/(b+c) + b/(a+c) + c/(a+b) = %s" %sum)
