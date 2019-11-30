import collections
import csv

def kelly_analyze(count, offer):
    k = sum(count.values())
    m = sum([key*i for key,i in count.items()])/k
    print "Mean(cases) =", round(m),", Offer =", offer
    if m > offer:
        p(B) = k*log(B+offer) - sum([i*log(B+key) for key,i in count.items()])
        try:
            r = find_root(p(B), 1, 10000000000, maxiter=10000)
            print "Kelly neutral bankroll =", int(round(r))
        except:
            print "Mean(cases) > Offer, Kelly neutral bankroll = infinite"
    else:
        print "Mean(cases) < Offer, Kelly neutral bankroll = infinite"

id = None
with open("data/US.csv") as f:
    reader = csv.DictReader(f, delimiter=",")
    for row in reader:
        
        if not(row["ID Number"]==id):
            id = row["ID Number"]==id
            name = row["Name"]
            date = row["Broadcast Date"]
            print
            print name
            print date
            
        print "Round =", row["ROUND"]
        count = collections.Counter()
        count[0.01] = int(row["0.01"])
        count[1] = int(row["1"])
        count[5] = int(row["5"])
        count[10] = int(row["10"])
        count[25] = int(row["25"])
        count[50] = int(row["50"])
        count[75] = int(row["75"])
        count[100] = int(row["100"])
        count[200] = int(row["200"])
        count[300] = int(row["300"])
        count[400] = int(row["400"])
        count[500] = int(row["500"])
        count[750] = int(row["750"])
        count[1000] = int(row["1000"])
        count[5000] = int(row["5000"])
        count[10000] = int(row["10000"])
        count[25000] = int(row["25000"])
        count[50000] = int(row["50000"])
        count[75000] = int(row["75000"])
        count[100000] = int(row["100000"])
        count[200000] = int(row["200000"])
        count[300000] = int(row["300000"])
        count[400000] = int(row["400000"])
        count[500000] = int(row["500000"])
        count[750000] = int(row["750000"])
        count[1000000] = int(row["1000000"])
        for i in count.keys():
            if count[i] == 0:
                del count[i]

        offer = int(row["Bank Offer"])
        kelly_analyze(count,offer)
        print "Player's chose", row["Deal / No Deal"]
