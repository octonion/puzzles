
proc partitions*(cards: var array[0..9, int], subtotal: int): int {. exportc, dynlib .} =
  var total: int
  result = 0

  # Hit
  for i in 0..9:
    if (cards[i]>0):
      total = subtotal+i+1
      if (total < 21):
        cards[i] -= 1
        # Stand
        result += 1
        # Hit again
        result += partitions(cards, total)
        cards[i] += 1
      elif (total==21):
        # Stand; hit again is an automatic bust
        result += 1
                
  return result
