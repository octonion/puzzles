
m = 2000000
s = [None]*m

s[1] = 1
s[2] = 1

d = 1/20

limit = 2
for n in range(3,m):
    s[n] = s[s[n-1]] + s[n-s[n-1]]
    t = s[n]/n
    if (t<1/2-d) or (t>1/2+d):
        limit = n
    else:
        if (s[n]>=limit+1) and ((n+1)-s[n])>=limit+1:
            print()
            print("epsilon = {}".format(d))
            print("Last n for which |s(n)-1/2| > epsilon is {}.".format(limit))
            print("Proof uses n = {}, for which s[n] = {}.".format(n,s[n]))
            exit()
