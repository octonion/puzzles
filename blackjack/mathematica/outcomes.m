Clear[partitions];
SetAttributes[partitions, HoldFirst];
partitions[cards_, subtotal_] :=
  Module[{i,m,total},
    m=0;
    For[i = 0, i < 10, i++;
	If[cards[[i]]>0,
        total = subtotal+i;
	Which[total < 21, m += 1;
	      cards[[i]] -= 1;
	      m += partitions[cards, total];
	      cards[[i]] += 1,
  	      total==21, m += 1]]];
    Return[m]
];

deck = {4,4,4,4,4,4,4,4,4,16};
d=0;

For[i = 0, i < 10, i++;
    deck[[i]] -= 1;
    p = 0;
    For[j = 0, j < 10, j++;
      deck[[j]] -= 1;
      p += partitions[deck, j];
      deck[[j]] += 1];
    Print["Dealer showing ",i-1," partitions = ",p];
    d += p;
    deck[[i]] += 1];
Print["Total partitions = ",d];
