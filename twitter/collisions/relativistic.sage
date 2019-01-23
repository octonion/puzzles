RR=RealField(10000)

M = RR(10^10)

c = RR(3*10^8)

v0 = RR(0) #.n()
v1 = RR(-10^4) #(-1/2).n()

p = (v0/sqrt(1-v0^2/c^2) + M*v1/sqrt(1-v1^2/c^2)).n()
E = (c^2/sqrt(1-v0^2/c^2) + M*c^2/sqrt(1-v1^2/c^2)).n()

V = (p*c^2/E).n()

n = 1
while (v0 > v1):

    u0 = (v0-V)/(1-v0*V/c^2)
    u1 = (v1-V)/(1-v1*V/c^2)
    
    v0 = (-u0+V)/(1-u0*V/c^2)
    v1 = (-u1+V)/(1-u1*V/c^2)

    v0 = -v0
    #p = (v0/sqrt(1-v0^2/c^2) + M*v1/sqrt(1-v1^2/c^2)).n()
    p += 2*v0/sqrt(1-v0^2/c^2)
    V = p*c^2/E
    #print(v0,v1)
    
    n += 1

#print(2*n)
print(((2*n)/sqrt(M)).n(digits=20))
