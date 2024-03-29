#include <stdio.h>
#include <gmp.h>
#include <math.h>

#include "queue.h"
#include "uthash.h"

typedef struct node
{
    int value;
    TAILQ_ENTRY(node) nodes;
}snode;

typedef struct pair {
  int key;
  int value;
  UT_hash_handle hh;
}spair;

spair *paths = NULL;
spair *sqrts = NULL;
int bound = 100000;
int m, v, w;

void add_pair(spair **dict, int id, int n) {
  
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
        printf("key %d: value %d\n", s->key, s->value);
    }
}

int i;
mpz_t n;

int main() {

  mpz_init(n);

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

  //print_dict(paths);
  //print_dict(sqrts);

  //TAILQ_FOREACH(e, &head, nodes) {
  //  printf("%d\n", e->value);
  //}

  while (!TAILQ_EMPTY(&head)) {

    e = TAILQ_FIRST(&head);
    m = e->value;
    //printf("Queue value %d\n",m);
    TAILQ_REMOVE(&head, e, nodes);
    free(e);
    e = NULL;
    
    mpz_fac_ui(n, m);
    //mpz_out_str(stdout,10,n);
    //printf("\n");
    
    i = 0;

    while (mpz_cmp_ui(n,bound)>0) {
    //    while (mpz_cmp(n,bound)) {
      mpz_sqrt(n, n);
      //mpz_out_str(stdout,10,n);
      //printf("\n");
      i += 1;
	}

    int nn;
    nn = mpz_get_ui(n);
    //printf("nn = %d\n",nn);
    
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
   
  for (int i = 3; i<1000; i++) {
    HASH_FIND_INT(paths, &i, s);
      if (s == NULL) {
        printf("%d ",i);
      }
  }
  printf("\n");

  /*  i = 3;
  HASH_FIND_INT(paths, &i, s);
  while (s != NULL) {
    i += 1;
    HASH_FIND_INT(paths, &i, s);
  }
  printf("First missing value = %d\n",i);
  */

  // Solvable with 20000 bound
  v = 9;
  HASH_FIND_INT(paths, &v, s);
  if (s!=NULL) {
    printf("\n");
    while (v!=3) {
      HASH_FIND_INT(paths, &v, s);
      w = s->value;
      HASH_FIND_INT(sqrts, &v, s);
      printf("%d <- %d! + %d sqrt\n", v, w, s->value);
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
      printf("%d <- %d! + %d sqrt\n", v, w, s->value);
      //      cout << v << " <- " << w << "! + " << sqrts[v] << " sqrt" << endl;
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
      printf("%d <- %d! + %d sqrt\n", v, w, s->value);
      //      cout << v << " <- " << w << "! + " << sqrts[v] << " sqrt" << endl;
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
      printf("%d <- %d! + %d sqrt\n", v, w, s->value);
      //      cout << v << " <- " << w << "! + " << sqrts[v] << " sqrt" << endl;
      v = w;
    }
  }
  
  return 0;
}
