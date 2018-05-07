fn partitions(cards: &mut [u8; 10], subtotal: u8) -> u32 {
    let mut m=0 as u32;
    let mut total: u8;
    
    // Hit
    for i in 0..10 {
        if cards[i]>0 {
	    total = subtotal+1+(i as u8);
	    if total < 21 {
	        // Stand
	        m += 1;
	        // Hit again
                cards[i] -= 1;
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
    
    let mut deck: [u8; 10] = [4; 10];
    deck[9] = 16;
    
    let mut d=0 as u32;
    for i in 0..10 {
        // Dealer showing
        deck[i] -= 1;
        let mut p = 0 as u32;
        for j in 0..10 {
            deck[j] -= 1;
            let n = partitions(&mut deck, (j as u8)+1);
            deck[j] += 1;
            p += n;
        }
        println!("Dealer showing {}, partitions = {}",i,p);
        d += p;
        deck[i] += 1;
    }
    println!("Total partitions = {}",d);
}
