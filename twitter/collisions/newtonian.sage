M = 10^10

list = [[M-1, -2*M],[2, M-1]]

A = (1/(M+1)*matrix(Integer(2),list)).n()

v = matrix([0,-1]).transpose()

n = 1
B = A
while ((B*v)[0] > (B*v)[1]):
    B = B*A
    n += 1

print(((2*n)/sqrt(M)).n())
