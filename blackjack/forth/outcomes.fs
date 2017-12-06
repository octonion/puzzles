
variable total
variable subtotal
variable m
variable d

variable deck 9 cells allot
\ deck 10 cells erase

: deck-init
  9 0 do
    4 i cells deck + !
  loop
  16 9 cells deck + !
;

: print-deck
10 0 do
  i cells deck + ?
loop ;

deck-init

: cards cells deck + ;
: inc cards 1 swap +! ;
: dec cards -1 swap +! ;

\ 2 cells deck + -1 swap +!

: partitions recursive \ subtotal on stack

  subtotal !
  \ subtotal ?

  \ print-deck
  \ subtotal ? cr

  10 0 do
    i cells deck + @ 0 > if

      i dec
      i 1 subtotal @ + + total !
      
      total @ 21 < if
	1 m +!
	subtotal @ total @
	partitions
	subtotal !
      else
	total @ 21 = if
	  1 m +!
	then
      then
      
      i inc

    then
    
  loop

;

variable n
0 n !

: deal
  \ Dealer showing i
  10 0 do
    i dec
    0 m !
    \ print-deck
    10 0 do
      i dec
      1 i + partitions
      i inc
    loop
    m @ n +!
    ." Dealer " i . m ? cr
    \ print-deck cr
    i inc
  loop ;
  
deal
." Total " n ? cr

bye
