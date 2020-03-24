
d = 8
p = 23

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

print(p,d)
i = (d-1)*((p^(p-1)-1)/(p-1))+1
print(i,last(i,p))
print()

print(p,d)
i = (d-1)*((p^(p-1)-1)/(p-1))+p^(p-2)
print(i,last(i,p))

#print(i.str(base=p),len(i.str(base=p)))
#j = (d-1)*((p^p-1)/(p-1)) + 1

#x = factorial(i)
#y = factorial(j)

#print(x.str(base=p))
#print(y.str(base=p))

#m = x.ord(p)
#x = x/p^m

#n = y.ord(p)
#y = y/p^n

#print(mod(x,p))
#print(mod(y,p))

#x = factorial(i)
#m = x.ord(p)
#x = x/p^m
#print(mod(x,p))
