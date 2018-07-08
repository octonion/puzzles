program outcomes;

type
   stack = array[0..9] of integer;

var
   deck	   : stack;
   i, j	   : integer;
   d, p    : longint;

function partitions(var cards: stack; subtotal: integer): longint;
var
  i, total : integer;
  m : longint;
begin
   m := 0;
   // Hit
   for i := 0 to 9 do
      begin
	 if (cards[i]>0) then
	 begin
	    total := subtotal+i+1;
	    if (total < 21) then
	    begin
	       // Stand
	       m := m+1;
	       // Hit again
	       cards[i] := cards[i]-1;
	       m := m+partitions(cards, total);
	       cards[i] := cards[i]+1;
	    end
	    else
	       if (total=21) then
   	       begin
		  // Stand; hit again is an automatic bust
		  m := m+1;
	       end;
	 end;
      end;
      partitions := m;
end;
    
begin
   deck := 4;
   deck[9] := 16;
   d := 0;
   for i := 0 to 9 do
   begin
      // Dealer showing
      deck[i] := deck[i]-1;
      p := 0;
      for j := 0 to 9 do
      begin
	 deck[j] := deck[j]-1;
	 p := p+partitions(deck, j+1);
	 deck[j] := deck[j]+1;
      end;
      writeln('Dealer showing ',i:1,' partitions = ',p:1);
      d := d+p;
      deck[i] := deck[i]+1;
   end;
   writeln('Total partitions = ',d:1);
end.
