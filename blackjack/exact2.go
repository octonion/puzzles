package main

import (
	/*"fmt"*/
	"github.com/BenLubar/memoize"
	"os"
	/*"log"*/
	"encoding/csv"
	"strconv"
)

/* Decks */

const decks = 1

const hit_soft_17 = false

var dealer_p func(total int,first bool,ace bool,cards [10]int) ([22]float64)

func init() {

	dealer_p = memoize.Memoize(func(total int,first bool,ace bool,cards [10]int) ([22]float64) {

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

			var low int
			var high int
			var p float64
			var n float64

			/* Hit */

			/* No blackjack */

			switch {
			case (first) && total==10:
				low = 1
				high = 10
			case (first) && total==1:
				low = 0
				high = 9
			default:
				low = 0
				high = 10
			}

			n = 0.0
			for i := low; i < high; i++ {
				n += float64(cards[i])
			}

			for i := low; i < high; i++ {
				if (cards[i] > 0) {
					p = float64(cards[i])/n
					cards[i] += -1
					d := dealer_p(total+i+1,false,(ace||i==0),cards)
					for j := 0; j < 22; j++ {
						outcomes[j] += p*d[j]
					}
					cards[i] += 1
				}
			}

		}

		return(outcomes)
			
	}).(func(total int,first bool,ace bool,cards [10]int) ([22]float64))

}

var player_p func(total int,ace bool,cards [10]int,dc int) (float64,float64,float64)

func init() {

	player_p = memoize.Memoize(func(total int,ace bool,cards [10]int,dc int) (float64,float64,float64) {

		var e_stand float64 = 0.0
		var e_hit float64 = 0.0
		var e_one float64 = 0.0

		if total <= 11 && ace {
			d := dealer_p(dc+1,true,(dc==0),cards)
			for i := 0; i < total+10; i++ {
				e_stand += d[i]
			}
			for i := total+11; i < 22; i++ {
				e_stand += -d[i]
			}
		} else {
			d := dealer_p(dc+1,true,(dc==0),cards)
			for i := 0; i < total; i++ {
				e_stand += d[i]
			}
			for i := total+1; i < 22; i++ {
				e_stand += -d[i]
			}
		}

		/* Hit */

		/*
                Dealer can't have a 10 if showing A
                Dealer can't have an A if showing 10
                Need to adjust p in those cases
                n cards
                a aces
                  subtract cards[i]/(n-a) from each non-A
                  renormalize
                a = cards[0]
                c = cards[1]
                a/(n-1)
                s = 1-a/(n-1) = (n-a-1)/(n-1)
                (c/(n-a))*((n-a-1)/(n-1))
                p[0] = cards[0]/(n-1)
                p[i>0] = (c-c/(n-a))/(n-1)
                     = c*((n-a-1)/(n-a))/(n-1)
                sum to (n-a)*((n-a-1)/(n-a))/(n-1) = (n-a-1)/(n-1)
                a/(n-1)+(n-a-1)/(n-1) = (n-1)/(n-1) = 1

                */

		var n float64 = 0.0
		var p float64 = 0.0
		
		for i := 0; i < 10; i++ {
			n += float64(cards[i])
		}

		for i := 0; i < 10; i++ {
			if cards[i]>0 {
				
				var a float64 = float64(cards[9-dc])
				var m float64 = float64(cards[i])
				
				switch {
				case (dc==0 || dc==9) && (dc+i==9):
					p = m/(n-1)
				case (dc==0 || dc==9) && !(dc+i==9):
					p = (m/(n-a))*(n-a-1)/(n-1)
				default:
					p = m/n
				}
				
				/*fmt.Println(i,dc,a,m,p,cards)*/
				
				if total+i+1 > 21 {
					e_hit += -p
					e_one += -p
				} else {
					cards[i] += -1
					e_h,e_s,e_o := player_p(total+i+1,(ace||i==0),cards,dc)
					_ = e_o
					
					e_one += p*e_s
					
					if (e_h>e_s) {
						e_hit += p*e_h
					} else {
						e_hit += p*e_s
					}
					
					cards[i] += 1
				}
			}
		}

		return e_hit,e_stand,e_one
		
	}).(func(total int,ace bool,cards [10]int,dc int) (float64,float64,float64))
}
		
func main() {

	var deck [10]int

	for i := 0; i < 9; i++ {
		deck[i] = decks*4
	}
	deck[9] = decks*16

	outfile, err := os.Create("results.csv")
	_ = err
	writer := csv.NewWriter(outfile)
	defer writer.Flush()

	for i := 0; i < 10; i++ {
		deck[i] += -1

		for j := 0; j < 10; j++ {
			deck[j] += -1
			for k := j; k < 10; k++ {
            
				deck[k] += -1
				e_h,e_s,e_o := player_p(j+k+2,(j==0 || k==0),deck,i)
				_i := strconv.Itoa(i+1)
				_j := strconv.Itoa(j+1)
				_k := strconv.Itoa(k+1)
				_e_h := strconv.FormatFloat(e_h,'f',8,64)
				_e_s := strconv.FormatFloat(e_s,'f',8,64)
				_e_o := strconv.FormatFloat(2*e_o,'f',8,64)
				writer.Write([]string{_i,_j,_k,"hit",_e_h})
				writer.Write([]string{_i,_j,_k,"stand",_e_s})
				writer.Write([]string{_i,_j,_k,"double",_e_o})

				deck[k] += 1
			}
			deck[j] += 1
		}
		deck[i] += 1
	}

}
