Function partitions alias "partitions" (cards() as integer, subtotal as integer) as integer
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
                m = m+partitions(cards(), total)
                cards(i) += 1
            elseif (total=21) then
                ' Stand; hit again is an automatic bust
                m += 1
	    end if
        end if
    next
    return m
end function
