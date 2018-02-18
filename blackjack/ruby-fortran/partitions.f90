recursive integer function partitions(cards,subtotal) result(m)
  integer :: total
  integer, dimension(1:10) :: cards
  integer :: subtotal

  m = 0
  ! Hit
  do i = 1, 10
     if (cards(i)>0) then
        cards(i) = cards(i)-1
        total = subtotal+i
        if (total < 21) then
           ! Stand
           m = m+1
           ! Hit again
           m = m+partitions(cards, total)
        else if (subtotal+i==21) then
           ! Stand; hit again is an automatic bust
           m = m+1
        end if
        cards(i) = cards(i)+1
     end if
  end do

end function partitions
