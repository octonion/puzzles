func partitions(cards: inout [Int], subtotal: Int) -> Int {
    var m = 0
    // Hit
    for i in 0...9 {
        
        if (cards[i]>0) {
            cards[i] += -1
            let total = subtotal+i+1
            
            if (total < 21) {
                // Stand
                m += 1
                // Hit again
                m += partitions(cards:&cards, subtotal:total)
            } else if (subtotal+i+1==21) {
                // Stand; hit again is an automatic bust
                m += 1
            }
                
            cards[i] += 1
        }
    }        
	return m
}

var deck = [4,4,4,4,4,4,4,4,4,16]
var d = 0

for i in 0...9 {
    // Dealer showing
    deck[i] += -1

    var p = 0
    for j in 0...9 {
	deck[j] += -1
	let n = partitions(cards:&deck, subtotal:j+1)
	deck[j] += 1
	p += n
    }

    print("Dealer showing ", i," partitions =",p)
    d += p

    deck[i] = deck[i]+1
}

print("Total partitions =",d)
