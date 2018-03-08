int partitions(int cards[10], int subtotal)
{
  int m=0;
  int total;
  // Hit
  for (int i = 0; i < 10; i++) {
    if (cards[i]>0) {
      total = subtotal+i+1;
      if (total < 21) {
	cards[i] -= 1;
	// Stand
	m += 1;
	// Hit again
	m += partitions(cards, total);
	cards[i] += 1;
      } else if (total==21) {
	// Stand; hit again is an automatic bust
	m += 1;
      }
    }
  }
  return m;
}
