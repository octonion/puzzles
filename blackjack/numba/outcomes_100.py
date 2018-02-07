import numba

@numba.jit(nopython=True)
def partitions(cards, subtotal):

    m = 0
    # Hit
    for i in range(0, 10):
        if (cards[i]>0):
            
            cards[i] = cards[i]-1
            total = subtotal+i+1
            
            if (total < 21):
                
                # Stand
                m += 1
                #print(cards, total)
                # Hit again
                m += partitions(cards, total)
                
            elif (subtotal+i+1==21):
                
                # Stand; hit again is an automatic bust
                m += 1
                #print(cards, total)
                
            cards[i] = cards[i]+1
                
    return(m)

deck = ([4]*9)
deck.append(16)

for k in range(0,100):
    
    d = 0

    for i in range(0, 10):

        # Dealer showing

        deck[i] = deck[i]-1

        p = 0
        for j in range(0, 10):
            deck[j] = deck[j]-1
            n = partitions(deck, j+1)
            #print('Starting with ', j, n)
            deck[j] = deck[j]+1
            p += n

        print('Dealer showing ', i,' partitions =',p)
        d += p

        deck[i] = deck[i]+1

    print('Total partitions =',d)
