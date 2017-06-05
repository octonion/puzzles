#!/usr/bin/sage

# Transition matrix

T = matrix(QQ, 7)

for i in range(0,6):
    T[i,i] = i/6
    T[i,i+1] = (6-i)/6

T[6,6]=1

rolls = 5

# Outcome matrix

O = T^rolls

# Expected number of different outcomes

E = 0
for i in range(1,7):
    E = E+i*O[0,i]

print(E)
print(float(E))
