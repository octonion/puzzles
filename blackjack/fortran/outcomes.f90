program outcomes

  integer, dimension(1:10) :: deck
  integer :: d,n,p
  integer, external :: partitions
  
  deck = (/ (4, i = 1,10) /)
  deck(10) = 16

  d = 0
  
  do i = 1, 10
     ! Dealer showing
     deck(i) = deck(i)-1

     p = 0
     do j = 1, 10
	deck(j) = deck(j)-1
        n = partitions(deck, j)
	deck(j) = deck(j)+1
        p = p+n
     end do

     print *,"Dealer showing ",i," partitions =",p
     d = d+p
     deck(i) = deck(i)+1
  end do

  print *,"Total partitions =",d
 
end program outcomes

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
