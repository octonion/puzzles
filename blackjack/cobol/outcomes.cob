      >>source free
identification division.
program-id. outcomes.

data division.
working-storage section.
01 i pic 99 comp-5.
01 j pic 99 comp-5.
01 d pic 9(7) comp-5.
01 p pic 9(6) comp-5.
01 n pic 9(6) comp-5.
01 deck comp-5. *> value "04040404040404040416".
   03 deck-values pic 99 comp-5 occurs 10 times.

procedure division.
   perform varying i from 1 by 1 until 9 < i
     move 4 to deck-values (i)
   end-perform
   move 16 to deck-values (10)
   move 0 to d
   perform varying i from 1 by 1 until 10 < i
     move 0 to p
     subtract 1 from deck-values (i)
     perform varying j from 1 by 1 until 10 < j
       subtract 1 from deck-values (j)
       call "partitions" using deck, j returning n
       add n to p
       add 1 to deck-values (j)
     end-perform
     display "Dealer showing "i" partitions = "p
     add 1 to deck-values (i)
     add p to d
   end-perform
   display "Total partitions = "d
.
end program outcomes.

identification division.
program-id. partitions recursive.

data division.
local-storage section.
01 i pic 99 comp-5.
01 m1 pic 9999999 comp-5.
01 v pic 9999999 comp-5.
01 total pic 99 comp-5.
 
linkage section.
01 cards comp-5.
   03 cards-values pic 99 comp-5 occurs 10 times.
01 subtotal pic 99 comp-5.
01 m pic 9999999 based.
 
procedure division using cards, subtotal returning m.
    allocate m
    move 0 to m
    perform varying i from 1 by 1 until 10 < i
      if (cards-values (i) > 0)
          add i,subtotal giving total
          evaluate total
	    when 1 thru 20
              add 1 to m
	      move m to m1
  	      subtract 1 from cards-values (i)
              call "partitions" using cards, total returning v
              add v to m1
	      move m1 to m
	      add 1 to cards-values (i)
	    when 21
              add 1 to m
	  end-evaluate
      end-if
    end-perform
    .
end program partitions.
