project: "outcomes"

partitions: func [
    cards[vector!]
    subtotal[integer!]
    /local total m i
][
    m: 0
    ; Hit
    loop [i 10] [
        if gt? pick cards i 0 [
            total: add subtotal i
            either lt? total 21 [
                ; Stand
                m: add m 1
                ; Hit again
		poke cards i add pick cards i -1
                m: add m (partitions cards total)
		poke cards i add pick cards i 1
            ][
                if equal? total 21 [
                    ; Stand; hit again is an automatic bust
                    m: add m 1
                ]
      	    ]
        ]
    ]
    return m
]

deck: #[4 4 4 4 4 4 4 4 4 16]
d: 0

loop [i 10] [
    ; Dealer showing
    poke deck i add pick deck i -1
    p: 0
    loop [j 10] [
        poke deck j add pick deck j -1
        p: add p (partitions deck j)
	poke deck j add pick deck j 1
    ]
    print ["Dealer showing" (sub i 1) "partitions =" p]
    d: add d p
    poke deck i add pick deck i 1
]

print ["Total partitions =" d]
