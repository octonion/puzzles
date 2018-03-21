import x10.io.Console;

public class outcomes {

  public static def partitions(cards:Rail[Long], subtotal:Long) : Long
  {
    var m:Long = 0;
    var total:Long;
    // Hit
    for (i in 0..9) {
      if (cards(i)>0) {
	total = subtotal+i+1;
	if (total < 21) {
	// Stand
	m += 1;
	// Hit again
	cards(i) -= 1;
	m += partitions(cards, total);
	cards(i) += 1;
      } else if (total==21) {
        // Stand; hit again is an automatic bust
        m = m+1;
      }
      }
    }
    return m;
  }

public static def main(args:Rail[String])
{

  var deck:Rail[Long];
  deck = [4,4,4,4,4,4,4,4,4,16];
  var d:Long = 0;
  
  for (var i: Long = 0; i<10; i++) {
    // Dealer showing
    deck(i) -= 1;
    var p:Long = 0;
    for (var j: Long = 0; j<10; j++) {
      deck(j) -= 1;
      p += partitions(deck, j+1);
      deck(j) += 1;
    }
    Console.OUT.println("Dealer showing "+i+" partitions = "+p);
    d += p;
    deck(i) += 1;
  }
  Console.OUT.println("Total partitions = "+d);
}
}
