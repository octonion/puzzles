#include <iostream>
#include <map>
#include <set>
#include <bits/stdc++.h>
#include <gmp.h>
#include <gmpxx.h>
#include <math.h>

using namespace std;

int main() {

  //int bound = 50000;
  mpz_class bound;
  //mpz_init bound;
  bound = 20000;
  //mpz_set(bound,20000);
  
  int m, nn, i;
  mpz_class n;
  //mpz_init(n);

  set<int, greater<int> > found;
  found.insert(3);
  
  std::map<int, int> paths;
  paths[3] = 3;

  std::map<int, int> sqrts;
  sqrts[3] = 0;

  queue<int> queue;
  queue.push(3);

  while (!queue.empty()) {

    m = queue.front();
    queue.pop();

    mpz_fac_ui(n.get_mpz_t(),m);
    i = 0;

    //while (mpz_cmp_ui(n,bound)>0) {
    //    while (mpz_cmp(n,bound)) {
    while (bound < n) {
      mpz_sqrt(n.get_mpz_t(), n.get_mpz_t());
      i += 1;
	}

    nn = mpz_get_ui(n.get_mpz_t());
      
    while (nn>3) {
      if (!found.count(nn)) {
        //if (!found.contains(nn)) {
        found.insert(nn);
        queue.push(nn);
        paths[nn] = m;
        sqrts[nn] = i;
      }
      nn = sqrt(nn);
      //nn = (int) sqrt(nn);
      //nn = sqrt(nn);
      i += 1;
    }
  }
   
  for (int i = 3; i<1000; i++) {
    if (!found.count(i)) {
      //if (!found.contains(i)) {
      cout << i << " ";
	}
  }
  cout << endl << endl;
    
  int v = 9;
  int w;
  while (v!=3) {
      w = paths[v];
      cout << v << " <- " << w << "! + " << sqrts[v] << " sqrt" << endl;
      v = w;
    }

  return 0;
}
