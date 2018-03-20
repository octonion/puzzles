package main

import "C"

//export partitions
func partitions(cards []int, subtotal int) int {
	var m = 0
	// Hit
	for i:=0; i < 10; i++ {
		if (cards[i]>0) {
			var total = subtotal+i+1
			if (total < 21) {
				// Stand
				m += 1
				// Hit again
				cards[i] += -1
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

func main() {}
