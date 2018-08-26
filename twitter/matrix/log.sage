A=matrix([
[0,1],
[1,2]
])

B=matrix([
[0,1],
[1,20]
])

D,V = (A*B).eigenmatrix_right()

L=matrix([
[log(D[0][0]*1.0),0],
[0,1.0*log(D[1][1]*1.0)]])

LM = V*L*V.inverse()

print LM
EM = LM.exp()
E=matrix([
[float(EM[0][0]),float(EM[0][1])],
[float(EM[1][0]),float(EM[1][1])]
])
print A*B
print E
