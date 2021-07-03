use OrderedSet;
use DistributedDeque;
use BigInteger;

const bound = 20000;

var values: [0..bound] bigint;
for j in 1..bound {
  values[j] = new bigint(j);
}

proc fac(n) {
  var r = new bigint(1);
  //d = [
  r =* reduce values[1..n];
  return r;
}

var found = new orderedSet(int);
found.add(3);

var queue = new DistDeque(int);
queue.enqueue(3);

var keys: domain(int);
keys += 3;

var paths: [keys] int;
paths[3] = 3;

var sqrts: [keys] int;
sqrts[3] = 0;
 
var m: int;
var n: bigint;
var nn: int;
var i: int;

while (queue.getSize()>0) {

  m = queue.popFront()[1];
  n = fac(m);
  i = 0;
  while n>=bound {
    n.sqrt(n);
    i += 1;
  }
  nn = n:int;
  
  while (nn>3) {
    if !(found.contains(nn)) {
      found.add(nn);
      queue.pushBack(nn);
      keys += nn;
      paths[nn] = m;
      sqrts[nn] = i;
    }
    nn = (sqrt(nn)):int;
    i += 1;
  }
}

for i in 3..1000 {
  if !(found.contains(i)) {
    write(i," ");
  }
}
writeln();
writeln();
    
var v = 9;
var w: int;
while !(v==3) {
  w = paths[v];
  writeln(v," <- ",w,"! + ",sqrts[v]," sqrt");
  v = w;
}
