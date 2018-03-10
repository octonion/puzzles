function partitions(cards, subtotal) {
    let m=0;
    let total;
    // Hit
    for (let i = 0; i < 10; i++) {
	if (cards[i]>0) {
	    total = subtotal+i+1;
	    if (total < 21) {
		// Stand
		m += 1;
		// Hit again
		cards[i] += -1;
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

let deck = new Array(4,4,4,4,4,4,4,4,4,16);
let d=0;
  
for (let i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] += -1;
    let p = 0;
    for (let j = 0; j < 10; j++) {
	deck[j] += -1;
	let n = partitions(deck, j+1);
	deck[j] += 1;
	p += n;
    }

    console.log("Dealer showing " + i + " partitions = " + p);
    d += p;
    deck[i] += 1;
}
console.log("Total partitions = " + d);
