function partitions

    # Hit
    for i in (seq 10)
        if [ $cards[$i] -gt 0 ]
	    set total (math $total+$i)
	    if [ $total -lt 21 ]
	       # Stand
	       set m (math $m+1)
	       # Hit again
	       set cards[$i] (math $cards[$i]-1)
	       partitions
	       set cards[$i] (math $cards[$i]+1)
	    else if [ $total -eq 21 ]
	       # Stand; hit again is an automatic bust
	       set m (math $m+1)
	    end
	    set total (math $total-$i)
	end
    end
end

set cards 4 4 4 4 4 4 4 4 4 16

set d 0

for i in (seq 10)
    # Dealer showing
    set cards[$i] (math $cards[$i]-1)
    set p 0

    #echo {$cards}
    for j in (seq 10)
	set cards[$j] (math $cards[$j]-1)
	set total $j
	set m 0
	partitions
	set p (math $p+$m)
	set cards[$j] (math $cards[$j]+1)
    end
    #echo {$cards}

    echo "Dealer showing $i partitions = $p"
    set d (math $d+$p)
    set cards[$i] (math $cards[$i]+1)
end

echo "Total partitions = $d"
