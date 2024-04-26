
Random Josephus problem

p[i,j] is the probability that starting with i people,
the person in position j is the final survivor.
Note the first person to go is in position 1.

The recursive relation is:

p[i,j] = (j-2)/(i-1)*p[i-1,j-2] + (i-j)/(i-1)*p[i-1,j-1]

For person j to be the final survivor after person 1 goes,
either someone before them in the order was killed (positions
2..(j-1)), which occurs with probability (j-2)/(i-1), or someone
after them in the order was killed (positions (j+1)..i), which
occurs with probability (i-j)/(i-1).

If someone among positions 2..(j-1) was killed, the next person
to go puts the person originally in position j in position j-2.

If someone among positions (j+1)..i was killed, the next person
to go puts the person originally in position j in position j-1.

```bash
sage josephus.sage
```
