// #![crate_type = "dylib"]

#[no_mangle]
pub extern fn partitions(mut cards: [usize; 10], subtotal: usize) -> u32 {

    let mut m=0;
    let mut total;

    // Hit
    //println!("Subtotal = {}",subtotal);
    //println!("Cards[0] = {}",cards[0]);
    //println!("Cards[9] = {}",cards[9]);

    for i in 0..10 {
        if cards[i]>0 {
	    total = subtotal+i+1;
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
