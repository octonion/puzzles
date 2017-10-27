#!/usr/bin/env python3

deck = [4]*9
deck.append(16)
sd = sum(deck)
p = [x/sd for x in deck]

# Dealer hits soft 17
hit_soft_17 = True

def dealer_p(total, ace, cards):

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

        # Remove blackjacks
        
        if (cards==1 and total==1):
            high=9
        else:
            high=10

        if (cards==1 and total==10):
            low=1
        else:
            low=0
            
        for i in range(low,high):
            l = [p[i]*x for x in dealer_p(total+i+1,(ace or i==0),cards+1)]
            outcomes[:] =[a + b for a, b in zip(outcomes, l)]

    return(outcomes)

def memoize(f):
    class memodict(dict):
        def __getitem__(self, *key):
            return dict.__getitem__(self, key)

        def __missing__(self, key):
            ret = self[key] = f(*key)
            return ret

    return memodict().__getitem__

@memoize
def player_p(total, ace, double, dc):

    # Bust
    if (total > 21):
        return(-1.0, 'bust')

    # Stand
    if (total <= 11 and ace):
        # Stand on total+10
        e_stand = 1.0*sum(dealer[0:total+10]) - 1.0*sum(dealer[total+11:])
    else:
        # Stand on total
        e_stand = 1.0*sum(dealer[0:total]) - 1.0*sum(dealer[total+1:])

    # Double
    if (double):
        e_double = -100.0
    else:
        e_double = 0.0
        for i in range(0,10):
            e_card, strategy = player_p(total+i+1,(ace or i==0),True,dc)
            e_double += 2.0*p[i]*e_card

    # Hit

    # We can't hit again if doubling
    if (double):
        e_hit = -100.0
    else:
        e_hit = 0.0
        for i in range(0,10):
            e_card, strategy = player_p(total+i+1,(ace or i==0),double,dc)
            e_hit += p[i]*e_card

    # If we haven't busted we can always stand
    e_best = e_stand
    strategy = 'stand'
    if not(e_hit==None) and (e_hit > e_best):
        e_best = e_hit
        strategy = 'hit'
    if not(e_double==None) and (e_double > e_best):
        e_best = e_double
        strategy = 'double'
    return(e_best, strategy)

# Dealer has 10 showing
#bj = 1.0*p[0]
#d = dealer_p(10, False, 1)
#d = d/sum(d)
#print(bj)
#print(d)

# Dealer has A showing
#bj = 1.0*p[9]
#d = dealer_p(1, True, 1)
#d = d/sum(d)
#print(bj)
#print(d)

# Dealer has 6 showing
showing = '6'
d = dealer_p(6, False, 1)
dealer = d

# Hard
for i in range(4,22):
    e, s = player_p(i, False, False, 6)
    print('Dealer showing {}, hard {} : {}, E = {:4.2f}'.format(showing,i,s,e))

# Soft
for i in range(2,12):
    e, s = player_p(i, True, False, 6)
    print('Dealer showing {}, soft {} : {}, E = {:4.2f}'.format(showing,i,s,e))

# Dealer has 9 showing
showing = '9'
d = dealer_p(9, False, 1)
dealer = d

# Hard
for i in range(4,22):
    e, s = player_p(i, False, False, 9)
    print('Dealer showing {}, hard {} : {}, E = {:4.2f}'.format(showing,i,s,e))

# Soft
for i in range(2,12):
    e, s = player_p(i, True, False, 9)
    print('Dealer showing {}, soft {} : {}, E = {:4.2f}'.format(showing,i,s,e))
    
# Dealer has A showing
showing = 'A'

# Blackjack
bj = 1.0*p[9]
d = dealer_p(1, True, 1)

# Conditional on not blackjack
dealer = [x/sum(d) for x in d]

# Hard
for i in range(4,22):
    e, s = player_p(i, False, False, 1)
    print('Dealer showing {}, hard {} : {}, E = {:4.2f}'.format(showing,i,s,e))

# Soft
for i in range(2,12):
    e, s = player_p(i, True, False, 1)
    print('Dealer showing {}, soft {} : {}, E = {:4.2f}'.format(showing,i,s,e))
