Proposed by Mohammad Reza Ariya @ariya_7213 on Twitter.

a_1 < 0,
a_{n+1} = e^{a_n} - 1, n>1
Find lim n->+infinity n*a_n.

A little trick that may help you get on the right track with problems like these is to examine the analogous differential equation. Here, we have

a_{n+1}-a_n = e^{a_n}-a_n-1,

and the analogous differential equation is

y' = e^y-y-1.

Or dy/(e^y-y-1) = dx.
This can't be solved exactly, but we have the Puiseux series around y=0

-2/y - 2*log(y)/3 + O(y) = x + C.

Now, we're interested in the value x*y as y -> 0, so

-2 - 2*y*log(y)/3 + O(y^2) = x*y + C*y,

and as y -> 0 this implies x*y -> -2, suggesting -2.

A little trick I learned from the great Martin Kruskal, who is very much missed.

```bash
sage limit.sage
```
