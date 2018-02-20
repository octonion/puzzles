function partitions {
    #echo ${cards[@]}

    typeset i

    # Hit
    for i in {0..9}; do
	if (( cards[i] > 0 )); then
	    #echo "Removing from ${i}"
	    (( cards[i]+=-1 ))
	    (( total=total+i+1 ))
	    if (( total < 21 )); then
		# Stand
		(( m=m+1 ))
		# Hit again
		partitions
	    elif (( total == 21 )); then
		# Stand; hit again is an automatic bust
		(( m=m+1 ))
	    fi
	    (( total=total-i-1 ))
	    #echo "Adding to ${i}"
	    (( cards[i]+=1 ))
	fi
    done
}

set -A cards 4 4 4 4 4 4 4 4 4 16

d=0
  
for i in {0..9}; do
    # Dealer showing
    (( cards[i]+=-1 ))
    p=0
    #echo ${cards[@]}
    for j in {0..9}; do
	(( cards[j]+=-1 ))
	(( total=j+1 ))
	(( m=0 ))
	partitions
	(( p=p+m ))
	(( cards[j]+=1 ))
    done
    #echo ${cards[@]}

    echo "Dealer showing ${i} partitions = ${p}"
    (( d=d+p ))
    (( cards[i]+=1 ))
done

echo "Total partitions = ${d}"
