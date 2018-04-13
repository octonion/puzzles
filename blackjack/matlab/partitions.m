function m = partitions(cards, subtotal)
  m=0;
  % Hit
  for i=1:1:10
    if (cards(i)>0)
      total=subtotal+i;
      if (total < 21)
        % Stand
        m=m+1;
        % Hit again
        cards(i)=cards(i)-1;
        m=m+partitions(cards, total);
        cards(i)=cards(i)+1;
      elseif (total==21)
        % Stand; hit again is an automatic bust
        m=m+1;
      end
    end
  end
end
