class partitions {
  static compute(cards,subtotal) {
    var m = 0
    // Hit
    for (i in 0...10) {
      if (cards[i]>0) {
        var total = subtotal+i+1
        if (total < 21) {
          // Stand
          m = m+1
          // Hit again
	  cards[i] = cards[i]-1
          m = m+compute(cards, total)
          cards[i] = cards[i]+1
        } else if (total==21) {
           // Stand; hit again is an automatic bust
           m = m+1
	   break
        }
      }
    }
    return(m)
  }
}

var deck = [4,4,4,4,4,4,4,4,4,16]
var d = 0

for (i in 0...10) {
  // Dealer showing
  deck[i] = deck[i]-1
  var p = 0
  for (j in 0...10) {
    deck[j] = deck[j]-1
    p = p+partitions.compute(deck, j+1)
    deck[j] = deck[j]+1
  }
  System.print("Dealer showing %(i) partitions = %(p)")
  d = d+p
  deck[i] = deck[i]+1
}
System.print("Total partitions = %(d)")
