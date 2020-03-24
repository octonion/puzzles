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
b2 = F.lift_x(bad[2][0])
g0 = F.lift_x(good[0][0])
bb0 = G.lift_x(b0[0])
bb1 = G.lift_x(b1[0])
bb2 = G.lift_x(b2[0])
gg0 = G.lift_x(g0[0])

hb0 = b0.height()
hb1 = b1.height()
hb2 = b2.height()
hg0 = g0.height()

hb0b1 = (b0+b1).height()
hb0b2 = (b0+b2).height()
hb0g0 = (b0+g0).height()
hb1b2 = (b1+b2).height()
hb1g0 = (b1+g0).height()
hb2g0 = (b2+g0).height()

hb0b1b2 = (b0+b1+b2).height()
hb0b1g0 = (b0+b1+g0).height()
hb0b2g0 = (b0+b2+g0).height()
hb1b2g0 = (b1+b2+g0).height()

hb0b1b2g0 = (b0+b1+b2+g0).height()

dgg0 = 2*gg0

tu = None

i = 0
while True: # i-loop
    j = 0
    k = 0
    l = 1

    h = i**2*hb0 + j**2*hb1 + k**2*hb2 + l**2*hg0 + i*j*(hb0b1-hb0-hb1) + i*k*(hb0b2-hb0-hb2) + i*l*(hb0g0-hb0-hg0) + j*k*(hb1b2-hb1-hb2) + j*l*(hb1g0-hb1-hg0) + k*l*(hb2g0-hb2-hg0) + i*j*k*(hb0b1b2-hb0b1-hb0b2-hb1b2+hb0+hb1+hb2) + i*j*l*(hb0b1g0-hb0b1-hb0g0-hb1g0+hb0+hb1+hg0) + i*k*l*(hb0b2g0-hb0b2-hb0g0-hb2g0+hb0+hb2+hg0) + j*k*l*(hb1b2g0-hb1b2-hb1g0-hb2g0+hb1+hb2+hg0) + i*j*k*l*(hb0b1b2g0-hb0b1b2-hb0b1g0-hb0b2g0-hb1b2g0+hb0b1+hb0b2+hb0g0+hb1b2+hb1g0+hb2g0-hb0-hb1-hb2-hg0)

    if (h > max_h):
        break
    
    while True: # j-loop
        k = 0
        l = 1

        h = i**2*hb0 + j**2*hb1 + k**2*hb2 + l**2*hg0 + i*j*(hb0b1-hb0-hb1) + i*k*(hb0b2-hb0-hb2) + i*l*(hb0g0-hb0-hg0) + j*k*(hb1b2-hb1-hb2) + j*l*(hb1g0-hb1-hg0) + k*l*(hb2g0-hb2-hg0) + i*j*k*(hb0b1b2-hb0b1-hb0b2-hb1b2+hb0+hb1+hb2) + i*j*l*(hb0b1g0-hb0b1-hb0g0-hb1g0+hb0+hb1+hg0) + i*k*l*(hb0b2g0-hb0b2-hb0g0-hb2g0+hb0+hb2+hg0) + j*k*l*(hb1b2g0-hb1b2-hb1g0-hb2g0+hb1+hb2+hg0) + i*j*k*l*(hb0b1b2g0-hb0b1b2-hb0b1g0-hb0b2g0-hb1b2g0+hb0b1+hb0b2+hb0g0+hb1b2+hb1g0+hb2g0-hb0-hb1-hb2-hg0)
        
        if (h > max_h):
            break

        while True: # k-loop

            l = 1
            # Note these have the same height
            p1 = i*bb0+j*bb1+k*bb2+l*gg0+G(tp[0])
            p2 = i*bb0+j*bb1+k*bb2+l*gg0+G(tp[1])

            h = i**2*hb0 + j**2*hb1 + k**2*hb2 + l**2*hg0 + i*j*(hb0b1-hb0-hb1) + i*k*(hb0b2-hb0-hb2) + i*l*(hb0g0-hb0-hg0) + j*k*(hb1b2-hb1-hb2) + j*l*(hb1g0-hb1-hg0) + k*l*(hb2g0-hb2-hg0) + i*j*k*(hb0b1b2-hb0b1-hb0b2-hb1b2+hb0+hb1+hb2) + i*j*l*(hb0b1g0-hb0b1-hb0g0-hb1g0+hb0+hb1+hg0) + i*k*l*(hb0b2g0-hb0b2-hb0g0-hb2g0+hb0+hb2+hg0) + j*k*l*(hb1b2g0-hb1b2-hb1g0-hb2g0+hb1+hb2+hg0) + i*j*k*l*(hb0b1b2g0-hb0b1b2-hb0b1g0-hb0b2g0-hb1b2g0+hb0b1+hb0b2+hb0g0+hb1b2+hb1g0+hb2g0-hb0-hb1-hb2-hg0)

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
                    l += 2
                    p1 += dgg0
                    p2 += dgg0
                    h = i**2*hb0 + j**2*hb1 + k**2*hb2 + l**2*hg0 + i*j*(hb0b1-hb0-hb1) + i*k*(hb0b2-hb0-hb2) + i*l*(hb0g0-hb0-hg0) + j*k*(hb1b2-hb1-hb2) + j*l*(hb1g0-hb1-hg0) + k*l*(hb2g0-hb2-hg0) + i*j*k*(hb0b1b2-hb0b1-hb0b2-hb1b2+hb0+hb1+hb2) + i*j*l*(hb0b1g0-hb0b1-hb0g0-hb1g0+hb0+hb1+hg0) + i*k*l*(hb0b2g0-hb0b2-hb0g0-hb2g0+hb0+hb2+hg0) + j*k*l*(hb1b2g0-hb1b2-hb1g0-hb2g0+hb1+hb2+hg0) + i*j*k*l*(hb0b1b2g0-hb0b1b2-hb0b1g0-hb0b2g0-hb1b2g0+hb0b1+hb0b2+hb0g0+hb1b2+hb1g0+hb2g0-hb0-hb1-hb2-hg0)
                    
                if found:
                    if (h < max_h):
                        bi = i
                        bj = j
                        bk = k
                        bl = l
                        bh = h
                        max_h = h
                    print("i = %s, j = %s, k = %s, l = %s, h = %s" %(i,j,k,l,h))

            k += 1
        j -= 1
    i += 1

print
print("lowest height solution has i = %s, j = %s, k = %s, l = %s" %(bi,bj,bk,bl))
print("h = %s, lower bound %s digits" %(bh,(3/2*bh-6*log(N*1.0)-10)/log(10.0)))
#exit()
q = bi*b0+bj*b1+bk*b2+bl*g0+F(tu)
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
