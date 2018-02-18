function partitions(cards, subtotal) {
    var m=0;
    var total;
    // Hit
    for (var i = 0; i < 10; i++) {
	if (cards[i]>0) {
	    cards[i] += -1;
	    total = subtotal+i+1;
	    if (total < 21) {
		// Stand
		m += 1;
		// Hit again
		m += partitions(cards, total);
	    } else if (total==21) {
		// Stand; hit again is an automatic bust
		m += 1;
	    }
	    cards[i] += 1;
	}
    }
    return m;
}

var deck = new Array(4,4,4,4,4,4,4,4,4,16);
var d=0;
  
for (var i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] += -1;
    var p = 0;
    for (var j = 0; j < 10; j++) {
	deck[j] += -1;
	var n = partitions(deck, j+1);
	deck[j] += 1;
	p += n;
    }

    console.log("Dealer showing " + i + " partitions = " + p);
    d += p;
    deck[i] += 1;
}
console.log("Total partitions = " + d);
