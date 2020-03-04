
#p = 5
#m = matrix(RDF,[[0,0,1/4,3/4],[1/4,0,3/4,0],[0,3/4,0,1/4],[3/4,1/4,0,0]])

#print(f"Base {p}")
#print(m)
#print(m^100)
#print()

def least_power(p):
    header = [mod(-1,p)]*(p-1)

    for i in range(1,p-1):
        header[i] = -(i+1)*header[i-1]

    m = (matrix(QQ, p-1, p-1, lambda i, j: header.count(mod((i+1),p)/mod((j+1),p))))/(p-1)

    for i in range(1,p):
        c = (m^i).list().count(0)
        if c==0:
            print(f"For base {p} all values found at power {i}")
            c = (m^(i+1)).list().count(0)
            print(f"For base {p} count {c} found at power {i+1}")
            return

for p in prime_range(300):
    least_power(p)
