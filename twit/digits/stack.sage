n = 4

digits = 100
d = 10^digits

m = []

x = Mod(9,d).multiplicative_order()
y = Mod(9,x).multiplicative_order()

a = Mod(9,y)^9
b = Mod(9,x)^a
c = Mod(9,d)^b

print(c)
