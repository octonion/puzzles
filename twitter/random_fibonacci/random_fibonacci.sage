
a = 1.0
b = 1.0

n = 1
for i in range(2,1000000):
    c = (2-1/n)*b - (1-2/n)*a
    a = b
    b = c
    n += 1

n += 1

print("Actual, n = {}, value = {}".format(n,b.n()))

x = 1/sqrt(e*pi)*( exp(2*sqrt(n))/(sqrt(n)*sqrt(sqrt(n))) * (1-101/48*1/sqrt(n)))
print("Wong-Li asymptotics, value = {}".format(x.n()))

print("Ratio = {}".format((b/x).n()))
