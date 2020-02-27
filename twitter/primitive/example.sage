p = 1000003

R = Integers(p)

m = R(1)
for i in range(2,(p-1)/2):
    m = 2*i*m
    if (m.multiplicative_order()==euler_phi(p)):
        print(f"{2*i}! is a primitive root mod {p}")
        exit()
print("No primitive root found.")
