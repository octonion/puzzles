#using Memoize : @memoize

deck = [4,4,4,4,4,4,4,4,4,16]

function partitions(cards, subtotal)

    m = 0
    
    # Hit
    for i = 1:10
        if (cards[i]>0)
            
            cards[i] = cards[i]-1
            total = subtotal+i
            
            if (total < 21)
                
                # Stand
                m += 1
                #println(cards, total)
                # Hit again
                m += partitions(cards, total)
                
            elseif (total==21)
                
                # Stand; hit again is an automatic bust
                m += 1
                #println(cards, total)
                
            end
                
            cards[i] = cards[i]+1

        end

    end
                
    return m

end

d = 0

for i = 1:10

    # Dealer showing

    deck[i] = deck[i]-1

    p = 0
    for j = 1:10
        deck[j] = deck[j]-1
        n = partitions(deck, j)
        #println("Starting with ",j," ",n)
        deck[j] = deck[j]+1
        p += n
    end

    println("Dealer showing ", i," partitions = ",p)
    d += p

    deck[i] = deck[i]+1

end

println("Total partitions = ",d)
