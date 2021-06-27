with Ada.Containers.Ordered_Sets, Ada.Containers.Doubly_Linked_Lists;
with Ada.Text_IO, Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Containers.Indefinite_Ordered_Maps;

use Ada.Containers, Ada.Numerics.Big_Numbers.Big_Integers;
use Ada.Text_IO;

procedure Factorial_sqrt is
   
   function Big_Sqrt (N: Big_Integer) return Big_Integer is
      X : Big_Integer := N;
      Y : Big_Integer := (X+1)/2;
   begin

      while (Y < X) loop
	 X := Y;
	 Y := (X+N/X)/2;
      end loop;
      
      return X;
      
   end Big_Sqrt;
      
   function Factorial (n: Integer) return Big_Integer is
      result: Big_Integer := To_Big_Integer(N);
      counter: Integer := n - 1;
   begin
      for i in 1..counter loop
	 result := result * To_Big_Integer(I);
      end loop;
      return result;
   end factorial;
   
   package Integer_Sets is
      new Ordered_Sets (Integer);
   use Integer_Sets;
   
   package Queues is
      new Doubly_Linked_Lists (Integer);
   use Queues;
   
   package Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (Integer, Integer);
   use Maps;
   
   Paths : Map := Empty_Map;
   Sqrts : Map := Empty_Map;
   
   Found: Set;
   Bound: Big_Integer;
   Queue: List;
   
   N: Big_Integer;
   W,V,M,I: Integer;
   
begin

   Bound := 700;
   
   Found.Insert (3);
   Append (Queue, New_Item => 3);
   Paths.Insert (3, 3);
   Sqrts.Insert (3, 0);
   
   while not(Is_Empty(Queue)) loop
      M := First_Element (Queue);
      Delete_First (Queue);
      N := Factorial(M);
      I := 0;
      
      while (N>3) loop
	 if (N<Bound) then
	    if not(Found.Contains(To_Integer(N))) then
	       Found.Insert (To_Integer(N));
	       Append (Queue, New_Item => To_Integer(N));
	       Paths.Insert (To_Integer(N), M);
	       Sqrts.Insert (To_Integer(N), I);
	    end if;
	 end if;
	 N := Big_Sqrt(N);
        I := I+1;
      end loop;
   end loop;
   
   for F of Found loop
      Put (Integer'Image(F));
   end loop;
   Put_Line("");
   Put_Line("");
   
   V := 9;
   while not(V=3) loop
      W := Paths(V);
      Put_Line (Integer'Image(V) & " <- " & Integer'Image(W) & "! + " & Integer'Image(Sqrts(V)) & " sqrt");
      V := W;
   end loop;

end Factorial_Sqrt;
