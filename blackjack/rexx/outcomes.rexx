#!/usr/bin/env rexx

do i = 1 to 9
  deck.i = 4
end
deck.10 = 16

d = 0

do i = 1 to 10
    /* Dealer showing */
    deck.i = deck.i-1
    p = 0
    do j = 1 to 10
        deck.j = deck.j -1
        p = p+partitions(deck.1,deck.2,deck.3,deck.4,deck.5,deck.6,deck.7,deck.8,deck.9,deck.10,j)
        deck.j = deck.j +1
    end
    deck.i = deck.i+1
    say "Dealer showing " i-1 " partitions =" p
    d = d+p
end
say "Total partitions =" d

exit

partitions: procedure

    do i = 1 to 10
      cards.i = arg(i)
    end
    subtotal = arg(11)
    m = 0
    /* Hit */
    do i = 1 to 10
        if (cards.i>0) then
        do
            total = subtotal+i
            if (total < 21) then
            do
                /* Stand */
                m = m+1
                /* Hit again */
		cards.i = cards.i -1
                m = m+partitions(cards.1,cards.2,cards.3,cards.4,cards.5,cards.6,cards.7,cards.8,cards.9,cards.10,total)
		cards.i = cards.i +1
	    end
            else
            do
                if (total==21) then
                do
                    /* Stand; hit again is an automatic bust */
                    m = m+1
                end
            end
        end
    end
    return m
