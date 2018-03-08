void main()
{
  import std.functional;
  import std.stdio: write, writeln, writef, writefln;
    
  int[10] deck = [4,4,4,4,4,4,4,4,4,16];

  int partitions(int[10] cards, int subtotal)
  {
    //writeln(cards,subtotal);
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
	  m += memoize!partitions(cards, total);
	  cards[i] += 1;
	} else if (subtotal+i+1==21) {
	  // Stand; hit again is an automatic bust
	  m += 1;
	}
      }
    }
    return m;
  }

  int d=0;
  for (int i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] -= 1;
    int p = 0;
    for (int j = 0; j < 10; j++) {
      deck[j] -= 1;
      int n = memoize!partitions(deck, j+1);
      deck[j] += 1;
      p += n;
    }

    writeln("Dealer showing ",i," partitions =",p);
    d += p;
    deck[i] += 1;
  }

  writeln("Total partitions =",d);
}
