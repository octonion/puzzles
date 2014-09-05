#!/usr/bin/sage -python

# Find all sets of n positive integers with equal product and sum

from sys import argv
from sage.all import *
from operator import mul, add

# Problem requires n >= 2


try:   
    n = eval(argv[1])
except IndexError:  
   print
   print("Usage: product-sum.sage %1")
   print("%1 can be a number (10) or an expression (10**6+1) to evaluate")
   print
   sys.exit()

s = 0

print
print('Running n=%s' % n)
print

#term = n-1
#d = floor((divisor_count(term)+1)/2)
product = 1
sum = n-2
term = sum*product + 1

factors = divisors(term)
nf = floor((len(factors)+1)/2)
#print(factors)

for div in xrange(0, nf):
    if ((factors[div]+1) % product)==0:
        a = (factors[div]+1)/product
        #print
        b = (term/factors[div]+1)/product
        solution = [b, a]
        print(solution)
        #print('n=%s factored(%s) solution=%s' % (n, term, solution))
        s += 1

top = round(log(n, 2))

for lv in xrange(1, top):
    #print(lv)

    values = [2]*lv

    if (2*lv+(n-lv)+2*2 < (2**lv)*2*2):
        break

    i = 0
    while (i < lv):

        #print(i, values)

        large = values[0]

        sum = reduce(add, values)+(n-lv-2)
        product = reduce(mul, values)

        #print(sum+2*large, product*large*large)

        if (sum+2*large < product*large*large):
            i += 1
            if (i < lv):
                values[i] += 1
                small = values[i]
                for j in xrange(0,i):
                    values[j] = small
        else:
            term = sum*product + 1

	    # Only guaranteed to also be prime if term < 1.845*10**19
	    # If working with larger factors switch to:
	    #if (is_prime(term)):

            if (is_pseudoprime(term)):
                i = 0
                values[i] += 1
                continue

            factors = divisors(term)

            nf = floor((len(factors)+1)/2)

            for div in range(1, nf):
                if ((factors[div]+1) % product)==0:
                    a = (factors[div]+1)/product
                    if (a<large):
                        continue
                    #print
                    b = (term/factors[div]+1)/product
                    #print(values)
                    solution = [b,a]+values
                    #print('n=%s factored(%s) solution=%s' % (n, term, solution))
                    print(solution)
                    s += 1
            i = 0
            values[i] += 1
print
print('Finished n=%s, solutions=%s' % (n, s))
