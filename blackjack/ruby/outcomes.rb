#!/usr/bin/env ruby

deck = ([4]*9)
deck << 16

def partitions(cards, subtotal)
  m = 0
  # Hit
  for i in 0..9
    if (cards[i]>0) then
      cards[i] += -1
      total = subtotal+i+1
      if (total < 21) then
        # Stand
        m += 1
        # Hit again
        m += partitions(cards, total)
          elsif (subtotal+i+1==21) then
        # Stand; hit again is an automatic bust
        m += 1
      end
      cards[i] += 1
    end
  end
  return m
end

d = 0

for i in 0..9
  # Dealer showing
  deck[i] = deck[i]-1
  p = 0
  for j in 0..9
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
