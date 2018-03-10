class outcomes {
    public static int partitions(int[] cards, int subtotal)
    {
	int m = 0;
	// Hit
	for (int i = 0; i <= 9; i++) {
	    if (cards[i]>0) {
		int total = subtotal+i+1;
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

    public static void main(String[] args)
    {
	int[] deck = new int[]{4,4,4,4,4,4,4,4,4,16};
	int d = 0;

	for (int i = 0; i <= 9; i++) {
	    // Dealer showing
	    deck[i] -= 1;
	    int p = 0;
	    for (int j = 0; j <= 9; j++) {
		deck[j] -= 1;
		p += partitions(deck, j+1);
		deck[j] += 1;
	    }
	    System.out.println("Dealer showing "+i+" partitions = "+p);
	    d += p;
	    deck[i] += 1;
	}
	System.out.println("Total partitions = "+d);
    }
}
