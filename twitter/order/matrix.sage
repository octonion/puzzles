from sys import argv
from sage.rings.polynomial.cyclotomic import cyclotomic_coeffs

n = eval(argv[1])
o = euler_phi(n)
p = cyclotomic_coeffs(n)
p.reverse()
#print(p)

A = matrix(1,o-1)
B = -matrix([p[0]])
C = matrix.identity(o-1)
D = -matrix(p[1:-1]).transpose()

M = block_matrix([[A,B],[C,D]], subdivide=False)
print "M rows =", M.nrows(), ", M cols =", M.ncols()

print "Determinant of M =", det(M)
#print(M.minpoly())

#R = QQ['x']
#print(R(cyclotomic_coeffs(n)))

print "M^", n,"= I(", o, ") is", M^n == matrix.identity(o)
