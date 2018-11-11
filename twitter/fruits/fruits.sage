import sys

N = int(sys.argv[1])

R.<a,b,c> = QQ[]
cubic = a*(a+c)*(a+b)+b*(b+c)*(a+b)+c*(b+c)*(a+c)-N*(a+b)*(a+c)*(b+c)
P = [-1,1,0]
E = EllipticCurve_from_cubic(cubic, P, morphism=False); E

print
print(E.minimal_model())
print

f = EllipticCurve_from_cubic(cubic, P, morphism=True)
finv = f.inverse()
print(f(P))

conductor = E.conductor()
torsion_order = E.torsion_order()
rank = E.rank()
generators = E.gens()

print("conductor = %s" %(conductor))
print("torsion order = %s" %(torsion_order))
print("rank = %s" %(rank))
print("generators = %s" %(generators))

print(E.torsion_points())
print

if (len(generators) > 0):
	 p = generators[0]
	 q = finv(p)
else:
	print("Associated elliptic curve has rank 0")
	exit()

i = 1
while not((q[0] > 0) and (q[1] > 0)):
		i += 1
		q = finv(p*i)

g = gcd(q[0].denom(),q[1].denom())
sa = q[0]*g
sb = q[1]*g
sc = q[2]*g

print("Smallest solution:")
print
print("a = %s" %sa)
print("b = %s" %sb)
print("c = %s" %sc)

sum = sa/(sb+sc) + sb/(sa+sc) + sc/(sa+sb)
print
print("a/(b+c) + b/(a+c) + c/(a+b) = %s" %sum)

print("a has %s digits" %len(str(sa)))
print("b has %s digits" %len(str(sb)))
print("c has %s digits" %len(str(sc)))

