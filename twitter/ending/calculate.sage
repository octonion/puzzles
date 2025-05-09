
# Calculate the last non-zero digit of x! base p

def last(x,p):
    if x<p:
        return(mod(factorial(x),p))
    else:
        y = floor(x/p)
        r = (mod(x,p)).lift()
        if (mod(y,2)==1):
            return(-last(y,p)*mod(factorial(r),p))
        else:
            return(last(y,p)*mod(factorial(r),p))

d = 50
p = 101

print(f"p={p}, d={d}")
i = (d-1)*((p^(p-1)-1)/(p-1))+1
print(f"{i}! ends in {last(i,p)} base {p}")
print()

print(f"p={p}, d={d}")
i = (d-1)*((p^(p-1)-1)/(p-1))+p^(p-2)
print(f"{i}! ends in {last(i,p)} base {p}")
print()

d = 7
p = 13

print(f"p={p}, d={d}")
i = (d-1)*((p^(p-1)-1)/(p-1))+1
print(i.str(base=p))
print(f"{i}! ends in {last(i,p)} base {p}")
print()

print(f"p={p}, d={d}")
i = (d-1)*((p^(p-1)-1)/(p-1))+p^(p-2)
print(i.str(base=p))
print(f"{i}! ends in {last(i,p)} base {p}")
print()

d = 4
p = 11

print(f"p={p}, d={d}")
i = (d-1)*((p^(p-1)-1)/(p-1))+1
print(i.str(base=p))
print(f"{i}! ends in {last(i,p)} base {p}")
print()

print(f"p={p}, d={d}")
i = (d-1)*((p^(p-1)-1)/(p-1))+p^(p-2)
print(i.str(base=p))
print(f"{i}! ends in {last(i,p)} base {p}")
