#include <iostream>
#include <gmpxx.h>
#include<bits/stdc++.h>
using namespace std;

struct Pell {
  mpz_class x, y, D;
  Pell() {}
  Pell(mpz_class x, mpz_class y, mpz_class D) : x(x), y(y), D(D) {}
  
  Pell operator * (const Pell &p) const {
    return Pell(x*p.y+y*p.x, D*x*p.x+y*p.y, D);
  }

  Pell operator ^ (const int n) {
    
    Pell p(0,1,D);
    Pell f(x,y,D);
    int m = n;

    while (m >= 1) {
      if (m%2) {
	  p = p*f;
	}
      m = m/2;
      f = f*f;
    }
    return p;
  }
  
};

tuple<mpz_class, int> check(mpz_class q, mpz_class p) {
  int e;
  mpz_class d,r,t;

  e = 0;
  t = q;
  d = t/p;
  r = t%p;
  while (r==0) {
    t = d;
    e += 1;
    d = t/p;
    r = t%p;
  }
  return make_tuple(t,e);
}

map<mpz_class, int> factor(mpz_class q) {

  map<mpz_class, int> factors;

  mpz_class d,t;
  mpz_class p;
  int e;

  t = q;
  p = 2;
  tie(d,e) = check(t,p);
  if (e!=0) {
      t = d;
      // Add the prime p and exponent e as a key-value pair
      factors.insert(pair<mpz_class,int>(p,e));
    }
  p = 3;
  tie(d, e) = check(t,p);
  if (e!=0) {
    t = d;
    // Add the prime p and exponent e as a key-value pair
    factors.insert(pair<mpz_class,int>(p,e));
  }
  p = 5;
  while (p*p <= t) {
    tie(d, e) = check(t,p);
    if (e!=0) {
      t = d;
      // Add the prime p and exponent e as a key-value pair
      factors.insert(pair<mpz_class,int>(p,e));
    }
    p += 2;
    tie(d, e) = check(t,p);
    if (e!=0) {
      t = d;
      // Add the prime p and exponent e as a key-value pair
      factors.insert(pair<mpz_class,int>(p,e));
    }
    p += 4;
  }
  if (t > 1) {
    // Add the prime t and exponent 1 as a key-value pair
    factors.insert(pair<mpz_class,int>(t,1));
  }
  return factors;
}

mpz_class squarefree_part(mpz_class x) {
  mpz_class sf;
  sf = 1;
  auto factors = factor(x);
  for(auto const& [p, e] : factors) {
    if (e%2==1) {
      sf = sf*p;
    }
  }
  return sf;
}

int main (int argc, char* argv[])
{
  mpz_class D, a, b, c, d, m, sDel;

  D = argv[1];
  cout << "D = " << D << "\n";

  mpz_class sfD,sD;

  // Squarefree part
  sfD = squarefree_part(D);

  // Square part
  sD = D/sfD;

  a = 1;

  // Reduced form

  m = sqrt(2+sfD);
  b = 2*m;
  c = m*m-sfD;

  sDel = sqrt(b*b-4*a*c);

  //d = (b+sD)/(2*abs(c));
  if (c<0) {
    d = (b+sDel)/(-2*c);
    d = -d;
  } else {
    d = (b+sDel)/(2*c);
  }

  //  if (c<0) {
  //    d = -d;
  //  }

  mpz_class p11,p12,p21,p22;
  mpz_class dp12,dp22;
  mpz_class q,r;

  p11 = 0;
  p12 = 1;
  p21 = -1;
  p22 = -d;

  int steps = 0;

  mpz_class a1,b1,c1;

  while (c!=1) {

    steps += 1;

    //cout << steps << " " << a << " " << b << " " << c << endl;

    a1 = c;
    b1 = -b+2*c*d;
    c1 = a-b*d+c*d*d;

    a = a1;
    b = b1;
    c = c1;

    //d = (b+sDel)/(2*abs(c));

    if (c<0) {
      d = (b+sDel)/(-2*c);
      d = -d;
    } else {
      d = (b+sDel)/(2*c);
    }

    dp12 = d*p12;
    dp22 = d*p22;
  
    q = p21;
    r = p11;
    p11 = p12;
    p12 = -r+dp12;
    p21 = p22;
    p22 = dp22-q;

    //cout << steps << " " << a << " " << b << " " << c << endl;

  }

  mpz_class x,y;

  y = abs(p11+m*p21);
  x = abs(p21);

  cout << "Steps = " << steps << "\n";
  //cout << "x = " << abs(p11+m*p21) << "\n";
  //cout << "y = " << abs(p21) << "\n";

  //mpz_class v = y*y-sfD*x*x;

  cout << endl;
  cout << "Squarefree equation: " << sfD << "*x^2 + 1 = y^2\n";
  cout << "Squarefree solution = [" << x << "," << y << "]" << endl;

  // Find power for each p^k factor, take LCM

  //for(auto const& [p, e] : factor(D)) {
  //  cout << p << " " << e << endl;
  //}

  int exponent = 1;

  if (sD>1) {

    auto rs = sqrt(sD);
    Pell a(x, y, sfD);

    int j;
    mpz_class m,r;

    Pell b,c;

    for(auto const& [p, e] : factor(rs)) {
      
      j = 1;
      mpz_pow_ui(m.get_mpz_t(),p.get_mpz_t(),e);
      Pell b(a.x % m, a.y % m, a.D);
      r = b.x;
      c = b;
        
      while (r!=0) {
	c = c*b;
	r = c.x % m;
	j += 1;
      }

      exponent = lcm(exponent,j);
		
      //powers += j;
    }

    ///e = lcm(powers);
    b = a^exponent;
    x = b.x/rs;
    y = b.y;
    //(x,y) = (b.x/rs,b.y);
  }

  // mpz_class v = y*y-D*x*x;

  cout << endl;
  cout << "Full equation: " << D << "*x^2 + 1 = y^2\n";
  cout << "Full solution = [" << x << "," << y << "]\n";
  //cout << v << endl;
  cout << endl;
  cout << "Power = " << exponent << endl;

  cout << mpz_sizeinbase(x.get_mpz_t(), 10) << ", " << mpz_sizeinbase(y.get_mpz_t(), 10) << endl;
  
  return 0;
}
