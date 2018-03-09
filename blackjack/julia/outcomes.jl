function partitions(cards, subtotal)

    m = 0
    # Hit
    for i = 1:10
        if (cards[i]>0)
            total = subtotal+i
            if (total < 21)
                cards[i] -= 1
                # Stand
                m += 1
                # Hit again
                m += partitions(cards, total)
                cards[i] += 1
            elseif (total==21)
                # Stand; hit again is an automatic bust
                m += 1
            end
        end
    end
    return m

end

deck = [4,4,4,4,4,4,4,4,4,16]
global d = 0

for i = 1:10

    # Dealer showing
    deck[i] -= 1
    p = 0
    for j = 1:10
        deck[j] -= 1
        n = partitions(deck, j)
        deck[j] += 1
        p += n
    end
    println("Dealer showing ", i," partitions = ",p)
    d += p
    deck[i] += 1
end

println("Total partitions = ",d)
