let rec partitions (cards: int [], subtotal: int) : int =
    let mutable m = 0
    // Hit
    for i in 0 .. 9 do
        if (cards.[i]>0) then
            let total = subtotal+i+1
            if (total < 21) then
                // Stand
                m <- m+1
                // Hit again
                cards.[i] <- cards.[i]-1
                m <- m+partitions(cards, total)
                cards.[i] <- cards.[i]+1
            elif (total=21) then
                // Stand; hit again is an automatic bust
                m <- m+1
    m

let mutable deck = [| 4; 4; 4; 4; 4; 4; 4; 4; 4; 16 |]
let mutable d = 0

for i in 0 .. 9 do
    // Dealer showing
    deck.[i] <- deck.[i]-1
    let mutable p = 0
    for j in 0 .. 9 do
        deck.[j] <- deck.[j]-1
        p <- p + partitions(deck, j+1)
        deck.[j] <- deck.[j]+1
    printfn "Dealer showing %d partitions = %d" i p
    d <- d+p
    deck.[i] <- deck.[i]+1
printfn "Total partitions = %d" d
