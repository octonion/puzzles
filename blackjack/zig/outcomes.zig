const std = @import("std");
const io = std.io;

fn partitions(cards: &[10]i8, subtotal: usize) usize {
  var m: usize = 0;

  // Hit
  var i: usize = 0;
  while (i < 10) : (i += 1) {
    if ((*cards)[i]>0) {
      var total: usize = subtotal+i+1;
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

pub fn main() !void
{
  var stdout_file = try io.getStdOut();
  var stdout_file_stream = io.FileOutStream.init(&stdout_file);
  const stdout = &stdout_file_stream.stream;

  var deck: [10]i8 = []i8{4,4,4,4,4,4,4,4,4,16};
  var d: usize = 0;
  
  var i: usize = 0;
  while (i < 10) : (i += 1) {
    // Dealer showing
    deck[i] -= 1;
    var p: usize = 0;
    var j: usize = 0;
    while (j < 10) : (j += 1) {
      deck[j] -= 1;
      p += partitions(&deck, j+1);
      deck[j] += 1;
    }

    try stdout.print("Dealer showing {} partitions = {}\n",i,p);
    d += p;
    deck[i] += 1;
  }
  try stdout.print("Total partitions = {}\n",d);
}
