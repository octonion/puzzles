with ada.text_io;

procedure outcomes is
   type stack is array (0..9) of integer;
   deck : stack;
   d, p, n : integer;

   function partitions(cards: in out stack; subtotal: integer) return integer is
      m, total : integer;
   begin
      m := 0;
      -- hit
      for i in integer range 0 .. 9 loop
	 if (cards(i)>0) then
            total := subtotal+i+1;
            if (total < 21) then
               -- stand
               m := m+1;
               -- hit again
	       cards(i) := cards(i)-1;
               m := m+partitions(cards, total);
	       cards(i) := cards(i)+1;
            elsif (total=21) then
               -- stand; hit again is an automatic bust
               m := m+1;
	       exit;
	    end if;
	 end if;  
      end loop;
      return(m);
   end partitions;
    
begin
    
   deck := (4,4,4,4,4,4,4,4,4,16);
   d := 0;
   for i in integer range 0 .. 9 loop
      -- Dealer showing
      deck(i) := deck(i)-1;
      p := 0;
      for j in integer range 0 .. 9 loop
	 deck(j) := deck(j)-1;
	 n := partitions(deck, j+1);
	 deck(j) := deck(j)+1;
	 p := p+n;
      end loop;
      ada.text_io.put_line ("Dealer showing " & integer'image(i) & " Partitions =" & integer'image(p));
      d := d+p;
      deck(i) := deck(i)+1;
   end loop;
   ada.text_io.put_line ("Total partitions =" & integer'image(d));
   
end outcomes;
