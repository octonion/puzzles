use BigInteger;

// 609*7766*2**2*4657**2;
config var D: bigint = 609*7766;

writeln("D = ",D);

var s: bigint;
s.sqrt(D);

var a: bigint = 1;

// Reduced form

var m: bigint;
m.sqrt(2+D);
var b: bigint = 2*m;
var c:bigint = m**2-D;

var sD: bigint;
sD.sqrt(b**2-4*a*c);

var d = (b+sD)/(2*(c.sgn()*c));

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

var i = 0;

var a1,b1,c1: bigint;

while (c!=1) {

  i += 1;

  a1 = c;
  b1 = -b+2*c*d;
  c1 = a-b*d+c*d**2;

  a = a1;
  b = b1;
  c = c1;

  d = (b+sD)/(2*(c.sgn()*c));

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

writeln("Steps = ",i);
//writeln(p11," ",p12," ",p21," ",p22);

writeln("x = ", (p11+m*p21).sgn()*(p11+m*p21));
writeln("y = ", p21.sgn()*p21);
