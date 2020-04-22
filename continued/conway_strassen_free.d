import std.stdio, std.bigint;

auto iRoot(BigInt b, int n) in {
  assert(b >=0 && n > 0);
 } body {
  if (b < 2) return b;
  auto n1 = n - 1;
  auto n2 = BigInt(n);
  auto n3 = BigInt(n1);
  auto c = BigInt(1);
  auto d = (n3 + b) / n2;
  auto e = (n3 * d + b / d^^n1) / n2;
  while (c != d && c != e) {
    c = d;
    d = e;
    e = (n3 * e + b / e^^n1) / n2;
  }
  if (d < e) return d;
  return e;
 }

void main(in string[] args) {

  // 410286423278424
  
  auto D = BigInt(args[1]); //"101011111111");
  writeln("D = ",D);

  auto a = BigInt(1);

  // Reduced form

  auto m = (2+D).iRoot(2);
  auto b = 2*m;
  auto c = m*m-D;

  auto sD = (b*b-4*a*c).iRoot(2);

  auto d = BigInt(0);

  if (c<0) {
    d = (b+sD)/(2*(-c));
    d = -d;
  } else {
    d = (b+sD)/(2*c);
  }

  BigInt dp12,dp22;
  BigInt q,r;

  auto p11 = BigInt(0);
  auto p12 = BigInt(1);
  auto p21 = BigInt(-1);
  auto p22 = -d;

  auto steps = 0;

  BigInt a1,b1,c1;

  while (c!=1) {

    steps += 1;

    a1 = c;
    b1 = -b+2*c*d;
    c1 = a-b*d+c*d*d;

    a = a1;
    b = b1;
    c = c1;

    if (c<0) {
      d = (b+sD)/(2*(-c));
      d = -d;
    } else {
      d = (b+sD)/(2*c);
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
  writeln("x = ", (p11+m*p21));
  writeln("y = ", (p21));

}
