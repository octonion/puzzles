use BigInteger;
use LinearAlgebra;

// 609*7766*2**2*4657**2;
config var D: bigint = 61;

writeln("D = ",D);

var s: bigint;
s.sqrt(D);

var a: bigint = 1;

// Reduced form

var m: bigint;
m.sqrt(2+D);
var b: bigint = 2*m;
var c:bigint = m**2-D;

var MR = Matrix(2,2,eltType=bigint);
MR = Matrix([1,-m:int],
	    [0,1]);

var ML = Matrix(2,2,eltType=bigint);
ML = Matrix([1,m:int],
	    [0,1]);

var sD: bigint;
sD.sqrt(b**2-4*a*c);

var d = (b+sD)/(2*(c.sgn()*c));

if (c<0) {
  d = -d;
}

var p,q = Matrix(2,2,eltType=bigint);
p = -Matrix([0,1],[-1,-d:int]);

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

  q = Matrix([0,-1],[1,d:int]);
  p = dot(p,q);

}

writeln("Steps = ",i);

var pa = dot(ML,dot(p,MR));

writeln("x = ", pa[1,1].sgn()*pa[1,1]);
writeln("y = ", pa[2,1].sgn()*pa[2,1]);
