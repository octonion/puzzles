package main

import "fmt"
import	"github.com/BenLubar/memoize"

/* Decks */

const decks = 1

const hit_soft_17 = false

var dealer_p func(total int,ace bool,cards [10]int,n int) ([22]float64)

func init() {

	dealer_p = memoize.Memoize(func(total int,ace bool,cards [10]int,n int) ([22]float64) {

	var outcomes [22]float64

	switch {
	case total > 21:
		outcomes[0] = 1.0
	case total >= 17:
		outcomes[total] = 1.0
	case (total==7) && ace && !(hit_soft_17):
		outcomes[total+10] = 1.0
	case (8 <= total && total <= 11) && ace:
		outcomes[total+10] = 1.0
	default:
		/* Hit */
		for i := 0; i < 10; i++ {
			if (cards[i] > 0) {
				p := float64(cards[i])/float64(n)
				cards[i] += -1
				d := dealer_p(total+i+1,(ace || i==0),cards,n-1)
				for j := 0; j < 22; j++ {
					outcomes[j] += p*d[j]
				}
				cards[i] += 1
			}
		}

	}

	return(outcomes)
			
	}).(func(total int,ace bool,cards [10]int,n int) ([22]float64))

}

var player_p func(total int,ace bool,cards [10]int,dc int,n int) (float64,float64,float64)

func init() {

	player_p = memoize.Memoize(func(total int,ace bool,cards [10]int,dc int,n int) (float64,float64,float64) {

		var e_stand float64 = 0.0
		var e_hit float64 = 0.0
		var e_opt float64 = 0.0

		if total <= 11 && ace {
			d := dealer_p(dc,(dc==0),cards,n)
			for i := 0; i < total+10; i++ {
				e_stand += d[i]
			}
			for i := total+11; i < 22; i++ {
				e_stand += -d[i]
			}
		} else {
			d := dealer_p(dc,(dc==0),cards,n)
			for i := 0; i < total; i++ {
				e_stand += d[i]
			}
			for i := total+1; i < 22; i++ {
				e_stand += -d[i]
			}
		}

		/* Hit */

		for i := 0; i < 10; i++ {
			if cards[i]>0 {
				p := float64(cards[i])/float64(n)
				if total+i+1 > 21 {
					e_hit += -p
				} else {
					cards[i] += -1
					e_o,e_s,e_h := player_p(total+i+1,(ace || i==0),cards,dc,n-1)
					_ = e_s
					_ = e_h
					e_hit += p*e_o
					cards[i] += 1
				}
			}
		}
		if (e_hit >= e_stand) {
			e_opt = e_hit
		} else {
			e_opt = e_stand
		}
		return e_opt,e_hit,e_stand
		
	}).(func(total int,ace bool,cards [10]int,dc int,n int) (float64,float64,float64))
}
		
func main() {
	var deck [10]int
	var p [10]float64

	for i := 0; i < 9; i++ {
		deck[i] = decks*4
		p[i] = 4.0/52
	}
	deck[9] = decks*16
	p[9] = 16.0/52

	for i := 1; i < 9; i++ {
		deck[i] += -1

		for j := 0; j < 10; j++ {
			deck[j] += -1
			for k := 0; k < 10; k++ {
            
				deck[k] += -1
				e_o,e_h,e_s := player_p(j+k+2,(j==0 || k==0),deck,i+1,(decks*52-3))
/*				if (e_h>e_s) {
					s := "hit"
				} else {
					s := "stand"
				}*/
				_ = e_o
				/*_ = s*/
				fmt.Println(i+1,j+1,k+1,e_h,e_s)   
				deck[k] += 1
			}
			deck[j] += 1
		}
		deck[i] += 1
	}

}

