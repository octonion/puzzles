import collections

def update_count(count, eliminated):
    for i in eliminated:
        count[i] -= 1
        if count[i] == 0:
            del count[i]

def kelly_analyze(count, offer):
    k = sum(count.values())
    m = sum([key*i for key,i in count.items()])/k
    print "Mean(cases) =", round(m),", Offer =", offer
    if m > offer:
        p(B) = k*log(B+offer) - sum([i*log(B+key) for key,i in count.items()])
        r = find_root(p(B), 1, 1000000000, maxiter=1000)
        print "Kelly neutral bankroll =", int(round(r))

# February 27, 2006
# Contestant Peter Montesanti

cases = set([0.01,1,5,10,25,50,75,100,200,300,400,500,750,1000,5000,10000,25000,50000,75000,100000,200000,300000,400000,500000,750000,1000000])
count = collections.Counter()
for i in cases:
    count[i] += 1

print "February 27, 2006"
print "Contestant Peter Montesanti"

n = 0
# Round 1 deal

n+=1
print
print "Round", n

eliminated = [1, 25000, 75000, 0.01, 750, 400000]
update_count(count,eliminated)
offer = 17000
kelly_analyze(count,offer)

# Round 2 deal

n+=1
print
print "Round", n
eliminated = [300, 5, 200, 1000000, 50]
update_count(count,eliminated)
offer = 22000
kelly_analyze(count,offer)

# Round 3 deal

n+=1
print
print "Round", n
eliminated = [100000, 5000, 200000, 1000]
update_count(count,eliminated)
offer = 35000
kelly_analyze(count,offer)

# Round 4 deal

n+=1
print
print "Round", n
eliminated = [500, 300000, 50000]
update_count(count,eliminated)
offer = 68000
kelly_analyze(count,offer)

# Round 5 deal

n+=1
print
print "Round", n
eliminated = [10000, 400]
update_count(count,eliminated)
offer = 125000
kelly_analyze(count,offer)

# Round 6 deal

n+=1
print
print "Round", n
eliminated = [75]
update_count(count,eliminated)
offer = 199000
kelly_analyze(count,offer)

# Round 7 deal

n+=1
print
print "Round", n
eliminated = [10]
update_count(count,eliminated)
offer = 279000
kelly_analyze(count,offer)

# Round 8 deal

n+=1
print
print "Round", n
eliminated = [100]
update_count(count,eliminated)
offer = 359000
kelly_analyze(count,offer)

# September 1, 2008
# Contestant Jessica Robinson

cases = [0.01,1,5,10,25,50,75,100,200,300,400,500,750,1000,5000,10000,25000,50000,75000,100000,200000,1000000,1000000,1000000,1000000,1000000]
count = collections.Counter()
for i in cases:
    count[i] += 1

print
print "September 1, 2008"
print "Contestant Jessica Robinson"

n = 0
# Round 1 deal

n+=1
print
print "Round", n
eliminated = [75000, 5, 500, 0.01, 300, 1]
update_count(count,eliminated)
offer = 99000
kelly_analyze(count,offer)

# Round 2 deal

n+=1
print
print "Round", n
eliminated = [1000000, 5000, 100, 10, 1000000]
update_count(count,eliminated)
offer = 78000
kelly_analyze(count,offer)

# Round 3 deal

n+=1
print
print "Round", n
eliminated = [50, 400, 10000, 1000000]
update_count(count,eliminated)
offer = 78000
kelly_analyze(count,offer)

# Round 4 deal

n+=1
print
print "Round", n
eliminated = [25000, 200, 1000000]
update_count(count,eliminated)
offer = 56000
kelly_analyze(count,offer)

# Round 5 deal

n+=1
print
print "Round", n
eliminated = [50000, 75]
update_count(count,eliminated)
offer = 85000
kelly_analyze(count,offer)

# Round 6 deal

n+=1
print
print "Round", n
eliminated = [1000]
update_count(count,eliminated)
offer = 108000
kelly_analyze(count,offer)

# Round 7 deal

n+=1
print
print "Round", n
eliminated = [25]
update_count(count,eliminated)
offer = 173000
kelly_analyze(count,offer)

# Round 8 deal

n+=1
print
print "Round", n
eliminated = [750]
update_count(count,eliminated)
offer = 294000
kelly_analyze(count,offer)

# Round 9 deal

n+=1
print
print "Round", n
eliminated = [100000]
update_count(count,eliminated)
offer = 561000
kelly_analyze(count,offer)
