#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

int main(void)
{

  void *lib;
  lib = dlopen("./partitions.so", RTLD_LAZY);
  int (*partitions)(int[10], int);
  //*(void **)(&partitions) = dlsym(lib, "partitions");
  //int (*partitions)(int*, int);
  partitions = dlsym(lib, "partitions");

  int deck[] = {4,4,4,4,4,4,4,4,4,16};
  int d=0;
  
  for (int i = 0; i < 10; i++) {
    // Dealer showing
    deck[i] -= 1;
    int p = 0;
    for (int j = 0; j < 10; j++) {
      deck[j] -= 1;
      p += partitions(deck, j+1);
      deck[j] += 1;
    }

    printf("Dealer showing %i partitions = %i\n",i,p);
    d += p;
    deck[i] += 1;
  }
  printf("Total partitions = %i\n",d);

  return 0;
}
