
proc partitions*(cards: var array[0..9, int], subtotal: int): int {. exportc, dynlib .} =
  var total: int
  result = 0

  # Hit
  for i in countup(0, 9):
    if (cards[i]>0):
      cards[i] = cards[i]-1
      total = subtotal+i+1
      if (total < 21):
        # Stand
        result += 1
        # Hit again
        result += partitions(cards, total)
      elif (subtotal+i+1==21):
        # Stand; hit again is an automatic bust
        result += 1
      cards[i] = cards[i]+1
                
  return result
