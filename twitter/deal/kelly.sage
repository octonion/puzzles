# February 27, 2006
# Contestant Peter Montesanti

cases = set([0.01,1,5,10,25,50,75,100,200,300,400,500,750,1000,5000,10000,25000,50000,75000,100000,200000,300000,400000,500000,750000,1000000])

n = 0
# Round 1 deal

n+=1
print
print "Round", n
cases.difference_update({1, 25000, 75000, 0.01, 750, 400000})
offer = 17000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 2 deal

n+=1
print
print "Round", n
cases.difference_update({300, 5, 200, 1000000, 50})
offer = 22000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 3 deal

n+=1
print
print "Round", n
cases.difference_update({100000, 5000, 200000, 1000})
offer = 35000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 4 deal

n+=1
print
print "Round", n
cases.difference_update({500, 300000, 50000})
offer = 68000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 5 deal

n+=1
print
print "Round", n
cases.difference_update({10000, 400})
offer = 125000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 6 deal

n+=1
print
print "Round", n
cases.difference_update({75})
offer = 199000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 7 deal

n+=1
print
print "Round", n
cases.difference_update({10})
offer = 279000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))

# Round 8 deal

n+=1
print
print "Round", n
cases.difference_update({100})
offer = 359000
print "Mean(cases) =", round(mean(cases).n()),", Offer =", offer
p(B) = (len(cases))*log(B+offer) - sum([log(B+i) for i in cases])
r = find_root(p(B), 1, 1000000000, maxiter=1000)
print "Kelly neutral bankroll =", int(round(r))
