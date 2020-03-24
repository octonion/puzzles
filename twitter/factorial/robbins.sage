R = RealField(1000); R
RealNumber = R

n=10^9

lower=log(sqrt(2*pi))+(n+1/2)*log(n)-n+1/(12*n)
upper=log(sqrt(2*pi))+(n+1/2)*log(n)-n+1/(12*n+1)

print("lower = {0}".format(exp(lower).n()))
print("upper = {0}".format(exp(upper).n()))

