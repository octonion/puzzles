#!/usr/bin/env python3

#import numpy as np

# Number of decks

n = 1

deck = [4*n]*9
deck.append(16*n)

# Dealer hits soft 17
hit_soft_17 = False

# Double after split
double_after_split = True

# Resplit aces
resplit_aces = False

class memoize:
    def __init__(self, func):
        self.func = func
        self.known = {}

    def __call__(self, *args, **kwargs):
        key = give_fake_hash((args, kwargs))

        try:
            return self.known[key]
        except KeyError:
            value = self.func(*args, **kwargs)
            self.known[key] = value
            return value

def give_fake_hash(obj):
    cls = type(obj)
    name = "Hashable" + cls.__name__

    def fake_hash(self):
        return hash(repr(self))

    t = type(name, (cls, ), {"__hash__": fake_hash})

    return t(obj)

@memoize
def dealer_p(total, ace, cards, n):

    outcomes = [0.0]*22
    
    if (total > 21):
        
        # Dealer busts
        outcomes[0] = 1.0
        
    elif (total >= 17):

        # Dealer stands
        outcomes[total] = 1.0

    elif ((total==7) and ace and not(hit_soft_17)):
        
        # Dealer stands on a soft 17
        outcomes[total+10] = 1.0

    elif ((8 <= total <= 11) and ace):

        # Dealer stands on a soft total > 17
        outcomes[total+10] = 1.0

    else:

        # Dealer hits

        for i in range(0,10):
            if (cards[i]>0):
                p = cards[i]/n
                cards[i] += -1
                # Can we speed this up?
                d = dealer_p(total+i+1, (ace or i==0), cards, n-1)
                for j in range(0,22):
                    outcomes[j] += p*d[j]
                #l = [p*x for x in dealer_p(total+i+1,(ace or i==0),cards,n-1)]
                #outcomes[:] = [a+b for a, b in zip(outcomes, l)]
                cards[i] += 1

    return(outcomes)

@memoize
def player_p(total, ace, cards, dc, n):

    # Bust
    if (total > 21):
        return(-1.0, 'bust')

    # Stand
    if (total <= 11 and ace):
        # Stand on total+10
        d = dealer_p(dc, (dc==0), cards, n)
        e_stand = sum(d[0:total+10])-sum(d[total+11:])
    else:
        # Stand on total
        d = dealer_p(dc, (dc==0), cards, n)
        e_stand = sum(d[0:total])-sum(d[total+1:])

    # Hit
    e_hit = 0.0
    for i in range(0,10):
        if (cards[i]>0):
            p = cards[i]/n
            cards[i] += -1
            e_card, strategy = player_p(total+i+1,(ace or i==0),cards,dc,n-1)
            e_hit += p*e_card
            cards[i] += 1

    # If we haven't busted we can always stand
    e_best = e_stand
    strategy = 'stand'
    if (e_hit > e_best):
        e_best = e_hit
        strategy = 'hit'
    return(e_best, strategy)

for i in range(1, 9):
    # Dealer
    deck[i] += -1

    for j in range(0,10):
        deck[j] += -1
        for k in range(j,10):
            
            deck[k] += -1
            e, s = player_p(j+k+2, (j==0 or k==0), deck, i+1, sum(deck))
            print('Dealer showing {}, hand {}/{} : {}, E = {:4.2f}'.format(i+1,j+1,k+1,s,e))
            deck[k] += 1
        deck[j] += 1
    deck[i] += 1
