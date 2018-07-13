Rebol [
      Title: "Outcomes"
]

partitions: func [cards subtotal /local m i total]
[
    m: 0
    i: 1
    ; Hit
    while [i < 11] [
        if cards/(i) > 0 [
            total: subtotal + i
            either total < 21 [
                ; Stand
                m: m + 1
                ; Hit again
                cards/(i): cards/(i) - 1
                m: m + partitions cards total
                cards/(i): cards/(i) + 1
            ][
                if total = 21 [
                    ; Stand; hit again is an automatic bust
                    m: m + 1
                ]
      	    ]
        ]
        i: i + 1
    ]
    return m
]

deck: [4 4 4 4 4 4 4 4 4 16]
d: 0

repeat i 10 [
    ; Dealer showing
    deck/(i): deck/(i) - 1
    p: 0
    repeat j 10 [
        deck/(j): deck/(j) - 1
        p: p + partitions deck j
        deck/(j): deck/(j) + 1
    ]
    print ["Dealer showing" (i - 1) "partitions =" p]
    d: d + p

    deck/(i): deck/(i) + 1
]

print ["Total partitions =" d]
