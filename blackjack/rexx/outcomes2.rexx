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
        p = p+partitions(j)
        deck.j = deck.j +1
    end
    deck.i = deck.i+1
    say "Dealer showing " i-1 " partitions =" p
    d = d+p
end
say "Total partitions =" d

exit

partitions: procedure expose deck.

    subtotal = arg(1)
    m = 0
    /* Hit */
    do i = 1 to 10
        if (deck.i>0) then
        do
            total = subtotal+i
            if (total < 21) then
            do
                /* Stand */
                m = m+1
                /* Hit again */
		deck.i = deck.i -1
                m = m+partitions(total)
		deck.i = deck.i +1
	    end
            else
            do
                if (total==21) then
                do
                    /* Stand; hit again is an automatic bust */
                    m = m+1
		    return m
                end
            end
        end
    end
    return m
