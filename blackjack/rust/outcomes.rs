type Count = u32;
type Total = u32;

fn partitions(cards: &mut [Count; 10], subtotal: Count) -> Total {
    let mut m=0;
    let mut total;
    // Hit
    for i in 0..10 {
        if cards[i]>0 {
	    total = subtotal+i as Count+1;
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
                break;
	    }
        }
    }
    return m;
}
    
fn main() {
    
    let mut deck: [Count; 10] = [4; 10];
    deck[9] = 16;
    
    let mut d=0 as u32;
    for i in 0..10 {
        // Dealer showing
        deck[i] -= 1;
        let mut p = 0 as u32;
        for j in 0..10 {
            deck[j] -= 1;
            let n = partitions(&mut deck, j as Count+1);
            deck[j] += 1;
            p += n;
        }
        println!("Dealer showing {}, partitions = {}",i,p);
        d += p;
        deck[i] += 1;
    }
    println!("Total partitions = {}",d);
}
