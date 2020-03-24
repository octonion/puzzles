n = 10

list = []
for i in range(0,n):
    r = 3^i % 2^n
    v = r.digits(2)
    row = [0]*(n-len(v)) + v
    list += [row]

b = matrix(Integers(2),list)
print(b)
print(b.det())
