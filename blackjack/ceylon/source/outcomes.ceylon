Integer partitions(Array<Integer> cards, Integer subtotal) {

  variable Integer m=0;
  // Hit
  for (i in 0..9) {
    if ((cards[i] else 0)>0) {
      variable Integer total = subtotal+i+1;
      if (total < 21) {
        // Stand
        m += 1;
        // Hit again
	cards[i] = (cards[i] else 0)-1;
        m += partitions(cards, total);
	cards[i] = (cards[i] else 0)+1;
      } else if (total==21) {
        // Stand; hit again is an automatic bust
        m += 1;
        break;
      }
    }
  }
  return m;
}

shared void run() {
  value deck = Array.ofSize(10, 4);
  deck[9] = 16;
  
  variable Integer d=0;
  
  for (i in 0..9) {
    // Dealer showing
    deck[i] = (deck[i] else 0)-1;
    variable Integer p = 0;
    for (j in 0..9) {
      deck[j] = (deck[j] else 0)-1;
      p += partitions(deck, j+1);
      deck[j] = (deck[j] else 0)+1;
    }

    print("Dealer showing ``i`` partitions = ``p``");
    d += p;
    deck[i] = (deck[i] else 0)+1;
  }
  print("Total partitions = ``d``");
}
