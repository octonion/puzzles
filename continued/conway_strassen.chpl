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

//var p,q = Matrix(2,2,eltType=bigint);
//p = -Matrix([0,1],[-1,-d:int]);

var p11,p12,p21,p22: bigint;
var dp12,dp22: bigint;
var q,r: bigint;
//var m1,m3,m5,m6,m7:bigint;
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

  //q = Matrix([0,-1],[1,d:int]);
  //p = dot(p,q);
  
  //dp11 = d*p11;
  dp12 = d*p12;
  //dp21 = d*p21;
  dp22 = d*p22;
  
  //m1 = dp11+dp22;
  //m3 = -p11-dp11;
  //m5 = dp11+dp12;
  //m6 = p11-p21;
  //m7 = p12-p22+dp12-dp22;

  //p11 = m1+p22-m5+m7;
  //p12 = m3+m5;
  //p21 = p22;
  //p22 = m1+m3+m6;

  q = p21;
  r = p11;
  p11 = p12;
  p12 = -r+dp12;
  p21 = p22;
  p22 = dp22-q;

}

writeln("Steps = ",i);
//writeln(p11," ",p12," ",p21," ",p22);

var pa = Matrix(2,2,eltType=bigint);
var pm = Matrix(2,2,eltType=bigint);

pm[1,1] = p11;
pm[1,2] = p12;
pm[2,1] = p21;
pm[2,2] = p22;

pa = dot(ML,dot(pm,MR));

writeln("x = ", pa[1,1].sgn()*pa[1,1]);
writeln("y = ", pa[2,1].sgn()*pa[2,1]);
