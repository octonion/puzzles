n = 5
S = MatrixSpace(RR,n)

X=S.random_element()

I=matrix.identity(n)

Y=X
for i in range(100):
  Y = X + Y.inverse()

Z=X
for i in range(200):
  Z = X + Z.inverse()

print((Z-Y).norm(Infinity))

