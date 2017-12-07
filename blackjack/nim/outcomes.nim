# Nim
var
  deck: array[0..9, int]
  n, p : int
  
for i in 0..8:
  deck[i] = 4 
deck[9] = 16

proc partitions(cards: var array[0..9, int], subtotal: int): int =
  var total: int
  result = 0

  #echo "Subtotal = ",subtotal
  #echo "Aces = ",cards[0]
  
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

var d = 0

for i in countup(0, 9):

    # Dealer showing

    deck[i] = deck[i]-1

    var p = 0
    for j in countup(0, 9):
        deck[j] = deck[j]-1
        n = partitions(deck, j+1)
        deck[j] = deck[j]+1
        p += n

    echo "Dealer showing ", i," partitions = ",p
    d += p

    deck[i] = deck[i]+1

echo "Total partitions = ",d
