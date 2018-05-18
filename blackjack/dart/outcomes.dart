int partitions(List cards, int subtotal) {
  int m=0;
  int total;
  // Hit
  for (int i = 0; i < 10; i++) {
    if (cards[i]>0) {
      total = subtotal+i+1;
      if (total < 21) {
        // Stand
        m += 1;
        // Hit again
        cards[i] = cards[i]-1;
        m += partitions(cards, total);
        cards[i] = cards[i]+1;
      } else if (subtotal+i+1==21) {
        // Stand; hit again is an automatic bust
        m += 1;
        break;
      }
    }
  }
  return m;
}

void main() {

  var deck = [4,4,4,4,4,4,4,4,4,16];
  int d=0;
  
  for (int i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] = deck[i]-1;
    int p = 0;
    for (int j = 0; j < 10; j++) {
      deck[j] = deck[j]-1;
      int n = partitions(deck, j+1);
      deck[j] = deck[j]+1;
      p += n;
    }

    print("Dealer showing ${i} partitions = ${p}");
    d += p;
    deck[i] = deck[i]+1;
  }
  print("Total partitions = ${d}");
}
