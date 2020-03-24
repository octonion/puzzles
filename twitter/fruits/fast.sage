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

tp = F.torsion_points()
#generators = F.gens()
#g = generators[0]
#print(finv(winv(g)))
#print(tp[0],finv(winv(g+tp[0])))
#print(tp[1],finv(winv(g+tp[1])))
#print(tp[2],finv(winv(g+tp[2])))
#exit()

RF = RealField(prec)
G = F.change_ring(RF)

try:
	generators = F.gens()
except:
    exit()
	
rank = len(generators) #F.rank()
torsion_order = F.torsion_order()

print("rank = %s" %(rank))
print("torsion order = %s" %(torsion_order))
#print("generators = %s" %(generators))

#g = generators[0]
#tp = F.torsion_points()
#print(g,finv(winv(g)))
#print(tp[0].order())
#print(tp[0],finv(winv(g+tp[0])))
#print(tp[1].order())
#print(tp[1],finv(winv(g+tp[1])))
#print(tp[2].order())
#print(tp[2],finv(winv(g+tp[2])))
#print(tp[3].order())
#print(tp[3],finv(winv(g+tp[3])))
#print(tp[4].order())
#print(tp[4],finv(winv(g+tp[4])))
#print(tp[5].order())
#print(tp[5],finv(winv(g+tp[5])))
#exit()
print

if (rank > 1):
    print("Associated elliptic curve has rank > 1")
    good = []
    for g in generators:
        if (g[0] < 0):
            good += [g]

    if len(good)>0:
        print("%s of %s generators lie on the egg" %(len(good),rank))
        g = good[0]
    else:
        print("0 of %s generators lie on the egg, not solvable" %rank)
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

#print(g[0])
#print((F.lift_x(g[0])).height())
#exit()
gg = G.lift_x(g[0])
g2 = 2*gg
m = 1
p1 = gg+G(tp[0])
p2 = gg+G(tp[1])
found = False
#print(tp[0:1])
#exit()
while not(found):
    if (p1[0]>l1 and p1[0]<u1) or (p1[0]>l2 and p1[0]<u2):
        p = p1
        found = True
    elif (p2[0]>l1 and p2[0]<u1) or (p2[0]>l2 and p2[0]<u2):
        p = p2
        found = True
    else:
        m += 2
        p1 += g2
        p2 += g2

print
print("m = %s" %m)

h = F.lift_x(g[0]).height()
print("h = %s, lower bound %s digits" %(h,(3/2*m^2*h-6*log(N*1.0)-10)/log(10.0)))
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
