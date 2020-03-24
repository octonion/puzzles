#import numpy
import sys

def inner(x,y):
    # Ideally, x.height() and y.height() would be cached
    return(((x+y).height()-x.height()-y.height())/2)

def ip_matrix(P):
    n = len(P)
    M = matrix(RR,n,n)
    for i in range(0,n):
        M[i,i] = P[i].height()
        for j in range(0,i):
            M[i,j] = inner(P[i],P[j])
            M[j,i] = M[i,j]
    return(M)

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

number=0

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

M = ip_matrix([b0,b1,b2,g0])
#print(M)
#C = matrix([1,2,3,4])
#print(C*M*C.transpose())
#print((bad[0]+2*bad[1]+3*bad[2]+4*good[0]).height())

dgg0 = 2*gg0

tu = None
dM = M.det()
mp = float((max_h)^2*(pi^2/2.0)/sqrt(dM))/(32.0)

print('Points to search = %s' %(mp))

C = matrix(ZZ,[0,0,0,1])
while True: # i-loop

    C[0,1] = 0
    C[0,2] = 0
    C[0,3] = 1

    h = C*M*C.transpose()

    if (h > max_h):
        break
    
    while True: # j-loop
        C[0,2] = 0
        C[0,3] = 1

        h = C*M*C.transpose()
        
        if (h > max_h):
            break

        while True: # k-loop

            C[0,3] = 1
            # Note these have the same height
            # Later: switch to dot product
            p1 = C[0,0]*bb0+C[0,1]*bb1+C[0,2]*bb2+C[0,3]*gg0+G(tp[0])
            p2 = C[0,0]*bb0+C[0,1]*bb1+C[0,2]*bb2+C[0,3]*gg0+G(tp[1])

            h = C*M*C.transpose()

            if (h > max_h):
                break

            found = False

            while not(found) and (h < max_h):

                number += 1

                if (p1[0]>l1 and p1[0]<u1) or (p1[0]>l2 and p1[0]<u2):
                    p = p1
                    tu = tp[0]
                    found = True
                elif (p2[0]>l1 and p2[0]<u1) or (p2[0]>l2 and p2[0]<u2):
                    p = p2
                    tu = tp[1]
                    found = True
                else:
                    C[0,3] += 2
                    p1 += dgg0
                    p2 += dgg0
                    h = C*M*C.transpose()
                    
                if found:
                    if (h < max_h):
                        bi = C[0,0]
                        bj = C[0,1]
                        bk = C[0,2]
                        bl = C[0,3]
                        bh = h[0,0]
                        max_h = h[0,0]
                    #print(C,h,(C[0,0]*bad[0]+C[0,1]*bad[1]+C[0,2]*bad[2]+C[0,3]*good[0]).height())
                    print("i = %s, j = %s, k = %s, l = %s, h = %s" %(C[0,0],C[0,1],C[0,2],C[0,3],h[0,0]))

            C[0,2] += 1
        C[0,1] += 1
    C[0,0] += 1

print
#print(bh,(bi*bad[0]+bj*bad[1]+bk*bad[2]+bl*good[0]).height())
print("lowest height solution has i = %s, j = %s, k = %s, l = %s" %(bi,bj,bk,bl))
print("h = %s, lower bound %s digits" %(bh,(3/2*bh-6*log(N*1.0)-10)/log(10.0)))
print(number)
exit()
q = bi*b0+bj*b1+bk*b2+bl*g0+F(tu)
s = finv(winv(q))

#print(p[0])
#print(float(q[0]))

g = lcm(s[0].denom(),s[1].denom())
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
