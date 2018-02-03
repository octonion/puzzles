
partitions <- function(cards, subtotal) {
      m=0
      # Hit
      for (i in 1:10) {
	if (cards[i]>0) {
	  cards[i] = cards[i]-1
	  total = subtotal+i
	  if (total < 21) {
	    # Stand
	    m = m+1
	    # Hit again
	    m = m+partitions(cards, total)
	  } else if (subtotal+i==21) {
	    # Stand; hit again is an automatic bust
	    m = m+1
	  }
	  cards[i] = cards[i]+1
	}
      }
      return(m)
    }

deck = c(4,4,4,4,4,4,4,4,4,16)
d=0
  
for (i in 1:10) {
    # Dealer showing
    deck[i] = deck[i]-1
    p = 0
    for (j in 1:10) {
      deck[j] = deck[j]-1
      n = partitions(deck, j)
      deck[j] = deck[j]+1
      p = p+n
    }

    print(paste("Dealer showing ",i-1," partitions = ",p,sep=""))
    d = d+p
    deck[i] = deck[i]+1
}
print(paste("Total partitions = ",d,sep=""))
