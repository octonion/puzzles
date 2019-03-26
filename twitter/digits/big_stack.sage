
sizes = [4,10,10^3,10^6]
digits = 100
d = 10^digits

for size in sizes:
    
    e = [0]*size
    m = [0]*size

    e[0] = d
    for i in range(1,size):
        e[i] = Mod(9,e[i-1]).multiplicative_order()

    m[size-1] = 9
    for i in range(size-2,-1,-1):
        m[i] = Mod(9,e[i])^m[i+1]

    print("Stack of {} has the final digits {}".format(size,m[0]))
