use std::collections::VecDeque;
use std::collections::HashMap;
use std::collections::BTreeSet;
use rug::Integer;
use rug::Float;
use rug::float::Round;
use std::cmp;
use num_integer::Roots;

//const BOUND: Integer = Integer::from(1000000);
//const LB: Float::new(400) = (Float::with_val(400,BOUND)).ln();

fn main() {

    let mut found = BTreeSet::new();
    found.insert(3);
    
    let mut paths = HashMap::new();
    paths.insert(3,3);

    let mut sqrts = HashMap::new();
    sqrts.insert(3,0);
    
    let mut queue = VecDeque::new();
    queue.push_back(3);
    
    let bound = Integer::from_str_radix("10000000000",10).unwrap();
    //println!("bound = {} ",bound);
    let lb = (Float::with_val(400,bound)).ln();
    //println!("lb = {} ",lb);
        
    //let mut x = Float::new(400);
        
    //    let mut m: u32;
    let mut i: u32;
    let mut p: u32;
    let mut q: u32;
    
    let mut m: u64;
    let mut n: Integer;
    let mut nn: u64;

    while !(queue.is_empty()) {

	    m = queue.pop_front().unwrap();
        //println!("m = {}",m);
        let x = (Float::with_val(400, m+1)).ln_gamma();
        //println!("x = {}",x);
        
        //p = ceil(log(x/lb,2));
        //println!("x/b = {}",Float::with_val(400, &x/&lb));
        
        p = ((Float::with_val(400, &x/&lb)).log2()).to_u32_saturating_round(Round::Up).unwrap();
        //println!("p = {}",p);

	    i = 0;

        q = cmp::max(p,0);

        i += q;

        //println!("i = {}",i);
        //println!("q = {}",q);

        //n = round(exp(x/2^q));
        n = (&x/Float::with_val(400,2u64.pow(q))).exp().to_integer().unwrap();
        //println!("n = {}",n);

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

    let mut j = 3;
    while j < 1000000 {
        if !(found.contains(&j)) {
	        print!("{} ",j);
            break;
        }
        j += 1;
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
    
    println!();

    v = 522;
    while !(v==3) {
        w = paths[&v];
        println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
        v = w;
    }

    println!();

    v = 1074;
    while !(v==3) {
        w = paths[&v];
        println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
        v = w;
    }

    println!();

    v = 1337;
    while !(v==3) {
        w = paths[&v];
        println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
        v = w;
    }
    
    println!();

    v = 10509;
    while !(v==3) {
        w = paths[&v];
        println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
        v = w;
    }

//    println!();

//    v = 22701;
//    while !(v==3) {
//        w = paths[&v];
//        println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
//        v = w;
//    }

//    println!();
//
//    v = 75592;
//    while !(v==3) {
//        w = paths[&v];
//        println!("{} <- {}! + {} sqrt",v,w,sqrts[&v]);
//        v = w;
//    }

}
