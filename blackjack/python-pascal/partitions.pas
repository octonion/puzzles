library partitions;

uses
  ctypes;

type
   cint32 =  longint;
   stack  = array[0..9] of cint32;

function partitions(cards: stack; subtotal: cint32): cint32;
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

exports
  partitions;

end.
