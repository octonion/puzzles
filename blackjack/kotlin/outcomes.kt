fun partitions(cards: Array<Int>, subtotal: Int): Int {
	var m = 0
	// Hit
	for (i in 0..9) {
		if (cards[i]>0) {
			var total = subtotal+i+1
			if (total < 21) {
				// Stand
				m += 1
				// Hit again
				cards[i] -= 1
				m += partitions(cards, total)
				cards[i] += 1
			} else if (total==21) {
				// Stand; hit again is an automatic bust
				m += 1
				break
			}
		}
	}
	return(m)
}

fun main(args : Array<String>) {
	var deck = arrayOf(4,4,4,4,4,4,4,4,4,16)
	var d = 0

	for (i in 0..9) {
		// Dealer showing
		deck[i] -= 1
		var p = 0
		for (j in 0..9) {
			deck[j] -= 1
			p += partitions(deck, j+1)
			deck[j] += 1
		}
		println("Dealer showing ${i} partitions = ${p}")
		d += p
		deck[i] += 1
	}
	println("Total partitions = ${d}")
}
