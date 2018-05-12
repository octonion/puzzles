#include <stdio.h>

    int partitions(int cards[10], int subtotal)
    {
      //writeln(cards,subtotal);
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
	    break;
	  }
	}
      }
      return m;
    }

int main(void)
{

  int deck[] = {4,4,4,4,4,4,4,4,4,16};
  int d=0;
  
  for (int i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] -= 1;
    int p = 0;
    for (int j = 0; j < 10; j++) {
      deck[j] -= 1;
      p += partitions(deck, j+1);
      deck[j] += 1;
    }

    printf("Dealer showing %i partitions = %i\n",i,p);
    d += p;
    deck[i] += 1;
  }
  printf("Total partitions = %i\n",d);

  return 0;
}
