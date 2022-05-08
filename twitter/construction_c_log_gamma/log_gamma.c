#include <stdio.h>
#include <gmp.h>
#include <mpfr.h>
#include <math.h>

#include "queue.h"
#include "uthash.h"

#define MAX(x, y) (((x) > (y)) ? (x) : (y))

unsigned long long mpz_get_ull(mpz_t n)
{
    unsigned int lo, hi;
    mpz_t tmp;

    mpz_init( tmp );
    mpz_mod_2exp( tmp, n, 64 );   /* tmp = (lower 64 bits of n) */

    lo = mpz_get_ui( tmp );       /* lo = tmp & 0xffffffff */ 
    mpz_div_2exp( tmp, tmp, 32 ); /* tmp >>= 32 */
    hi = mpz_get_ui( tmp );       /* hi = tmp & 0xffffffff */

    mpz_clear( tmp );

    return (((unsigned long long)hi) << 32) + lo;
}

typedef struct node
{
    unsigned long long int value;
    TAILQ_ENTRY(node) nodes;
}snode;

typedef struct pair {
  unsigned long long int key;
  unsigned long int value;
  UT_hash_handle hh;
}spair;

spair *paths = NULL;
spair *sqrts = NULL;

void add_pair(spair **dict, unsigned long long int id, unsigned long int n) {
  
  spair *s;
  HASH_FIND_INT(*dict, &id, s);
  if (s == NULL) {
    s = (spair*)malloc(sizeof *s);
    s->key = id;
    s->value = n;
    HASH_ADD_INT(*dict, key, s);
  }
  
}

void print_dict(spair *dict) {
    spair *s;
    
    for (s = dict; s != NULL; s = (spair*)(s->hh.next)) {
        printf("key %lld: value %ld\n", s->key, s->value);
    }
}

unsigned long int p,q;
unsigned long long int i,m,nn;
mpz_t n;

unsigned long long int bound = 10000000000;
mpfr_t lb,x,y;

int main() {

  mpz_init(n);
  mpfr_init2(x, 400);
  mpfr_init2(y, 400);
  mpfr_init2(lb, 400);
  mpfr_set_ui(lb, bound, MPFR_RNDN);
  //mpfr_printf ("lb = %.8Rf\n", lb);
  
  mpfr_log(lb, lb, MPFR_RNDN);

  //mpfr_printf ("lb = %.8Rf\n", lb);
  
  spair *s;
  s = (spair*)malloc(sizeof *s);

  add_pair(&paths, 3, 3);
  add_pair(&sqrts, 3, 0);

  TAILQ_HEAD(head_s, node) head;
  TAILQ_INIT(&head);

  snode *e = NULL;

  e = malloc(sizeof(struct node));
  e->value = 3;
  TAILQ_INSERT_TAIL(&head, e, nodes);
  e = NULL;

  while (!TAILQ_EMPTY(&head)) {

    e = TAILQ_FIRST(&head);
    m = e->value;

    //printf("m = %ld\n",m);

    TAILQ_REMOVE(&head, e, nodes);
    free(e);
    e = NULL;

    mpfr_set_ui(x, m+1, MPFR_RNDN);
    //mpfr_printf ("m+1 = %.8Rf\n", x);

    //mpfr_printf ("x+1 = %.8Rf\n", x);
    mpfr_lngamma(x, x, MPFR_RNDN);
    //mpfr_printf ("log_gamma(x) = %.8Rf\n", x);

    //mpz_out_str(stdout,10,n);
    //printf("\n");

    // x = log_gamma(m+one)    
    // p = ceil(log(x/lb,2))
    
    mpfr_div(y, x, lb, MPFR_RNDN);
    mpfr_log2(y, y, MPFR_RNDN);
    //mpfr_printf ("log2(y/lb) = %.8Rf\n", y);
    
    mpfr_ceil(y, y);
    p = mpfr_get_ui(y, MPFR_RNDN);
    
    //printf("p = %d\n",p);
    
    i = 0;

    q = MAX(p,0);

    //printf("q = %d\n",q);
    
    i += q;

    //mpz_t tmp;
    //pow(2,q), MPFR_RNDN);
    //mpz_ui_pow_ui(tmp,2,q);
  
    mpfr_div_d(x, x, pow(2,q), MPFR_RNDN);
    //mpfr_div_z(x, x, tmp, MPFR_RNDN);
    mpfr_exp(x, x, MPFR_RNDN);

    //mpfr_printf ("x = %.8Rf\n", x);
    
    mpfr_get_z(n, x, MPFR_RNDN);
    //printf("n = ");
    //mpz_out_str(stdout,10,n);
    //printf("\n");

    //int nn;
    nn = mpz_get_ui(n);
    //nn = mpz_get_ull(n);
    //printf("nn = %lld\n", nn);
    
    while (nn>3) {
      
      HASH_FIND_INT(paths, &nn, s);
      if (s == NULL) {
        e = malloc(sizeof(struct node));
        e->value = nn;
        TAILQ_INSERT_TAIL(&head, e, nodes);
        e = NULL;

        add_pair(&paths, nn, m);
        add_pair(&sqrts, nn, i);
      }

      nn = sqrt(nn);
      i += 1;
    }
  }

  /*
  for (int i = 3; i<10; i++) {
    HASH_FIND_INT(paths, &i, s);
      if (s == NULL) {
        printf("%lld ",i);
      }
  }
  printf("\n");
  */

  i = 3;
  HASH_FIND_INT(paths, &i, s);
  while (s != NULL) {
    i += 1;
    HASH_FIND_INT(paths, &i, s);
  }
  printf("First missing value = %lld\n",i);

  unsigned long long int v,w;
  
  // Solvable with 20000 bound

  v = 9;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  // Solvable with 100000 bound
  v = 135;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  // Solvable with 1000000 bound
  v = 197;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  // Solvable with 10000000 bound
  v = 522;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  v = 1074;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }
      
  v = 1337;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  v = 22701;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  v = 75592;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }

  v = 563691;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%lld <- %lld! + %ld sqrt\n", v, w, s->value);
      v = w;
    }
  }
  
  return 0;
}
