void main()
{

  import std.functional;
  import std.stdio: write, writeln, writef, writefln;

  /* Decks */

  enum decks = 1;

  enum  hit_soft_17 = false;

  double[22] dealer_p(int total,bool ace,int[10] cards,int n)
  {

    double[22] outcomes = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

    /* writeln(total,ace,cards,n); */

    if (total > 21) {
      outcomes[0] = 1.0;
    } else if (total >= 17) {
      outcomes[total] = 1.0;
    } else if ((total==7) && ace && !(hit_soft_17)) {
      outcomes[total+10] = 1.0;
    } else if ((8 <= total && total <= 11) && ace) {
      outcomes[total+10] = 1.0;
    } else {
      /* Hit */
      for (int i = 0; i < 10; i++) {
	if (cards[i] > 0) {
	  double p = double(cards[i])/double(n);
	  cards[i] += -1;
	  double[22] d = memoize!dealer_p(total+i+1,(ace || i==0),cards,n-1);
	  for (int j = 0; j < 22; j++) {
	    outcomes[j] += p*d[j];
	  }
	  cards[i] += 1;
	}
      }
    }
    return outcomes;
  }

  double[3] player_p(int total,bool ace,int[10] cards,int dc,int n) {
    double e_stand = 0.0;
    double e_hit = 0.0;
    double e_opt = 0.0;

    if (total <= 11 && ace) {
      double[22] d = memoize!dealer_p(dc,(dc==0),cards,n);
      for (int i = 0; i < total+10; i++) {
	e_stand += d[i];
      }
      for (int i = total+11; i < 22; i++) {
	e_stand += -d[i];
      }
    } else {
      double[22] d = memoize!dealer_p(dc,(dc==0),cards,n);
      for (int i = 0; i < total; i++) {
	e_stand += d[i];
      }
      for (int i = total+1; i < 22; i++) {
	e_stand += -d[i];
      }
    }
    /* Hit */

    for (int i = 0; i < 10; i++) {
      if (cards[i]>0) {
	double p = double(cards[i])/double(n);
	if (total+i+1 > 21) {
	  e_hit += -p;
	} else {
	  cards[i] += -1;
	  /* e = [optimal, hit, stand] */
	  double[3] e = memoize!player_p(total+i+1,(ace || i==0),cards,dc,n-1);
	  e_hit += p*e[0];
	  cards[i] += 1;
	}
      }
    }
    if (e_hit >= e_stand) {
      e_opt = e_hit;
    } else {
      e_opt = e_stand;
    }
    return [e_opt,e_hit,e_stand];
  }

  int[10] deck;
  double[10] p;

  for (int i = 0; i < 9; i++) {
    deck[i] = decks*4;
    p[i] = double(4)/double(52);
  }
  deck[9] = decks*16;
  p[9] = double(16)/double(52);

  for (int i = 1; i < 9; i++) {
    deck[i] += -1;

    for (int j = 0; j < 10; j++) {
      deck[j] += -1;
      for (int k = 0; k < 10; k++) {
            
	deck[k] += -1;
	double[3] e = memoize!player_p(j+k+2,(j==0 || k==0),deck,i+1,(decks*52-3));
	write(i+1," ",j+1," ",k+1);
	writef(" %.16f",e[1]);
	writefln(" %.16f",e[2]);
	deck[k] += 1;
      }
      deck[j] += 1;
    }
    deck[i] += 1;
  }
}

