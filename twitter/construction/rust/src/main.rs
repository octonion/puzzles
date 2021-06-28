use std::collections::VecDeque;
use std::collections::HashMap;
use std::collections::BTreeSet;
use num_integer::Roots;
use num_bigint::{BigInt, ToBigInt};
use num_traits::{One, ToPrimitive};

fn factorial(n: u64) -> BigInt {
    (1..=n).fold(One::one(), |a, b| a * b)
}

fn main() {

    let mut found = BTreeSet::new();
    found.insert(3);
    
    let mut paths = HashMap::new();
    paths.insert(3,3);

    let mut sqrts = HashMap::new();
    sqrts.insert(3,0);
    
    let mut queue = VecDeque::new();
    queue.push_back(3);
    
    let bound: BigInt = 20000.to_bigint().unwrap();
    let mut m: u64;
    let mut n: BigInt;
    let mut nn: u64;
    let mut i: u64;
    while !(queue.is_empty()) {

	m = queue.pop_front().unwrap();
	n = factorial(m);
	i = 0;

	while n>=bound {
	    n = n.sqrt();
	    i += 1;
	}

	nn = n.to_u64().unwrap();
      
	while nn>3 {
	    if !(found.contains(&nn)) {
		found.insert(nn);
		queue.push_back(nn);
		paths.insert(nn,m);
		sqrts.insert(nn,i);
	    }
	    nn = nn.sqrt();
	    i += 1;
	}
    }
   
    for f in found {
	print!("{} ",f);
    }
    println!();
    println!();
    
    let mut v = 9;
    let mut w: u64;
    while !(v==3) {
	w = paths[&v];
	println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
	v = w;
    }

}
