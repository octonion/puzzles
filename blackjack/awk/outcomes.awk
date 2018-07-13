#!/usr/bin/awk -f

 function partitions(cards, subtotal,     i,m,total)
 {
     m = 0
     // Hit
     for (i = 0; i < 10; i++)
     {
	 if (cards[i]>0) {
	     total = subtotal+i+1
	     if (total < 21) {
		 // Stand
		 m += 1
		 // Hit again
		 cards[i] -= 1
		 m += partitions(cards, total)
		 cards[i] += 1
	     } else if (total==21) {
		 // Stand; hit again is an automatic bust
		 m += 1
		 break
	     }
	 }
     }
     return m
 }

 BEGIN {
     for (i = 0; i < 9; i++)
	 deck[i] = 4
     deck[9] = 16

     d=0
  
     for (i = 0; i < 10; i++) {
	 // Dealer showing
	 deck[i] -= 1
	 p = 0
	 for (j = 0; j < 10; j++) {
	     deck[j] -= 1
	     p += partitions(deck, j+1)
	     deck[j] += 1
	 }

	 print "Dealer showing " i " partitions = " p
	 d += p
	 deck[i] += 1
     }
     print "Total partitions = " d
}
