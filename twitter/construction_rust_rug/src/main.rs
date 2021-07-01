use std::collections::VecDeque;
use std::collections::HashMap;
use std::collections::BTreeSet;
use rug::Integer;
use num_integer::Roots;

fn main() {

    let mut found = BTreeSet::new();
    found.insert(3);
    
    let mut paths = HashMap::new();
    paths.insert(3,3);

    let mut sqrts = HashMap::new();
    sqrts.insert(3,0);
    
    let mut queue = VecDeque::new();
    queue.push_back(3);
    
    let bound: Integer = Integer::from(20000);
    let mut m: u32;
    let mut n: Integer;
    let mut nn: u32;
    let mut i: u32;
    while !(queue.is_empty()) {

	m = queue.pop_front().unwrap();
	n = Integer::from(Integer::factorial(m));
	i = 0;

	while n>=bound {
	    n = n.sqrt();
	    i += 1;
	}

	nn = n.to_u32().unwrap();
      
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
   
    for i in 3..1000 {
	if !(found.contains(&i)) {
	    print!("{} ",i);
	}
    }
    println!();
    println!();
    
    let mut v = 9;
    let mut w: u32;
    while !(v==3) {
	w = paths[&v];
	println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
	v = w;
    }
}
