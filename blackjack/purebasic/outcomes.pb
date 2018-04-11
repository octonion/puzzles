procedure partitions(array cards(1), subtotal);

    m = 0
    ; Hit
    for i = 0 to 9
        if (cards(i) > 0)
            total = subtotal+i+1
            if (total < 21)
                ; Stand
                m = m+1
                ; Hit again
		cards(i) = cards(i)-1
                m = m+partitions(cards(), total)
                cards(i) = cards(i)+1
            elseif (total = 21)
                ; Stand; hit again is an automatic bust
                m = m+1
	    endif
        endif
    next
    procedurereturn m
endprocedure

dim deck(10)

deck(0) = 4
deck(1) = 4
deck(2) = 4
deck(3) = 4
deck(4) = 4
deck(5) = 4
deck(6) = 4
deck(7) = 4
deck(8) = 4
deck(9) = 16

d = 0

; Dealer showing
for i = 0 to 9
    deck(i) = deck(i)-1
    p = 0
    for j = 0 to 9
        deck(j) = deck(j)-1
	p = p+partitions(deck(), j+1)
        deck(j) = deck(j)+1
    next
    d = d+p
    printn("Dealer showing " + i + " partitions = " + p)
    deck(i) = deck(i)+1
next
printn("Total partitions = " + d)
