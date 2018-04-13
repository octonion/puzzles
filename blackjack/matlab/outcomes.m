deck = [4,4,4,4,4,4,4,4,4,16];
d = 0;

for i = 1:1:10
  % Dealer showing
  deck(i)=deck(i)-1;
  p=0;
  for j = 1:1:10
    deck(j)=deck(j)-1;
    p=p+partitions(deck, j);
    deck(j)=deck(j)+1;
  end
  fprintf("Dealer showing %d partitions = %d\n",i-1,p);
  d=d+p;
  deck(i)=deck(i)+1;
end
fprintf("Total partitions = %d\n",d);

exit;
