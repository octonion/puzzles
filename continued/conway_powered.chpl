use Math;

use GMP;

use BigInteger;

record Pell {
	var x, y, D: bigint;
}

operator *(a: Pell, b: Pell) {
	return new Pell(a.x*b.y+a.y*b.x,a.D*a.x*b.x+a.y*b.y,a.D);
}

operator **(a: Pell, n: int) {

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

  e = 0;
  t = q;
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

  var d,e,t,p: int;

  t = q;
  p = 2;
  (d, e) = check(t,p);
  if !(e==0) {
    t = d;
    // Add the prime p as a key
    prime_e.add(p);
    factors[p] = e;
  }
  p = 3;
  (d, e) = check(t,p);
  if !(e==0) {
    t = d;
    // Add the prime p as a key
    prime_e.add(p);
    factors[p] = e;
  }
  p = 5;
  while (p*p <= t) {
    (d, e) = check(t,p);
    if !(e==0) {
      t = d;
      // Add the prime p as a key
      prime_e.add(p);
      factors[p] = e;
    }
    p += 2;
    (d, e) = check(t,p);
    if !(e==0) {
      t = d;
      // Add the prime p as a key
      prime_e.add(p);
      factors[p] = e;
    }
    p += 4;
  }
  if (t > 1) {
    // Add the prime t as a key
    prime_e.add(t);
    factors[t] = 1;
  }
  return factors;
}

// 
config var arg: int = 609*7766*2**2*4657**2;

var D = new bigint(arg);
writeln("D = ",D);

// Squarefree part
var sfD = squarefree_part(arg);

// Square part
var sD = arg/sfD;

var a: bigint = 1;

// Reduced form

var big_sfD = new bigint(sfD);
var m: bigint;

sqrt(m,(2+big_sfD));
var b = 2*m;
var c = m**2-big_sfD;

var sDel: bigint;
sqrt(sDel,(b**2-4*a*c));

var d = (b+sDel)/(2*(c.sgn()*c));

if (c<0) {
  d = -d;
}

var p11,p12,p21,p22: bigint;
var dp12,dp22: bigint;
var q,r: bigint;

p11 = 0;
p12 = 1;
p21 = -1;
p22 = -d;

var steps = 0;

var a1,b1,c1: bigint;

while (c!=1) {

  steps += 1;

  a1 = c;
  b1 = -b+2*c*d;
  c1 = a-b*d+c*d**2;

  a = a1;
  b = b1;
  c = c1;

  d = (b+sDel)/(2*(c.sgn()*c));

  if (c<0) {
    d = -d;
  }

  dp12 = d*p12;
  dp22 = d*p22;
  
  q = p21;
  r = p11;
  p11 = p12;
  p12 = -r+dp12;
  p21 = p22;
  p22 = dp22-q;

}

writeln("Steps = ",steps);
//writeln(p11," ",p12," ",p21," ",p22);

var y = (p11+m*p21).sgn()*(p11+m*p21);
var x = p21.sgn()*p21;

writeln("x = ", x);
writeln("y = ", y);

//var v = y**2-sfD*x**2;

writeln();
writeln("squarefree equation: ",sfD,"*x^2 + 1 = y^2");
//writeln("squarefree solution = [",x,",",y,",",v,"]");
writeln("steps = ",steps);

// Find power for each p^k factor, take LCM

var e = 1;

if (sD>1) {

  var rs = floor(sqrt(sD)):int;
  var rs_f = factor(rs);

  var powers: domain(int);

  var a = new Pell(x, y,new bigint(sfD));

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

//v = y**2-D*x**2;

writeln();
writeln("full equation: ",D,"*x^2 + 1 = y^2");
writeln("full solution = [",x,",",y,"]");
writeln();
writeln("power = ",e);

writeln((x:string).size,", ",(y:string).size);
