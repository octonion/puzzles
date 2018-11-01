use BigInteger;

record Pell {
	var x, y, D: bigint;
}

proc *(a: Pell, b: Pell) {
	return new Pell(a.x*b.y+a.y*b.x,
									a.D*a.x*b.x+a.y*b.y,
									a.D);
}

proc **(a: Pell, n: int) {

	var x = new bigint(0);
	var y = new bigint(1);
	var D = a.D;
	var p = new Pell(x,y,D);
	
	var f = a;
	var m = n;

	while (m >= 1) {
		if (m%2)==1 {
			p = p*f;
		}
		m = m/2;
		f = f*f;
	}
	return p;
}

proc lcm(d: domain(int)): int {
	var l = 1;
	for i in d {
		l = (l*i)/gcd(l,i);
	}
	return l;
}

proc gcdext(x, y): (bigint,bigint,bigint) {
  if x<0 {
    var (g,a,b) = gcdext(-x, y);
		return (g,-a,b);
  }
  if y < 0 {
    var (g,a,b) = gcdext(x,-y);
    return (g,a,-b);
  }
  var (r0,r1) = (x,y);
  var a0 = new bigint(1);
	var b1 = new bigint(1);
  var a1 = new bigint(0);
	var b0 = new bigint(0);
	var q: bigint;
	
  while !(r1==0) {
    q = r0/r1;
    (r0,r1) = (r1,r0-q*r1);
    (a0,a1) = (a1,a0-q*a1);
    (b0,b1) = (b1,b0-q*b1);
  }
  return (r0,a0,b0);
}
  
proc invert(num, mod) {
  var (g,a,b) = gcdext(num, mod);
  //unless g == 1
  //  raise ZeroDivisionError.new("#{num} has no inverse modulo #{mod}")
  //end
  return a % mod;
}

proc squarefree_part(x) {
  var sf = 1;
  var factors = factor(x);
	//writeln(factors);
  for prime in factors.domain do
    if (factors[prime] % 2==1) {
      sf = sf*prime;
		}
  return sf;
}

proc divmod(n: int, d: int): (int, int) {
	var q,r: int;
	
	q = n/d;
	r = n % d;
	return (q,r);
}

proc check(q,p): (int,int) {
	var d,e,r,t: int;

	t = q;
	d = q;
  (d,r) = divmod(t,p);
  while (r==0) {
    t = d;
    e += 1;
    (d,r) = divmod(t,p);
  }
  return (t,e);
}
  
proc factor(q) {

	var prime_e: domain(int);
	var factors: [prime_e] int;

	var d,e,p,t: int;

	t = q;
	p = 2;
  (d, e) = check(t,p);
	if !(e==0) {
		t = d;
		factors[p] = e;
	}
	p = 3;
  (d, e) = check(t,p);
	if !(e==0) {
		t = d;
		factors[p] = e;
	}
	p = 5;
  while (p*p <= t)	{
    (d, e) = check(t,p);
		if !(e==0) {
			t = d;
			factors[p] = e;
		}
    p += 2;
		(d, e) = check(t,p);
		if !(e==0) {
			t = d;
			factors[p] = e;
		}
    p += 4;
	}
	if (t > 1) {
		factors[t] = 1;
	}
	return factors;
}

//var D=609*7766*2*2*4657*4657;
//write("D = ",D," =");

//var f = factor(D);

//for prime in f.domain do
//	write(" ",prime,"^",f[prime]);

//writeln();

//var a = new Pell(new bigint(3),new bigint(5),new bigint(61));
//var b = new Pell(new bigint(2),new bigint(13),new bigint(61));
//var m = a*b;
//var e = a**100;

//writeln(a);
//writeln(b);
//writeln(m);
//writeln(e);

// Solving y^2 - D*x^2 = 1

// Archimedes cattle problem
// Removing factor 2^2*4657^2

//arg = 609*7766*2**2*4657**2
// BigInt.new(ARGV[0])
config var arg = 61;
var D = new bigint(arg);

// Squarefree part
var d = squarefree_part(arg);
//writeln(arg," ",d);

// Square part
var s = arg/d;

var sd = new bigint(floor(sqrt(d)):int);

//writeln(s," ",sd);

var x_init = new bigint(1);
var y_init = sd;
var h_init = (d*x_init**2 - y_init**2);

var i = (-y_init % h_init)*(invert(x_init,h_init) % h_init) % h_init;
var m_init = h_init*(sd/h_init) + i;

if (m_init>sd) {
  m_init += -h_init;
}

var steps = 0;

var x = x_init;
var y = y_init;
var h = h_init;
var m = m_init;

//writeln();
writeln("[h, m] = [",h,",",m,"]");

while !(h==1 || h==2 || h==4) {

  //writeln("[x, y, h, m] = [",x,",",y,",",h,",",m,"]");

  x = (m_init*x_init+y_init)/h_init;
  y = (d*x_init+m_init*y_init)/h_init;

  h = (d-m_init**2)/h_init;
	
  //print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  i = ((-y % h)*(invert(x,h) % h) % h);
  m = h*(sd/h) + i;

  //print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  if (m>sd) {
    m += -h;
  }

  //print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  x_init = x;
  y_init = y;
  h_init = h;
  m_init = m;
  steps += 1;

  writeln("[h, m] = [",h,",",m,"]");
}

writeln();
writeln("h = ",h);

if (h==1 && (steps % 2)==0) {
	
  (x,y) = (2*x*y,d*x**2+y**2);
	
} else if h==2 {
	
  (x,y) = (2*x*y,d*x**2+y**2);
  (x,y) = (x/2,y/2);
	
} else if h==4 {

	//a, b = BigRational(x,2), BigRational.new(y,2)
	var (a,b) = (x,y);
  
  if (a%2==0 && b%2==0) {
		
    (x,y) = (a/2,b/2);
		
	}	else {

    var (a_1, b_1) = (2*a*b, d*a*a+b*b);
    
    if (a_1%4==0 && b_1%4==0) {
			
      (x,y) = (a_1/4, b_1/4);
			
		}	else {
      
      (x,y) = (a*b_1+a_1*b, b*b_1+d*a*a_1);
			
      if (steps % 2)==0 {
        (x,y) = (2*x*y/8,(d*x*x+y*y)/8);
      }
      (x,y) = (x/8,y/8);
      
		}
    
	}
}

var v = y**2-d*x**2;

writeln();
writeln("squarefree equation: ",d,"*x^2 + 1 = y^2");
writeln("squarefree solution = [",x,",",y,",",v,"]");
writeln("steps = ",steps);

// Find power for each p^k factor, take LCM

var e = 1;

if (s>1) {

  var rs = floor(sqrt(s)):int;
  var rs_f = factor(rs);

  var powers: domain(int);

  var a = new Pell(x, y,new bigint(d));

	for prime in rs_f.domain {

		var j = 1;
    m = prime**rs_f[prime];
        
    var b = new Pell(a.x % m, a.y % m, a.D);
    var r = b.x;
        
    var c = b;
        
    while !(r==0) {
      c = c*b;
      r = c.x % m;
      j += 1;
    }
		
    powers += j;
  }

  e = lcm(powers);
  var b = a**e;
  (x,y) = (b.x/rs,b.y);
}

v = y**2-arg*x**2;

writeln();
writeln("full equation: ",arg,"*x^2 + 1 = y^2");
writeln("full solution = [",x,",",y,",",v,"]");
writeln();
writeln("power = ",e);

writeln((x:string).length,", ",(y:string).length);
