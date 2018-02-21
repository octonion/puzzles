partitions() {
    local i

    # Hit
    for i in {1..10}; do
	if (( cards[i]>0 )); then
	    (( cards[i]+=-1 ))
	    (( total=total+i ))
	    if (( total<21 )); then
		# Stand
		(( m=m+1 ))
		# Hit again
		partitions
	    elif (( total==21 )); then
		# Stand; hit again is an automatic bust
		(( m=m+1 ))
	    fi
	    (( total=total-i ))
	    (( cards[i]+=1 ))
	fi
    done
}

declare -a cards=( 4 4 4 4 4 4 4 4 4 16 )

d=0
  
for i in {1..10}; do
    # Dealer showing
    (( cards[i]+=-1 ))
    p=0
    #echo ${cards[@]}
    for j in {1..10}; do
	(( cards[j]+=-1 ))
	(( total=j ))
	(( m=0 ))
	partitions
	(( p=p+m ))
	(( cards[j]+=1 ))
    done
    #echo ${cards[@]}

    echo "Dealer showing $((i-1)) partitions = ${p}"
    (( d=d+p ))
    (( cards[i]+=1 ))
done

echo "Total partitions = ${d}"
