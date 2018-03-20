package main

import "fmt"

func partitions(cards [10]int, subtotal int) int {
    var m = 0
    // Hit
    for i:=0; i < 10; i++ {
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
            }
        }
    }        
	return m
}

func main() {
	deck := [10]int{4,4,4,4,4,4,4,4,4,16}
	var d = 0

	for i:=0; i < 10; i++ {
		// Dealer showing
		deck[i] += -1
		var p = 0
		for j:=0; j < 10; j++ {
			deck[j] += -1
			p += partitions(deck, j+1)
			deck[j] += 1
		}
		fmt.Println("Dealer showing ", i," partitions =",p)
		d += p
		deck[i] = deck[i]+1
	}
	fmt.Println("Total partitions =",d)
}
