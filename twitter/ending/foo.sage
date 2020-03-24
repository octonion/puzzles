
# Calculate the last non-zero digit of x! base p

def last(x,q):
    print(x)
    if x<q:
        return(mod(factorial(x),q))
    else:
        y = floor(x/q)
        r = (mod(x,q)).lift()
        if (mod(y,2)==1):
            return(-last(y,q)*mod(factorial(r),q))
        else:
            return(last(y,q)*mod(factorial(r),q))

d = 4
p = 3
k = 2

print(f"p={p}, k={k}, d={d}")
i = (d-1)*((p^euler_phi(p^k)-1)/(p-1))+1
print(f"{i}! ends in {last(i,p^k)} base {p^k}")
#print()

#print(f"p={p}, d={d}")
#i = (d-1)*((p^euler_phi(p^k)-1)/(p-1))+p^(euler_phi(p^k)-1)
#print(f"{i}! ends in {last(i,p^k)} base {p^k}")
#print()
