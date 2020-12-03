import cmath

z = complex(1,0)
print(z)
for i in range(0,50):
    z = cmath.cos(z)
print(z)

z = complex(1,1)
print(z)
for i in range(0,50):
    z = cmath.cos(z)
print(z)

z = complex(0,1)
print(z)
for i in range(0,50):
    z = cmath.cos(z)
print(z)

z = complex(2,2)
print(z)
for i in range(0,50):
    try:
        z = cmath.cos(z)
    except:
        print("Does not converge.")
        break
print(z)
