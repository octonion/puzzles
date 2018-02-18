
dyn.load("partitions.so")

partitions <- function(cards,subtotal) {
    out <- .C("partitions",
              cards=as.integer(cards),
              subtotal=as.integer(subtotal),
              m=as.integer(0))
    return(out$m)
}


deck = c(4,4,4,4,4,4,4,4,4,16)
d=0

for (i in 1:10) {
    # Dealer showing
    deck[i] = deck[i]-1
    p = 0
    for (j in 1:10) {
        deck[j] = deck[j]-1
        n = partitions(deck,j)
        deck[j] = deck[j]+1
        p = p+n
    }

    print(paste("Dealer showing ",i-1," partitions = ",p,sep=""))
    d = d+p
    deck[i] = deck[i]+1
}
print(paste("Total partitions = ",d,sep=""))
