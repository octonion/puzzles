program outcomes;

type
   stack = array[0..9] of integer;

var
   deck	   : stack = (4,4,4,4,4,4,4,4,4,16);
   i, j	   : integer;
   d, p    : longint;

function partitions(cards: stack; subtotal: integer): longint;
var
  i, total : integer;
begin
   partitions := 0;
   // Hit
   for i := 0 to 9 do
      begin
	 if (cards[i]>0) then
	 begin
	    total := subtotal+i+1;
	    if (total < 21) then
	    begin
	       // Stand
	       partitions += 1;
	       // Hit again
	       cards[i] -= 1;
	       partitions += partitions(cards, total);
	       cards[i] += 1;
	    end
	    else
	       if (total=21) then
		  // Stand; hit again is an automatic bust
		  partitions += 1;
	 end;
      end;
end;
    
begin
   d := 0;
   for i := 0 to 9 do
   begin
      // Dealer showing
      deck[i] -= 1;
      p := 0;
      for j := 0 to 9 do
      begin
	 deck[j] -= 1;
	 p += partitions(deck, j+1);
	 deck[j] += 1;
      end;
      writeln('Dealer showing ',i,' partitions = ',p);
      d += p;
      deck[i] += 1;
   end;
   writeln('Total partitions = ',d);
end.
