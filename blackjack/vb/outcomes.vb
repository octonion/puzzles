module outcomes

function partitions(cards() as integer, subtotal as integer) as integer

    dim i as integer
    dim m as integer
    dim total as integer
    m = 0
    ' Hit
    for i = 0 to 9
        if (cards(i)>0) then
            total = subtotal+i+1
            if (total < 21) then
                ' Stand
                m += 1
                ' Hit again
		cards(i) -= 1
                m = m+partitions(cards, total)
                cards(i) += 1
            elseif (total=21) then
                ' Stand; hit again is an automatic bust
                m += 1
	    end if
        end if
    next
    return m
end function

sub main()

dim deck = new integer(9) {4,4,4,4,4,4,4,4,4,16}
dim d as integer
dim i as integer
dim p as integer
dim j as integer
d = 0

for i = 0 to 9
    ' Dealer showing
    deck(i) -= 1
    p = 0
    for j = 0 to 9
        deck(j) -= 1
        p += partitions(deck, j+1)
        deck(j) += 1
    next
    console.writeline("Dealer showing {0} partitions = {1}", i, p)
    d += p
    deck(i) += 1
next

console.writeline("Total partitions = {0}", d)

end sub

end module