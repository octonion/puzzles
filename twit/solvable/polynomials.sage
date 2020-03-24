# Redicible problem proposed on Twitter

p = (x+1)^6 + (x+2)^6 + (x+3)^6 - 2
print(factor(p))

# Irredicible problem proposed on Twitter

p = x^8-2*x^6+2*x^5+x^4-4*x^3+x^2-2
K.<z> = NumberField(p)

# Galois group

G = K.galois_group(type='gap')

# Underlying group

g = G.group()
print(g)

# Is g solvable?

print(g.is_solvable())
