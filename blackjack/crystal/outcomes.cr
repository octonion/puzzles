
deck = ([4]*9)
deck << 16

def partitions(cards, subtotal)
  m = 0
  # Hit
  (0..9).each do |i|
    if (cards[i]>0)
      cards[i] += -1
      total = subtotal+i+1
      if (total < 21)
        # Stand
        m += 1
        # Hit again
        m += partitions(cards, total)
      elsif (subtotal+i+1==21)
        # Stand; hit again is an automatic bust
        m += 1
      end
      cards[i] += 1
    end
  end
  return m
end

d = 0

(0..9).each do |i|
  # Dealer showing
  deck[i] = deck[i]-1
  p = 0
  (0..9).each do |j|
    deck[j] = deck[j]-1
    n = partitions(deck, j+1)
    deck[j] = deck[j]+1
    p += n
  end
  print("Dealer showing #{i} partitions = #{p}\n")
  d += p
  deck[i] = deck[i]+1
end

print("Total partitions = #{d}\n")
