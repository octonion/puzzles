#!/usr/bin/env tclsh

proc partitions {cards_name subtotal} {
    upvar $cards_name cards
    set m 0
    
    # Hit
    for {set i 0} {$i < 10} {incr i} {
	if {$cards($i) > 0} then {
	    set total [expr $subtotal+$i+1]
	    if {$total < 21} then {
		# Stand
		incr m
		# Hit again
		incr cards($i) -1
		incr m [partitions cards $total]
		incr cards($i)
	    } elseif {$total == 21} then {
		# Stand; hit again is an automatic bust
		incr m
		break
	    }
	}
    }
    return $m
}

array set deck {}
for {set i 0} {$i < 9} {incr i} {
    set deck($i) 4
}
set deck(9) 16
set d 0

for {set i 0} {$i < 10} {incr i} {
    # Dealer showing
    incr deck($i) -1
    set p 0
    for {set j 0} {$j < 10} {incr j} {
	incr deck($j) -1
	incr p [partitions deck [expr $j+1]]
	incr deck($j)
    }
    incr deck($i)
    puts "Dealer showing $i partitions = $p"
    incr d $p
}
puts "Total partitions = $d"
