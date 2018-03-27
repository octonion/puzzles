#!/usr/bin/env python

deck = ([4]*9)
deck.append(16)

def partitions(cards, subtotal):

    m = 0
    # Hit
    for i in range(0,10):
        if (cards[i]>0):
            
            total = subtotal+i+1
            
            if (total < 21):

                cards[i] -= 1
                # Stand
                m += 1
                # Hit again
                m += partitions(cards, total)
                cards[i] += 1
                
            elif (subtotal+i+1==21):
                
                # Stand; hit again is an automatic bust
                m += 1
                
    return(m)

d = 0

for i in range(0,10):

    # Dealer showing

    deck[i] -= 1

    p = 0
    for j in range(0,10):
        deck[j] -= 1
        n = partitions(deck, j+1)
        deck[j] += 1
        p += n

    print('Dealer showing ', i,' partitions =',p)
    d += p

    deck[i] += 1

print('Total partitions =',d)
