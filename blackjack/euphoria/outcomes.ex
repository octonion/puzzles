include std/console.e

function partitions(sequence cards, integer subtotal)
    integer m, total
    
    m = 0
    -- Hit
    for i = 1 to 10 do
        if (cards[i]>0) then
            total = subtotal+i
            if (total < 21) then
                -- Stand
                m += 1
                -- Hit again
                cards[i] -= 1
                m += partitions(cards, total)
                cards[i] += 1
            elsif (total=21) then
                -- Stand; hit again is an automatic bust
                m += 1
                exit
            end if
        end if
    end for
    return m
end function

integer d, p
sequence deck

deck = {4,4,4,4,4,4,4,4,4,16}
d = 0

for i = 1 to 10 do
    -- Dealer showing
    deck[i] -= 1
    p = 0
    for j = 1 to 10 do
        deck[j] -= 1
        p += partitions(deck, j)
        deck[j] += 1
    end for
    deck[i] += 1
    d += p
    display("Dealer showing [] partitions = []",{i-1,p})
end for

display("Total partitions = []",{d})
