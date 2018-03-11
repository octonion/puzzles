with Interfaces.C; use Interfaces;

package body unit is
   
   --type stack is array (0..9) of integer;   

   function partitions (cards: out stack; subtotal: integer) return integer is
      m, total : integer;
   begin
      m := 0;
      -- Hit
      for i in integer range 0 .. 9 loop
	 if (cards(i)>0) then
            total := subtotal+i+1;
            if (total < 21) then
               -- Stand
               m := m+1;
               -- Hit again
	       cards(i) := cards(i)-1;
               m := m+partitions(cards, total);
	       cards(i) := cards(i)+1;
            elsif (total=21) then
               -- Stand; hit again is an automatic bust
               m := m+1;
	    end if;
	 end if;  
      end loop;
      return(m);
   end partitions;
   
end unit;
