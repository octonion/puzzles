void partitions(int *cards, int *subtotal, int *m)
{
  int total;
  // Hit
  for (int i = 0; i < 10; i++) {
    if (cards[i]>0) {
      cards[i] = cards[i]-1;
      total = subtotal[0]+i+1;
      if (total < 21) {
	// Stand
	m[0] += 1;
	// Hit again
	partitions(cards, &total, m);
      } else if (subtotal[0]+i+1==21) {
	// Stand; hit again is an automatic bust
	m[0] += 1;
      }
      cards[i] = cards[i]+1;
    }
  }
}
