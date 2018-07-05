def partitions(cards as (int), subtotal as int) as int:
    m as int = 0
    total as int
    # Hit
    for i in range(10):
        if (cards[i] > 0):
            total = subtotal+i+1
            if (total < 21):
                # Stand
                m += 1
                # Hit again
                cards[i] -= 1
                m += partitions(cards, total)
                cards[i] += 1
            elif (total==21):
                # Stand; hit again is an automatic bust
                m += 1
                break
    return m

deck as (int) = (4,4,4,4,4,4,4,4,4,16)
d as int = 0

for i in range(10):

    # Dealer showing
    deck[i] -= 1
    p as int = 0
    for j in range(10):
        deck[j] -= 1
        p += partitions(deck, j+1)
        deck[j] += 1
    print "Dealer showing ",i," partitions =",p
    d += p
    deck[i] += 1

print "Total partitions =",d
