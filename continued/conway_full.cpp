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
  };

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
  };

  Pell operator ^ (const mpz_class n) {
    
    Pell p(0,1,D);
    Pell f(x,y,D);
    mpz_class m = n;

    while (m >= 1) {
      if ((m%2)==1) {
	  p = p*f;
      };
      m = m/2;
      f = f*f;
    };
    return p;
  };
  
};

int hpow(mpz_class a, mpz_class n) {
  mpz_class r;
  mpz_class m = n;
  int res = 0;
  r = m%a;
  m = m/a;
  while (r==0) {
    r = m%a;
    m = m/a;
    res += 1;
  };
  return res;
}

int jacobi(mpz_class a, mpz_class n) {

  // Handle error
  //raise ArgumentError.new "n must be positive and odd" if n < 1 || n.even?
  
  int result = 1;
  mpz_class nn;
  a = a % n;
  while (a != 0) {
    while ((a % 2)==0) {
      a = (a >> 1);
      nn = n%8;
      if (nn==3 || nn==5) {
	  result = -result;
	}
    }
    swap(a,n);
    if ((a%4)==3 && (n%4)==3) {
	result = -result;
      }
    a = a % n;
  }
  if (n==1) {
    return result;
  }
  return 0;
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

  while (!((c==1) || (c==-1) || (c==2) || (c==-2) || (c==4) || (c==-4))) {

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

  //cout << "c = " << c << endl;

  mpz_class x,y;

  y = p11+m*p21;
  x = p21;

  //y = abs(p11+m*p21);
  //x = abs(p21);

  if (c==-1) {
    //cout << "c = -1" << endl;
    //P = P*P;
    x = 2*x*y;
    y = y*y+sfD*p21*p21;
  } else if (c==2) {
    //cout << "c = 2" << endl;
    //P = Pell(x*y,(y*y+sfD*x*x)/2,sfD);
    x = x*y;
    y = (y*y+sfD*p21*p21)/2;
  } else if (c==-2) {
    //cout << "c = -2" << endl;
    //P = Pell(x*y,(y*y+sfD*x*x)/2,sfD);
    x = x*y;
    y = (y*y+sfD*p21*p21)/2;
  } else if (c==4) {
    //cout << "c = 4" << endl;
    if (y%2==0) {
      //cout << "y even" << endl;
      x = (x*y)/2;
      y = (y*y-2)/2;
    } else {
      //cout << "y odd" << endl;
      x = (x*(y*y-1))/2;
      y = (y*(y*y-3))/2;
    }
  } else if (c==-4) {
    //cout << "c = -4" << endl;
    x = (x*y*(y*y+1)*(y*y+3))/2;
    y = (y*y+2)*((y*y+1)*(y*y+3)/2-1);
  }

  cout << "Steps = " << steps << "\n";
  //cout << "x = " << abs(p11+m*p21) << "\n";
  //cout << "y = " << abs(p21) << "\n";

  //mpz_class v = y*y-sfD*x*x;

  cout << endl;
  cout << "Squarefree equation: " << sfD << "*x^2 + 1 = y^2\n";
  cout << "Squarefree solution = [" << x << "," << y << "]" << endl;

  // Let A be the fundamental solution to the square-free Pell equation
  //   with parameter D. Let sfD be the square-free parameter, and let
  //   sD = sqrt(D/sfD).
  //
  // Let p^e be the highest power of p dividing sD.
  //
  // Case 1: p odd does not divide sfD
  //
  //   let j = Jacobi(sfD, p), then the smallest power m
  //     such that A**m.x = 0 (mod p) divides (p-j)/2
  //   use a fast algorithm, identical in structure to
  //     finding the order of a mod n i.e. the smallest m
  //     such that a^m = 1 (mod n)
  //   if the highst power of p dividing A**m.x is p^k
  //     then the Pell exponent for p^e = m*p^{e-k}
  //
  // Case 2: p odd does divide sfD
  //
  //   careful: p=3 is a special case, we must check A**3
  //   otherwise, we only pick up a single power with every p
  //
  //   if the highest power of p dividing A.x is p^k
  //     then Pell exponent for p^e = p^{e-k}
  //
  // Case 3: p = 2
  //
  //   if the highest power of 2 dividing A.x is p^k
  //     then the Pell exponent for p^e = p^{e-k}
  //
  // The overall Pell exponent is the lcm of these powers.

  mpz_class exponent = 1;

  if (sD>1) {

    auto rs = sqrt(sD);
    Pell a(x, y, sfD);
    Pell eb;
    mpz_class tmp;
    int h;

    for(auto const& [p, e] : factor(rs)) {

      mpz_class m;

      // Need to handle p=2 later

      mpz_class power = 1;

      //eb = a;

      // How to do this faster?
      if ((p!=2) && (sfD%p!=0)) {
      
	mpz_pow_ui(m.get_mpz_t(),p.get_mpz_t(),e);

	// Do modular

	// What if a.x % m = 0?
	//Pell b(a.x % m, a.y % m, a.D);
	Pell b(x % m, y % m, sfD);
	mpz_class r = b.x;
	Pell c = b;

	int j;
	//if (p==2) {
	//  j = 0; }
	//else {
	j = jacobi((sfD%p),p);
	//}

	mpz_class order;
	order = ((p-j)/2);

	// Need modular Pell class

	for(auto const& [p1, e1] : factor(order)) {
	  mpz_class ei,term;
	  mpz_pow_ui(term.get_mpz_t(),p1.get_mpz_t(),e1);
	  ei = order/term;
	  //Pell eb = b^ei;
	  eb = b^ei;
	  if (((eb.x)%m)!=0) {
	    int k = 1;
	    while ((((eb.x) % m)!=0) && (k<e1)) {
	      eb = eb^p1;
	      power = power*p1;
	      k += 1;
	    }
	    if (((eb.x) % m)!=0) {
	      power = power*p1;
	    }
	  }
	  //cout << m << endl;
	  //cout << eb.x << endl;
	}
      }

      // Can this be done more efficiently?
      //cout << power << endl;
      //eb = a^power;

      // Need to be careful here. Don't need to check if we've already
      // calculated and e=1, for example.
      
      // 1) calculated, e=1
      // 2) calculated, e>1
      // 3) didn't calculate
      //     p=3 is special

      // This illustrates a potential problem
      // If a.x<>0 mod p, need to compute the highest order of p dividing a^p.x

      if ((sfD%p)==0) {
	// Check which cases
	if ((p==2) || (p==3)) {
	  if (e==1) {
	    // optional
	    // h = hpow(p,(a^3).x);
	    h = 1;
	    power = 1;
	  } else {
	    h = hpow(p,(a^p).x);
	    power = p;
	  }
	} else {
	  // Same as h = hpow(p,a.);
	  h = hpow(p,x);
	}
      } else {
	// Check which cases
	if ((p==2) || (p==3)) {
	  if (e==1) {
	    // optional
	    // h = hpow(p,(a^3).x);
	    h = 1;
	    power = 1;
	  } else {
	    h = hpow(p,(a^p).x);
	    power = p;
	  }
	}
	if (e>1) {
	  eb = a^power;
	  h = hpow(p,eb.x);
	}
      }

      if (e>h) {
	mpz_pow_ui(tmp.get_mpz_t(),p.get_mpz_t(),(e-h));
	power = power*tmp;
      }
      
      //h = hpow(p,x);
      
      //cout << p << " " << power << endl;

      //cout << "3:" << a.x%3 << endl;
      //cout << "3:" << hpow(3,(a^3).x) << endl;

      //if ((p==2) || (sfD%p==0)) {
      //h = hpow(p,a.x);
      //cout << p << " " << h << endl;
      //} else if (e>1) {
      //eb = a^power;
      //h = hpow(p,eb.x);
      //cout << p << " " << h << endl;
      //}
      //if (e>h) {
      //mpz_pow_ui(tmp.get_mpz_t(),p.get_mpz_t(),(e-h));
      //power = power*tmp;
      //}
      exponent = lcm(exponent,power);

      // m = p^e
      //powers.append(power)
      //cout << a.x << " " << a.y << " " << a.D << endl;
      //cout << p << " " << e << " " << power << endl;
      //cout << "  " << hpow(p,a.x) << " " << hpow(p,(a^power).x) << endl;
      //cout << "  " << hpow(p,(a^2).x) << " " << hpow(p,(a^4).x) << endl;
      
    }
		
    //powers += j;

    ///e = lcm(powers);
    
    //Pell b = a^exponent;
    //x = b.x/rs;
    //y = b.y;
      
    //(x,y) = (b.x/rs,b.y);
  }
    
  // mpz_class v = y*y-D*x*x;

  cout << endl;
  cout << "Full equation: " << D << "*x^2 + 1 = y^2\n";
  //cout << "Full solution = [" << x << "," << y << "]\n";
  //cout << v << endl;
  cout << endl;
  cout << "Power = " << exponent << endl;

  //cout << mpz_sizeinbase(x.get_mpz_t(), 10) << ", " << mpz_sizeinbase(y.get_mpz_t(), 10) << endl;
  
  return 0;
}
