
# Number of resistors per side is m-1, n-1

m = 4
n = 5
Q = matrix(QQ,m*n-1,m*n-1)

for i in xrange(0,m):
  for j in xrange(0,n):
    if (i==m-1) and (j==n-1):
      continue
    #print(i,j)
    state = i+j*m
    #print(state)
    C = 0
    if (i > 0):
      C += 1
    if (i < m-1):
      C += 1
    if (j > 0):
      C += 1
    if (j < n-1):
      C += 1
    #print(C)
    if (i > 0):
      #print(state,state-1)
      Q[state,state-1] = 1/C
    if (i < m-1):
      if (state+1 < m*n-1):
        #print(state,state+1)
        Q[state,state+1] = 1/C
    if (j > 0):
      #print(state,state-m)
      Q[state,state-m] = 1/C
    if (j < n-1):
      if (state+m < m*n-1):
        #print(state,state+m)
        Q[state,state+m] = 1/C

I = matrix.identity(m*n-1)
N = (I-Q).inverse()
r_e = N[0,0]/2
print m-1,"x",n-1,"grid, equivalent resistance =",r_e
