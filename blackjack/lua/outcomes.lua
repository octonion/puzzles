function partitions (cards, subtotal)
  local result = 0

  -- Hit
  for i = 1,10 do
    if (cards[i]>0) then
      local total = subtotal+i
      if (total < 21) then
        -- Stand
        result = result+1
        -- Hit again
        cards[i] = cards[i]-1
        result = result+partitions(cards, total)
        cards[i] = cards[i]+1
      elseif (total==21) then
        -- Stand; hit again is an automatic bust
        result = result+1
        break
      end
    end
  end
  return result
end

deck = {4,4,4,4,4,4,4,4,4,16}

d = 0

for i = 1,10 do
    -- Dealer showing
    deck[i] = deck[i]-1
    p = 0
    for j = 1,10 do
        deck[j] = deck[j]-1
        p = p+partitions(deck, j)
	deck[j] = deck[j]+1
    end
    io.write("Dealer showing ",i-1," partitions = ",p,"\n")
    d = d+p
    deck[i] = deck[i]+1
end

io.write("Total partitions = ",d,"\n")
