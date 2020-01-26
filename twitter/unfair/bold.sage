# b = initial bankroll
# w = win probability
# r = net return fraction on bet if we win
# p = probability of reaching 1 before busting
# c = current state probability

b = 1/2
w = 1/2
r = 1/2
p = 0
c = 1

for i in range(0,500):
    
    if (1+r)*b < 1:
        # Bet all
        c = w*c
        b = (1+r)*b
    else:
        # Bet x such that x*r + b = 1
        # x = (1-b)/r
        # Win
        p += w*c
        # Lose
        b -= (1-b)/r
        c = (1-w)*c
    # Finished on a stopper
    if (b==0):
        break

print(p)
print(p.n(prec=400))
