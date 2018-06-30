program outcomes(input,output);

type
   stack = array[0..9] of integer;

var
   deck	   : stack;
   i, j	   : integer;
   d, p    : integer;

function partitions(cards: stack; subtotal: integer): integer;
var
  i, total, m : integer;
  loop : boolean;
begin
   m := 0;
   loop := true;
   { Hit }
   for i := 0 to 9 do
      begin
	 if (loop) and (cards[i]>0) then
	 begin
	    total := subtotal+i+1;
	    if (total < 21) then
	    begin
	       { Stand }
	       m := m+1;
	       { Hit again }
	       cards[i] := cards[i]-1;
	       m := m+partitions(cards, total);
	       cards[i] := cards[i]+1;
	    end
	    else
	       if (total=21) then
   	       begin
		  { Stand; hit again is an automatic bust }
		  m := m+1;
		  loop := false;
	       end;
	 end;
      end;
      partitions := m;
end;
    
begin

   for i := 0 to 8 do
     deck[i] := 4;
   deck[9] := 16;
   d := 0;
   
   for i := 0 to 9 do
   begin
      { Dealer showing }
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
