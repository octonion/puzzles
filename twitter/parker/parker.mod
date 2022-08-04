set Letter;
set Word;

param has_letter {Word,Letter} binary;

var Word_Used {Word} binary;

maximize Total_Words: sum {i in Word} Word_Used[i];

subject to Distinct_Letters {j in Letter}:
   sum {i in Word} Word_Used[i] * has_letter[i,j] <= 1;
