with Interfaces.C; use Interfaces;

package unit is
   type stack is array (0..9) of integer;
   function partitions (cards: out stack; subtotal: integer) return integer;
   pragma export (C, partitions, "partitions");
end unit;
