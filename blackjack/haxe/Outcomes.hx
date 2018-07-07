class Outcomes {

      static function partitions(cards, subtotal) {
          var m=0;
	  var total;
	  // Hit
	  for (i in 0...10) {
	      if (cards[i]>0) {
	      	 total = subtotal+i+1;
		 if (total < 21) {
		    // Stand
		    m += 1;
		    // Hit again
		    cards[i] += -1;
		    m += partitions(cards, total);
		    cards[i] += 1;
		 } else if (total==21) {
		    // Stand; hit again is an automatic bust
		    m += 1;
		    break;
		 }
	      }
          }
          return m;
      }

      static function main() {
      
      	  var deck = [4,4,4,4,4,4,4,4,4,16];
	  var d=0;
  
	  for (i in 0...10) {
	      // Dealer showing
	      deck[i] += -1;
	      var p = 0;
	      for (j in 0...10) {
	      	  deck[j] += -1;
		  p += partitions(deck, j+1);
		  deck[j] += 1;
	      }

	      Sys.println("Dealer showing " + i + " partitions = " + p);
	      d += p;
	      deck[i] += 1;
          }
          Sys.println("Total partitions = " + d);
      }
}
