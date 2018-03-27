export fn partitions(cards: &[10]i8, subtotal: u8) u32 {
  var m: u32 = 0;

  // Hit
  var i: u8 = 0;
  while (i < 10) : (i += 1) {
    if ((*cards)[i]>0) {
      var total: u8 = subtotal+i+1;
      if (total < 21) {
        // Stand
        m += 1;
        // Hit again
        (*cards)[i] -= 1;
        m += partitions(cards, total);
        (*cards)[i] += 1;
      } else if (total==21) {
        // Stand; hit again is an automatic bust
        m += 1;
      }
    }
  }
  return m;
}
