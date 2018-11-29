import sys
from sage.libs.pari.convert_sage import gen_to_sage

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

print("Elliptic curve has rank %s" %(rank))
print("Torsion order is %s" %(torsion_order))
print

number=0

if (rank > 1):
    odd = 0
    parity = []
    for g in generators:
        if (g[0] < 0):
            parity.append(1)
            odd += 1
        else:
            parity.append(0)

    if odd>0:
        print("%s of %s generators lie on the non-identity component" %(odd,rank))
    else:
        print("0 of %s generators lie on the non-identity component, not solvable" %rank)
        exit()
		
elif (rank == 0):
    print("Associated elliptic curve has rank 0")
    print("No solution")
    exit()

ql = []
rl = []
for g in generators:
    ql.append(F.lift_x(g[0]))
    rl.append(G.lift_x(g[0]))

M = ip_matrix(ql)

tu = None
dM = M.det()
S = pi^(rank/2.0)/gamma(rank/2.0+1)
mp = float((max_h)^(rank/2.0)*S/sqrt(dM))/(2.0)

print
print('Points to search ~ volume of ellipsoid = %s' %(round(mp)))

PM = pari(M)

points = gp('qfminim(%s,%s,,2)' %(PM,max_h))
pari_vectors = points[3]
sage_vectors = gen_to_sage(pari(pari_vectors))

pairs = []
n = sage_vectors.ncols()
print("Points returned = %s" %(n))
print

for i in range(0,sage_vectors.ncols()):
    c = sage_vectors.column(i)
    
    # Point must be on the non-identity component

    dot = sum([x*y for x,y in zip(parity,c)])
    if (dot%2==1):
        h = c*(M*c)
        pairs.append([h,c])
    
pairs.sort(key=lambda x: x[0])

p = rl
s = None
found = False
for pair in pairs:
    h = pair[0]
    v = pair[1]
    p1 = sum([x*y for x,y in zip(v,p)])+G(tp[0])
    p2 = sum([x*y for x,y in zip(v,p)])+G(tp[1])
    
    if (p1[0]>l1 and p1[0]<u1) or (p1[0]>l2 and p1[0]<u2):
        tu = tp[0]
        s = v
        print("Solution found - %s, h = %s" %(v,h))
        found = True
        break

    if (p2[0]>l1 and p2[0]<u1) or (p2[0]>l2 and p2[0]<u2):
        tu = tp[1]
        s = v
        print("Solution found - %s, h = %s" %(v,h))
        found = True
        break

if not(found):
    print("No solution found; increase max height.")
    exit()
          
print("h = %s, lower bound %s digits" %(h,(3/2*h-6*log(N*1.0)-10)/log(10.0)))
p = ql

q = sum([x*y for x,y in zip(s,p)])+F(tu)
s = finv(winv(q))

g = lcm(s[0].denom(),s[1].denom())
sa = s[0]*g
sb = s[1]*g
sc = s[2]*g

print
print("Smallest solution:")
print
print("a = %s" %sa)
print("b = %s" %sb)
print("c = %s" %sc)
print("a > 0? = %s" %(sa>0))
print("b > 0? = %s" %(sb>0))
print("c > 0? = %s" %(sc>0))
print
ml = max(len(str(sa)),len(str(sb)),len(str(sc)))
print("max %s digits" %ml)

sum = sa/(sb+sc) + sb/(sa+sc) + sc/(sa+sb)
print
print("a/(b+c) + b/(a+c) + c/(a+b) = %s" %sum)
