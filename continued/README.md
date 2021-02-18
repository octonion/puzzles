Fast Pell solvers using Conway's algorithm, a modifed version of the Strassen algorithm plus unrolling to simplify and remove matrix multiplication.

Powered versions first solve for the foundational solution to the squarefree argument, then resolve the square part using modular calculations.

```bash
g++ -std=c++17 -O3 conway_powered.cpp -lgmp -lgmpxx -o conway_powered

./conway_powered 61
```

```bash
chpl --fast conway_powered.chpl

./conway_powered -sarg=61
```

The full version also include Bhaskara-type shortcuts.

```bash
g++ -std=c++17 -O3 conway_full.cpp -lgmp -lgmpxx -o conway_full

./conway_full 61
```
