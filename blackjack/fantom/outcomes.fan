class outcomes {
    public Int partitions(Int[] cards, Int subtotal)
    {
	Int m := 0;
	// Hit
	for (Int i:=0; i<=9; i++) {
	    if (cards[i]>0) {
		Int total:=subtotal+i+1;
		if (total<21) {
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

    public Void main(Str[] args)
    {
	deck := Int[4,4,4,4,4,4,4,4,4,16];
	Int d:=0;

	for (Int i:=0; i<=9; i++) {
	    // Dealer showing
	    deck[i] -= 1;
	    Int p:=0;
	    for (Int j:=0; j<=9; j++) {
		deck[j] -= 1;
		p += partitions(deck, j+1);
		deck[j] += 1;
	    }
	    echo("Dealer showing "+i+" partitions = "+p);
	    d += p;
	    deck[i] += 1;
	}
	echo("Total partitions = "+d);
    }
}
