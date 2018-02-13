package main

import "C"

//export partitions
func partitions(cards []int, subtotal int) int {
	var m = 0
	// Hit
	for i:=0; i < 10; i++ {
		if (cards[i]>0) {
			cards[i] += -1
			var total = subtotal+i+1
            
			if (total < 21) {
				// Stand
				m += 1
				// Hit again
				m += partitions(cards, total)
			} else if (subtotal+i+1==21) {
				// Stand; hit again is an automatic bust
				m += 1
			}
                
		cards[i] = cards[i]+1
		}
	}        
	return m
}

func main() {}
