deck = [4,4,4,4,4,4,4,4,4,16];
d = 0;

for i = 1:1:10
  % Dealer showing
  deck(i) -= 1;
  p = 0;
  for j = 1:1:10
    deck(j) -= 1;
    p += partitions(deck, j);
    deck(j) += 1;
  endfor;
  printf("Dealer showing %d partitions = %d\n",i-1,p);
  d += p;
  deck(i) += 1;
endfor;
printf("Total partitions = %d\n",d);
