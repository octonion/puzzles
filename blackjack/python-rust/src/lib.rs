// #![crate_type = "dylib"]

use std::slice;

#[no_mangle]
pub extern fn partitions(ptr: *mut usize, len: usize, subtotal: usize) -> usize {
    // assert!(!ptr.is_null());
    let cards = unsafe { slice::from_raw_parts_mut(ptr, len) };

    let mut m=0;
    let mut total;

    // Hit

    //println!("Subtotal = {}",subtotal);

    for i in 0..10 {
        if cards[i]>0 {
	    total = subtotal+i+1;
	    if total < 21 {
	        // Stand
	        m += 1;
	        // Hit again
                cards[i] -= 1;
	        m += partitions(ptr, len, total);
                cards[i] += 1;
	    } else if subtotal+i+1==21 {
	        // Stand; hit again is an automatic bust
	        m += 1;
	    }
        }
    }
    return m;
}
