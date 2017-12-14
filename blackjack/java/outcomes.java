class outcomes {
    public static int partitions(int[] cards, int subtotal)
    {
	int m = 0;
	// Hit
	for (int i = 0; i <= 9; i++) {
	    if (cards[i]>0) {
		cards[i] = cards[i]-1;
		int total = subtotal+i+1;
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

    public static void main(String[] args)
    {
	int[] deck = new int[]{4,4,4,4,4,4,4,4,4,16};
	int d = 0;

	for (int i = 0; i <= 9; i++) {
	    // Dealer showing
	    deck[i] = deck[i]-1;
	    int p = 0;
	    for (int j = 0; j <= 9; j++) {
		deck[j] = deck[j]-1;
		int n = partitions(deck, j+1);
		deck[j] = deck[j]+1;
		p += n;
	    }
	    System.out.println("Dealer showing "+i+" partitions = "+p);
	    d += p;
	    deck[i] = deck[i]+1;
	}
	System.out.println("Total partitions = "+d);
    }
}
