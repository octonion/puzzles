def idot(x, y):
    m = len(x)
    n = len(y)
    # Needs error checking
    if m != n:
        return 0
    return max([x[i]*y[i] for i in xrange(0,m)])

class Exchange:
    def __init__(self, x):
        self.x = matrix(x)
    def __str__(self):
        return str(self.x)
    def __mul__(self, other):
        return Exchange([[idot(row,column) for column in other.x.columns()] for row in self.x.rows()])
    def __pow__(self, n):
        # Needs error checking
        P = Exchange(matrix.identity(self.x.nrows()))
        A = self
        m = n
        while m >= 1:
            if (m%2)==1:
                P = P*A
            m = floor(m/2)
            A = A*A
        return P

m = [[1,95/100,8/10],[8/10,1,12/10],[95/100,8/10,1]]
c = Exchange(m)

print "c^2 = ",c^2
print "c^3 = ",c^3
print "c^4 = ",c^4
print "c^5 = ",c^5
print "c^6 = ",c^6
