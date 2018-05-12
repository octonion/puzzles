variable total
variable subtotal
variable m
variable d

\ Can be done using "create"
create deck 4 , 4 , 4 , 4 , 4 , 4 , 4 , 4 , 4 , 16 ,

: cards cells deck + ;
: inc cards 1 swap +! ;
: dec cards -1 swap +! ;

: partitions recursive \ subtotal on stack

  subtotal !

  10 0 do
    i cells deck + @ 0 > if

      i 1 subtotal @ + + total !
      
      total @ 21 < if
	1 m +!
	subtotal @ total @
        i dec
	partitions
        i inc
	subtotal !
      else
	total @ 21 = if
	  1 m +!
	  leave
	then
      then
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
    10 0 do
      i dec
      1 i + partitions
      i inc
    loop
    m @ n +!
    ." Dealer " i . m ? cr
    i inc
  loop ;
  
deal
." Total " n ? cr

bye
