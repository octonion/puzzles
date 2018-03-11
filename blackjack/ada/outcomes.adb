with Ada.Text_IO;

procedure outcomes is
   type stack is array (0..9) of Integer;
   deck : stack;
   D, P, N : Integer;

   function partitions (cards: out Stack; subtotal: Integer) return Integer is
      M, total : Integer;
   begin
      m := 0;
      -- Hit
      for I in Integer range 0 .. 9 loop
	 if (cards(i)>0) then
            total := subtotal+i+1;
            if (total < 21) then
               -- Stand
               m := M+1;
               -- Hit again
	       Cards(I) := Cards(I)-1;
               m := M+partitions(cards, total);
	       Cards(I) := Cards(I)+1;
            elsif (total=21) then
               -- Stand; hit again is an automatic bust
               m := M+1;
	    end if;
	 end if;  
      end loop;
      return(m);
   end Partitions;
    
begin
    
   deck := (4,4,4,4,4,4,4,4,4,16);
   d := 0;
   for I in Integer range 0 .. 9 loop
      -- Dealer showing
      Deck(I) := Deck(I)-1;
      p := 0;
      for j in Integer range 0 .. 9 loop
	 Deck(J) := Deck(J)-1;
	 n := partitions(deck, j+1);
	 Deck(J) := Deck(J)+1;
	 p := P+N;
      end loop;
      Ada.Text_IO.Put_Line ("Dealer showing " & Integer'Image(I) & " partitions =" & Integer'Image(P));
      d := D+P;
      Deck(I) := Deck(I)+1;
   end loop;
   Ada.Text_IO.Put_Line ("Total partitions =" & Integer'Image(D));
end Outcomes;
