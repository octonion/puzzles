void main()
{
  import std.functional;
  import std.stdio: write, writeln, writef, writefln;
  import std.algorithm.iteration : sum;
  import std.array : array;
  import std.conv;

  int[10] deck;
  deck[0..9] = 4;
  deck[9] = 16;
  
  float[10] p = (to!(float[10])(deck)[] /= to!float(deck.array.sum));

  // Dealer hits soft 17
  enum hit_soft_17 = false;

  float[22] dealer;

  float[22] dealer_p(int total, bool ace, int cards)
  {
    float[22] outcomes;
    outcomes[0..22] = 0;
    
    if (total>21) {
        
      // Dealer busts
      outcomes[0] = 1.0;

    }
    else if (total >= 17) {

      // Dealer stands
      outcomes[total] = 1.0;
    }
    else if ((total==7) && ace && !(hit_soft_17)) {
      
      // Dealer stands on a soft 17
      outcomes[total+10] = 1.0;
    }
    else if ((8 <= total) && (total <= 11) && ace) {

      // Dealer stands on a soft total > 17
      outcomes[total+10] = 1.0;
    }
    else {

      // Dealer hits
      // Remove blackjacks

      int low,high;
        
      if (cards==1 && total==1) {
	high=9;
      }
      else {
	high=10;
      }

      if (cards==1 && total==10) {
	low=1;
      }
      else {
	low=0;
      }
            
      for (int i = low; i < high; i++) {
	outcomes[] += (dealer_p(total+i+1,(ace || i==0),cards+1)[] *= p[i])[];
      }

    }

    return outcomes;

  }

  float[3] player_p(int total, bool ace,int dc)
  {

    // Bust
    if (total > 21) {
      return [-1.0,-1.0,-1.0];
    }

    float e_stand;

    // Stand
    if (total <= 11 && ace) {
      // Stand on total+10
      e_stand = sum(dealer[0..total+10].array)-sum(dealer[total+11..$].array);
    }
    else {
      // Stand on total
      e_stand = sum(dealer[0..total].array)-sum(dealer[total+1..$].array);
    }

    float e_hit = 0.0;
    for (int i = 0; i < 10; i++) {
      float[3] e = memoize!player_p(total+i+1,(ace || i==0),dc);
      e_hit += p[i]*e[0];
    }

    // If we haven't busted we can always stand
    float e_best = e_stand;
    if (e_hit > e_best) {
      e_best = e_hit;
    }
    return [e_best,e_hit,e_stand];
  }

  for (int i = 1; i < 11; i++) {
    // Dealer has i showing
    
    dealer = dealer_p(i, i==1, 1);
    dealer[] /= sum(dealer.array);

    // Hard
    for (int j = 4; j < 22; j++) {
      float[3] e = memoize!player_p(j, false, i);
      writeln(i," hard ",j," ",e);
    }

    // Soft
    for (int j = 2; j < 12; j++) {
      float[3] e = memoize!player_p(j, true, i);
      writeln(i," soft ",j," ",e);
    }
  }
}
