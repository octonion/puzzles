public func partitions(subtotal:Int,cards:UnsafeMutableBufferPointer<Int>) -> Int {
    func p(cards: inout [Int], subtotal: Int) -> Int {
        var m = 0
        // Hit
        for i in 0...9 {
            if (cards[i]>0) {
                let total = subtotal+i+1
                if (total < 21) {
                    // Stand
                    m += 1
                    // Hit again
                    cards[i] += -1
                    m += p(cards:&cards,subtotal:total)
                    cards[i] += 1
                } else if (total==21) {
                    // Stand; hit again is an automatic bust
                    m += 1
                }
            }
        }        
        return m
    }

    var a: Array<Int> = []
    for i in 0...9 {
        a.append(cards[i])
    }

    return p(cards:&a, subtotal:subtotal)
}
