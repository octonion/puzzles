import std.stdio, std.algorithm, std.range, std.bigint, std.math;
import std.container.rbtree, std.container.dlist;

//use OrderedSet;
//use DistributedDeque;
//use BigInteger;
 
BigInt factorial(in uint n) pure nothrow
{
  auto result = BigInt(1);
  foreach (immutable i; 1 .. n + 1)
        result *= i;
  return result;
}

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
 
void main() {

  int bound = 1000;

  auto found = redBlackTree!int(3);
  auto queue = [3];
  auto paths = [3:3];
  auto sqrts = [3:0];
  int i,m,nn;
  BigInt n;

  while (!queue.empty()) {
    m = queue.front;
    queue.popFront();

    n = factorial(m);
    i = 0;
    while (n>=bound) {
      n = n.iRoot(2);
      i += 1;
    }
    
    nn = cast(int)n;

    while (nn>3) {
      if (!(nn in found)) {
	found.insert(nn);
	queue ~= nn;
	paths[nn] = m;
	sqrts[nn] = i;
    }
      nn = cast(int)(sqrt(cast(float)nn));
      i += 1;
    }
  }

  for (int j = 3; j < 1000; j++) {
    if (!(j in found)) {
	write(j," ");
      }
  }
  writeln();
  writeln();
    
  auto v = 9;
  int w;
  while (!(v==3)) {
    w = paths[v];
    writeln(v," <- ",w,"! + ",sqrts[v]," sqrt");
    v = w;
  }

}
