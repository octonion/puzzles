using System;
namespace Outcomes
{
  class Calculate
  {

    static int partitions(int[] cards, int subtotal)
    {
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
	    cards[i] -= 1;
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

    static void Main()
    {
      int[] deck = new int[] {4,4,4,4,4,4,4,4,4,16};
      int d=0;
  
      for (int i = 0; i < 10; i++) {
	// Dealer showing
	deck[i] -= 1;
	int p = 0;
	for (int j = 0; j < 10; j++) {
	  deck[j] -= 1;
	  p += Calculate.partitions(deck, j+1);
	  deck[j] += 1;
	}

	Console.WriteLine("Dealer showing {0} partitions = {1}",i,p);
	d += p;
	deck[i] += 1;
      }
      Console.WriteLine("Total partitions = {0}",d);

    }
  }
}

