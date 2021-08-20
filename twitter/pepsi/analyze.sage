import collections

def kelly_analyze(gambles, offer):

    p(b) = log(1+offer/b) - sum([p*log(1+value/b) for (p,value) in gambles])
    r = find_root(p(b), 1, 1000000000, maxiter=10000)
    return(r)

for i in range(10,1,-1):
    
    neutral = set()
    for j in range(i-1,1,-1):
        offer = (10-i)*10000+20000
        gambles = {(j/i,20000+(10-j)*10000)}
        ev = j/i*(20000+(10-j)*10000)
        if (ev <= offer):
            continue
        neutral.add(kelly_analyze(gambles,offer))

    offer = (10-i)*10000+20000
    gambles = {(1/i*999/1000,1000000),(1/i*1/1000,1000000000)}
    neutral.add(kelly_analyze(gambles,offer))
    m = min(neutral)
    print(f"With {i} players left, Kelly neutral bankroll is {m}.")

