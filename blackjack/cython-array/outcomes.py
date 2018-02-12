import partitions
import array

deck = ([4]*9)
deck.append(16)

deck = array.array('i', deck)

d = 0

for i in range(0, 10):

    # Dealer showing

    deck[i] = deck[i]-1

    p = 0
    for j in range(0, 10):
        deck[j] = deck[j]-1
        n = partitions.partitions(deck, j+1)
        #print('Starting with ', j, n)
        deck[j] = deck[j]+1
        p += n

    print('Dealer showing ', i,' partitions =',p)
    d += p

    deck[i] = deck[i]+1

print('Total partitions =',d)
