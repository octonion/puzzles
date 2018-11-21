import sys

N = int(sys.argv[1])

prec = int(sys.argv[2])

max_h = float(sys.argv[3])

l1 = (3-12*N-4*N^2-(2*N+5)*sqrt(4*N^2+4*N-15))/2
u1 = -2*(N+3)*(N+sqrt(N^2-4))

l2 = -2*(N+3)*(N-sqrt(N^2-4))
u2 = -4*(N+3)/(N+2)

#print(float(l1),float(u1),float(l2),float(u2))

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

print

if (rank > 1):
    print("Associated elliptic curve has rank > 1")
    good = []
    bad = []
    for g in generators:
        if (g[0] < 0):
            good += [g]
        else:
            bad += [g]

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

b0 = F.lift_x(bad[0][0])
b1 = F.lift_x(bad[1][0])
g0 = F.lift_x(good[0][0])
bb0 = G.lift_x(b0[0])
bb1 = G.lift_x(b1[0])
gg0 = G.lift_x(g0[0])
hb0 = b0.height()
hb1 = b1.height()
hg0 = g0.height()
hb0g0 = (b0+g0).height()
hb0b1 = (b0+b1).height()
hb1g0 = (b1+g0).height()
hb0b1g0 = (b0+b1+g0).height()

dbb0 = bb0
dgg0 = 2*gg0

tu = None

k = 0
while True:
    m = 0
    n = 1
    h = k*k*hb0 + m*m*hb1 + n*n*hg0 + k*n*(hb0g0-hb0-hg0) + m*n*(hb1g0-hb1-hg0) + k*m*(hb0b1-hb0-hb1) + k*m*n*(hb0b1g0-hb0g0-hb0b1-hb1g0+hb0+hb1+hg0)
    if (h > max_h):
        break
    while True:

        n = 1
        # Note these have the same height
        p1 = k*bb0+m*bb1+n*gg0+G(tp[0])
        p2 = k*bb0+m*bb1+n*gg0+G(tp[1])

        h = k*k*hb0 + m*m*hb1 + n*n*hg0 + k*n*(hb0g0-hb0-hg0) + m*n*(hb1g0-hb1-hg0) + k*m*(hb0b1-hb0-hb1) + k*m*n*(hb0b1g0-hb0g0-hb0b1-hb1g0+hb0+hb1+hg0)
        
        if (h > max_h):
            break

        found = False

        while not(found) and (h < max_h):

            if (p1[0]>l1 and p1[0]<u1) or (p1[0]>l2 and p1[0]<u2):
                p = p1
                tu = tp[0]
                found = True
            elif (p2[0]>l1 and p2[0]<u1) or (p2[0]>l2 and p2[0]<u2):
                p = p2
                tu = tp[1]
                found = True
            else:
                n += 2
                p1 += dgg0
                p2 += dgg0
                h = k*k*hb0 + m*m*hb1 + n*n*hg0 + k*n*(hb0g0-hb0-hg0) + m*n*(hb1g0-hb1-hg0) + k*m*(hb0b1-hb0-hb1) + k*m*n*(hb0b1g0-hb0g0-hb0b1-hb1g0+hb0+hb1+hg0)
            if found:
                if (h < max_h):
                    bk = k
                    bm = m
                    bn = n
                    bh = h
                    max_h = h
                print("k = %s, m = %s, n = %s, h = %s" %(k,m,n,h))

        m += 1
    k += 1

print
print("lowest height solution has k = %s, m = %s, n = %s" %(bk,bm,bn))
print("h = %s, lower bound %s digits" %(bh,(3/2*bh-6*log(N*1.0)-10)/log(10.0)))
exit()
q = bk*b0+bm*b1+bn*g0+F(tu)
s = finv(winv(q))
#print(p[0])
#print(float(q[0]))

g = gcd(s[0].denom(),s[1].denom())
sa = s[0]*g
sb = s[1]*g
sc = s[2]*g

print
print("Smallest solution:")
print
print(sa>0)
print(sb>0)
print(sc>0)
print("a = %s" %sa)
print("b = %s" %sb)
print("c = %s" %sc)
print
ml = max(len(str(sa)),len(str(sb)),len(str(sc)))
print("max %s digits" %ml)

sum = sa/(sb+sc) + sb/(sa+sc) + sc/(sa+sb)
print
print("a/(b+c) + b/(a+c) + c/(a+b) = %s" %sum)
