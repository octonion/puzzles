trans partitions (cards subtotal) {

  trans m 0
  trans total 0
  
  loop (trans i 0) (< i 10) (i:++) (
    if (> (cards:get i) 0)
      {
        total:= (+ (+ subtotal i) 1)
        if (< total 21) {
          m:++
          cards:set i (- (cards:get i) 1)
          m:+= (partitions cards total)
          cards:set i (+ (cards:get i) 1)
        }
        { if (== total 21) (m:++) }
      }
      ()
  )
  return m
}

const deck (Vector 4 4 4 4 4 4 4 4 4 16)
trans d 0
trans p 0

loop (trans i 0) (< i 10) (i:++) {
  deck:set i (- (deck:get i) 1)
  p:= 0
  loop (trans j 0) (< j 10) (j:++) {
    deck:set j (- (deck:get j) 1)
    p:+= (partitions deck (+ j 1))
    deck:set j (+ (deck:get j) 1)
  }
  deck:set i (+ (deck:get i) 1)
  d:+= p
  print "Dealer showing "
  print i
  print " partitions = "
  println p
}

print "Total partitions = "
println d
