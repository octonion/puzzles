// Groovy

def deck = [4,4,4,4,4,4,4,4,4,16]

def partitions

partitions = { ArrayList cards, int subtotal ->

    def m = 0
    // Hit
    for (i in 0..9) {
        if (cards[i]>0) {
            def total = subtotal+i+1
            if (total < 21) {
                // Stand
                m += 1
		// Hit again
		cards[i] = cards[i]-1
                m += partitions(cards, total)
		cards[i] = cards[i]+1    
	    } else if (subtotal+i+1==21) {
                // Stand; hit again is an automatic bust
                m += 1
		break
	    }
	}
    }
    return m
}

d = 0

for (i in 0..9) {

    // Dealer showing

    deck[i] = deck[i]-1

    p = 0
    for (j in 0..9) {
        deck[j] = deck[j]-1
        n = partitions(deck, j+1)
        deck[j] = deck[j]+1
        p += n
    }

    println "Dealer showing ${i} partitions = ${p}"
    d += p

    deck[i] = deck[i]+1
}

println "Total partitions = ${d}"
