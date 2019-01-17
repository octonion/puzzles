
for n in range(1,1001):

    list = []
    for i in range(0,n):
        r = 3^i % 2^n
        v = r.digits(2)
        row = [0]*(n-len(v)) + v
        list += [row]

    b = matrix(Integers(2),list)
    d = b.det()
    if d==1:
        print("n = %s, det = %s" %(n,d))
