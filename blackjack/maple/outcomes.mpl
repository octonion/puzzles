restart;
kernelopts(printbytes=false):
partitions := proc(c::list(integer),subtotal::integer) :: integer:
  local i,m,total,cards;
  cards := c;
  m := 0;
  # Hit
  for i from 1 to 10 do
    if (cards[i]>0) then
      total := subtotal+i;
      if (total < 21) then
        # Stand
        m := m+1;
	# Hit again
        cards[i] := cards[i]-1;
        m := m+partitions(cards, total);
        cards[i] := cards[i]+1;
      elif (total=21) then
        # Stand; hit again is an automatic bust
        m := m+1;
      end if;
    end if;
  end do;
  return m;
end proc:

deck := [4,4,4,4,4,4,4,4,4,16]:
d := 0:

for i from 1 to 10 do
  # Dealer showing
  p := 0:
  deck[i] := deck[i]-1:
  for j from 1 to 10 do
    deck[j] := deck[j]-1:
    p := p+partitions(deck,j):
    deck[j] := deck[j]+1:
  end do:
  deck[i] := deck[i]+1:
  printf("Dealer showing %d partitions = %d\n",i-1,p):
  d := d+p:
end do:
printf("Total partitions = %d\n",d):
