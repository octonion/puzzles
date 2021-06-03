
a = [None]*5
a[0] = -2
a[1] = 1
a[2] = 0
a[3] = 0
a[4] = 0

b = [None]*5
b[0] = 1
b[1] = -2
b[2] = 0
b[3] = 0
b[4] = 0

A = [None]*5
A[0] = a[0]
A[1] = 0
A[2] = a[1]
A[3] = 0
A[4] = a[2]

B = [None]*5
B[0] = b[0]
B[1] = 0
B[2] = b[1]
B[3] = 0
B[4] = b[2]

c = [None]*3
c[0] = 1

G = [[None]*5]*5

G[1][0] = (lambda x : 1)
G[1][1] = (lambda x : x/2)
G[1][2] = (lambda x : x^2/8)
G[1][3] = (lambda x : x^3/48-x/8)
G[1][4] = (lambda x : x^4/384-x^2/16)
G[2][0] = (lambda x : 1)
G[2][1] = (lambda x : x)
G[2][2] = (lambda x : x^2/2)
G[2][3] = (lambda x : x^3/6-x/2)
G[2][4] = (lambda x : x^4/24-x^2/2)

s = 4
alpha = 1/4 + b[1]/(2*b[0])
rho = -1/2*a[0]
gamma = 2

def bin(x,y,p):
    if mod(p,2)==1:
       return(0)
    else:
       return(binomial(x,y))
end       

c[1] = 2/((s-3)*rho^2*gamma)*sum((sum(rho^2*2^(k/2)*bin(alpha-l/2,k/2,k)*G[2][s-l-k](gamma)+rho*A[k]*sum(bin(alpha-l/2,j/2,j)*G[1][s-l-k-j](gamma) for j in (0..(s-l-k))) for k in (0..(s-l-1)))+(rho^2*2^((s-l)/2)*bin(alpha-l/2,1/2*(s-l),s-l)+rho*A[s-l]+B[s-l]))*c[l] for l in (0..(s-4)))

print("From (2.18) we get {}".format(c[1]))

x = 0
for l in range(0,s-4+1):
    y = rho^2*2^((s-l)/2)*bin(alpha-l/2,1/2*(s-l),s-l)+rho*A[s-l]+B[s-l]
    for k in range(0,s-l):
        y += rho^2*2^(k/2)*bin(alpha-l/2,k/2,k)*G[2][s-l-k](gamma)
        z = 0
        for j in range(0,s-l-k+1):
            z += bin(alpha-l/2,j/2,j)*G[1][s-l-k-j](gamma)
        y += z*rho*A[k]
    x += c[l]*y

c[1] = 2/((s-3)*rho^2*gamma)*x

print("From (2.18) we get {}".format(c[1]))

x = 1/(24*b[0]^2*gamma)*(a[0]^2*a[1]^2-24*a[0]*a[1]*b[0]+8*a[0]*a[1]*b[1]-24*a[0]*a[2]*b[0]-9*b[0]^2-32*b[1]^2+24*b[0]*b[1]+48*b[0]*b[2])

print("From (2.19) we get {}".format(x))
