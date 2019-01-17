list = []
for i in range(0,10):
    r = 3^i % 1024
    v = r.digits(2)
    row = [0]*(10-len(v)) + v
    list += [row]

b = matrix(Integers(2),list)
print(b)
print(b.det())
