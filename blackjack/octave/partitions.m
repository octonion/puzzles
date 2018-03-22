function m = partitions(cards, subtotal)
  m = 0;
  % Hit
  for i = 1:1:10
    if (cards(i)>0)
      total = subtotal+i;
      if (total < 21)
        % Stand
	m += 1;
        % Hit again
	cards(i) -= 1;
        m += partitions(cards, total);
        cards(i) += 1;
      elseif (total==21)
        % Stand; hit again is an automatic bust
        m += 1;
      endif;
    endif;
  endfor;
endfunction;
