#!/usr/bin/sage -python

# Find all sets of n positive integers with equal product and sum

from sys import argv
from sage.all import *
from operator import mul, add

# Problem requires n >= 2

try:   
    n = eval(argv[1])
except IndexError:  
   print()
   print("Usage: product-sum.sage %1")
   print("%1 can be a number (10) or an expression (10**6+1) to evaluate")
   print()
   sys.exit()

s = 0

print()
print('Running n=%s' % n)
print()

#term = n-1
#d = floor((divisor_count(term)+1)/2)
product = 1
sum = n-2
term = sum*product + 1

factors = divisors(term)
nf = floor((len(factors)+1)/2)
#print(factors)

for div in range(0, nf):
    if ((factors[div]+1) % product)==0:
        a = (factors[div]+1)/product
        #print()
        b = (term/factors[div]+1)/product
        solution = [b, a]
        print(solution)
        #print('n=%s factored(%s) solution=%s' % (n, term, solution))
        s += 1

top = round(log(n, 2))

for lv in range(1, top):

    #print(lv)

    values = [2]*lv

    if (2*lv+(n-lv)+2*2 < (2**lv)*2*2):
        continue

    i = 0
    while (i < lv):

        #if (i>=3):
        #    print(values)

        large = values[0]

        sum = reduce(add, values)+(n-lv-2)
        product = reduce(mul, values)

        if (sum+2*large < product*large*large):
            i += 1
            if (i < lv):
                values[i] += 1
                small = values[i]
                for j in range(0,i):
                    values[j] = small
        else:

            x = floor(sum/product)+1
            y = sum-x*product

            if ((x+y+1)<=(large*large-2*large)):
                i = 0
                values[i] += 1
                continue

            term = sum*product + 1
            
            #if ((x+y+1)>0):
            #    print(" x+y+1 = %s" % (x+y+1))
            #    tfactors = divisors(x+y+1)
            #    tnf = floor((len(tfactors)+1)/2)
            #    print(" tnf = %s" % tnf)
            #else:
            #    print(" negative")

            factors = divisors(term)

            nf = floor((len(factors)+1)/2)

            pl = product*large-1
            rf = list(filter(lambda x: ((x >= pl) and ((x+1)%product)==0), factors[0:nf]))
            counts = len(rf)

            if (counts>0):
                #print(" rf = %s" % rf)
                #print(" counts = %s" % counts)
                
                for factor in rf:
                    a = (factor+1)/product
                    b = (term/factor+1)/product
                    solution = [b,a]+values
                    print(solution)
                    s += 1
                        
            i = 0
            values[i] += 1
print()
print('Finished n=%s, solutions=%s' % (n, s))
