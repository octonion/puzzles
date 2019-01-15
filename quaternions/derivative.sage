Q.<i,j,k> = QuaternionAlgebra(SR,-1,-1)

t = var('t')

w = 3 + 3 * i + 11 * j + 7 * k

v = t
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*i
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*j
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*k
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*(1 + 2 * i + 3 * j + 4 * k)
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*(3 + 2 * i + 2 * j + 17 * k)
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*(1 - 2 * i - 3 * j - 4 * k)
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*(3 - 2 * i - 2 * j - 17 * k)
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)

v = t*(3 - 2 * i + 2 * j - 17 * k)
x = 1/2*(2*w + 1/v*w*v + v*w*1/v)
print(x)
