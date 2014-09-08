#! /usr/bin/env python
# -*- coding: utf-8 -*-
 
from math import sqrt
 
# See:
# http://en.wikipedia.org/wiki/Chakravala_method#The_method
# http://kappadath-gopal.blogspot.com/2013/04/ancient-medieval-indian-mathematics.html
# http://jwb.io/20121231-the-euclidean-algorithm-and-chakravala-method-in-ruby.html

def chakravala(N):
    # Return the minimal solution (x, y) for the Diophantine
    # equation x^2 - Ny^2 == 1
    m = m0 = int(round(sqrt(N)))
    a, b, k = m, 1, m*m - N
    if k == 0:
        # no solution if N is a perfect square
        return (None, None)
 
    while k != 1:
        # terminate if k in [-1, ±2], or k is ±4 and a or b is even
        if k == -1 or abs(k) == 2 or (abs(k) == 4 and not (a&1 and b&1)):
            # compose (a, b, k) with (a, b, k) and return solution
            return ((a*a + N*b*b)//abs(k), 2*a*b//abs(k))
 
        # find m such that: (a + b*m) % k == 0, abs(m^2 - N) is minimized
        diff = (m + m0) % abs(k)
        m_lo = m0 - diff
        m_hi = m_lo + abs(k)
        m = m_hi if abs(m_hi*m_hi - N) < abs(m_lo*m_lo - N) else m_lo
 
        # compose (a, b, k) with (m, 1, m^2 - N)
        a, b, k = (m*a + N*b)//abs(k), (a + b*m)//abs(k), (m*m - N)//k
    return (a, b)
 
def solve(limit=1000):
    return max(xrange(2, limit+1), key=lambda D: chakravala(D)[0])
 
if __name__ == '__main__':
    print solve()
