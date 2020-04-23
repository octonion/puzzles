Fast Pell solvers using Conway's algorithm, a modifed version of the Strassen algorith and unrolling to simplify and remove matrix multiplication.

Powered versions first solve for the fundational solution to the squarefree argument, then resolve the square part using modular calculations.

```bash
g++ -std=c++17 -O3 conway_powered.cpp -lgmp -lgmpxx -o conway_powered

./conway_powered 61
```

```bash
chpl --fast conway_powered.chpl

./conway_powered -sarg=61
./a.out
```
