We can define a pseudo-inner product for two equal length vectors by

x\* y = < max(x_i\* y_i).

In turn, we can use this to define a matrix product, taking the dot product of the ith row in A and jth column in B for the ij-th entry in the product A*B.

Arbitrage exists iff any diagonal entries for A^n are greater than 1, where n is the number of currencies in our exchange matrix. If no arbitrage exists, then A^m = A^n for all powers m>n.

Note this is essentially a nice implementation of the Floyd-Warshall algorithm, and in fact can be easily modified to run Floyd-Warshall on an arbitrary graph.

```bash
sage matrix.sage
```
