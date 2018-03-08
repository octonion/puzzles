fn partitions(mut cards: [usize; 10], subtotal: usize) -> i32 {
    let mut m=0;
    let mut total;
    // Hit

    for i in 0..10 {
        if cards[i]>0 {
	    total = subtotal+i+1;
	    if total < 21 {
                cards[i] -= 1;
	        // Stand
	        m += 1;
	        // Hit again
	        m += partitions(cards, total);
                cards[i] += 1;
	    } else if total==21 {
	        // Stand; hit again is an automatic bust
	        m += 1;
	    }
        }
    }
    return m;
}
    
fn main() {
    
    let mut deck: [usize; 10] = [4; 10];
    deck[9] = 16;
    
    let mut d=0;
    for i in 0..10 {
        // Dealer showing
        deck[i] -= 1;
        let mut p = 0;
        for j in 0..10 {
            deck[j] -= 1;
            let n = partitions(deck, j+1);
            deck[j] += 1;
            p += n;
        }
        println!("Dealer showing {}, partitions = {}",i,p);
        d += p;
        deck[i] += 1;
    }
    println!("Total partitions = {}",d);
}
