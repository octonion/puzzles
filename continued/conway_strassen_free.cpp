#include <iostream>
#include <gmpxx.h>
using namespace std;

int main (int argc, char* argv[])
{
  mpz_class D, a, b, c, d, m, sD;

  D = argv[1];
  cout << "D = " << D << "\n";

  a = 1;

  // Reduced form

  m = sqrt(2+D);
  b = 2*m;
  c = m*m-D;

  sD = sqrt(b*b-4*a*c);

  //d = (b+sD)/(2*abs(c));
  if (c<0) {
    d = (b+sD)/(-2*c);
    d = -d;
  } else {
    d = (b+sD)/(2*c);
  }

  if (c<0) {
    d = -d;
  }

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

    a1 = c;
    b1 = -b+2*c*d;
    c1 = a-b*d+c*d*d;

    a = a1;
    b = b1;
    c = c1;

    //d = (b+sD)/(2*abs(c));

    if (c<0) {
      d = (b+sD)/(-2*c);
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

  cout << "Steps = " << steps << "\n";
  cout << "x = " << abs(p11+m*p21) << "\n";
  cout << "y = " << abs(p21) << "\n";

  return 0;
}
