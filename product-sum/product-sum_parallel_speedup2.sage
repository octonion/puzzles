#!/usr/bin/sage -python

# Find all sets of n positive integers with equal product and sum

from sys import argv
from sage.all import *
from operator import mul, add

from sage.parallel.multiprocessing_sage import pyprocessing
import multiprocessing

# Problem requires n >= 2

try:   
    n = eval(argv[1])
except IndexError:  
   print
   print("Usage: product-sum.sage %1")
   print("%1 can be a number (10) or an expression (10**6+1) to evaluate")
   print
   sys.exit()

def solve(lv):

    s = 0

    if (lv==0):
        product = 1
        sum = n-2
        term = sum*product + 1
        
        factors = divisors(term)
        nf = (len(factors)+1)//2
        #nf = floor((len(factors)+1)/2)

        for div in xrange(0, nf):
            a = (factors[div]+1)//product
            b = (term//factors[div]+1)//product
            solution = [b, a]
            print(solution)
            s += 1

        return(s)

    s = 0

    values = [2]*lv

    if (2*lv+(n-lv)+2*2 < (2**lv)*2*2):
        return(s)

    i = 0
    while (i < lv):

        large = values[0]

        sum = reduce(add, values)+(n-lv-2)
        product = reduce(mul, values)

        if (sum+2*large < product*large*large):
            i += 1
            if (i < lv):
                values[i] += 1
                small = values[i]
                for j in xrange(0,i):
                    values[j] = small
        else:
            #x = floor(sum/product)+1 # a*b
            x = sum//product+1 # a*b
            y = sum-x*product # -(a+b)
            
            up = (sum-large**2+2*large)//(product-1)-x
            #up2 = floor((sum-large**2+2*large)/product)
            #print("large = %s, x=%s, y=%s, x+y+1=%s, up=%s" % (large,x,y,x+y+1,up))
            #if (x+y+1 <= (large*large-2*large)):
            if (up < 0):
                i = 0
                values[i] += 1
                continue
            elif (up==0):
                if not(is_square((x*product-sum)**2-4*x)):
                    i = 0
                    values[i] += 1
                    continue
            elif (up==1):
                if not(is_square((x*product-sum)**2-4*x)) and not(is_square(((x+1)*product-sum)**2-4*(x+1))):
                    i = 0
                    values[i] += 1
                    continue
            elif (up==2):
                if not(is_square((x*product-sum)**2-4*x)) and not(is_square(((x+1)*product-sum)**2-4*(x+1))) and not(is_square(((x+2)*product-sum)**2-4*(x+2))):
                    i = 0
                    values[i] += 1
                    continue
            elif (up==3):
                if not(is_square((x*product-sum)**2-4*x)) and not(is_square(((x+1)*product-sum)**2-4*(x+1))) and not(is_square(((x+2)*product-sum)**2-4*(x+2))) and not(is_square(((x+3)*product-sum)**2-4*(x+3))):
                    i = 0
                    values[i] += 1
                    continue
            
            term = sum*product + 1

            factors = divisors(term)

            #nf = floor((len(factors)+1)/2)
            nf = (len(factors)+1)//2

            pl = product*large-1
            rf = filter(lambda x: ((x >= pl) and ((x+1)%product)==0), factors[0:nf])
            counts = len(rf)

            if (counts>0):

                for factor in rf:
                    a = (factor+1)//product
                    b = (term//factor+1)//product
                    solution = [b,a]+values
                    print(solution)
                    s += 1

            i = 0
            values[i] += 1

    #print(lv,s)
    return(s)

top = round(log(n, 2))

num_cores = multiprocessing.cpu_count()
use_cores = num_cores//2 #floor(num_cores/2)
print
print("Using %s CPU cores" % use_cores)
print

P = parallel(p_iter=use_cores)

v = list(P(solve)(range(0, top)))

s = 0
for i in v:
    s += i[1]
    
print
print('Finished n=%s, solutions=%s' % (n, s))
