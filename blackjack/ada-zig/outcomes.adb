with Ada.Environment_Variables;  use Ada.Environment_Variables;
with Ada.Text_IO;                use Ada.Text_IO;
with Interfaces;                 use Interfaces;
with Interfaces.C;               use Interfaces.C;
with System;                     use System;

with Ada.Unchecked_Conversion;

procedure outcomes is
   type stack is array (0..9) of Integer;
   
   deck : stack;
   D, P, N : Integer;
   
   function dlopen (filename : char_array; flag : int) return address;
   pragma import (c, dlopen);

   function dlsym (handle : address; symbol : char_array) return address;
   pragma import (c, dlsym);
   
   type partitions is access function (cards: out Stack; subtotal: Integer) return Integer;
   pragma Convention (C, partitions);
   function To_Ptr is new Ada.Unchecked_Conversion (Address, partitions);
   
   library : address := dlopen (to_c ("./libpartitions.so"), 1);
   zpartitions  : partitions  := to_ptr (dlsym (library, to_c ("partitions")));
    
begin
    
   deck := (4,4,4,4,4,4,4,4,4,16);
   d := 0;
   for I in Integer range 0 .. 9 loop
      -- Dealer showing
      Deck(I) := Deck(I)-1;
      p := 0;
      for j in Integer range 0 .. 9 loop
	 Deck(J) := Deck(J)-1;
	 n := zpartitions(deck, j+1);
	 Deck(J) := Deck(J)+1;
	 p := P+N;
      end loop;
      Put_Line ("Dealer showing " & Integer'Image(I) & " partitions =" & Integer'Image(P));
      d := D+P;
      Deck(I) := Deck(I)+1;
   end loop;
   Put_Line ("Total partitions =" & Integer'Image(D));
end Outcomes;
