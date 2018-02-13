extern (C) int partitions(int* cards, int subtotal)
{
  int m=0;
  int total;
  // Hit
  for (int i = 0; i < 10; i++) {
    if (cards[i]>0) {
      cards[i] = cards[i]-1;
      total = subtotal+i+1;
      if (total < 21) {
	// Stand
	m += 1;
	// Hit again
	m += partitions(cards, total);
      } else if (subtotal+i+1==21) {
	// Stand; hit again is an automatic bust
	m += 1;
      }
      cards[i] = cards[i]+1;
    }
  }
  return m;
}
