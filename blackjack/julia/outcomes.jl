# Julia version 1.0

function partitions(cards, subtotal)

    m = 0
    # Hit
    for i = 1:10
        if (cards[i]>0)
            total = subtotal+i
            if (total < 21)
                # Stand
                m += 1
                # Hit again
                cards[i] -= 1
                m += partitions(cards, total)
                cards[i] += 1
            elseif (total==21)
                # Stand; hit again is an automatic bust
                m += 1
                break
            end
        end
    end
    return m

end

#deck = Array{Int,10}(4,4,4,4,4,4,4,4,4,16)
deck = Int8[4,4,4,4,4,4,4,4,4,16]
d = 0

for i = 1:10
    # Dealer showing
    deck[i] -= 1
    p = 0
    for j = 1:10
        deck[j] -= 1
        p += partitions(deck, j)
        deck[j] += 1
    end
    println("Dealer showing ", i-1," partitions = ",p)
    global d += p
    deck[i] += 1
end

println("Total partitions = ",d)
