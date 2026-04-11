# Certified solver for the fruits equation

This repository contains a documented SageMath solver for positive integer solutions of

```text
a/(b+c) + b/(a+c) + c/(a+b) = N.
```

The implementation follows Bremner and Macleod, *An unusual cubic representation problem* (Ann. Math. Inform. 43 (2014), 29-41), together with the structure of the older rank-specific scripts in this repository. The Mordell-Weil lattice search strategy is attributed to Noam Elkies, personal communication.

## Main script

```text
fruits_solver_complete.sage
```

## SageMath support

The current solver is intended to support both **SageMath 10.7** and **SageMath 10.8**.

Two small implementation details are version-sensitive in practice.

- The PARI interface may expose `gp(...)` results through different wrapper types, so the code first tries `raw.sage()` and then falls back to `gen_to_sage`.
- The Haar-measure quadrature used only for the heuristic initial shell is kept in pure `mpmath` types. This avoids mixed Sage/mpmath coercion issues observed under SageMath 10.7 while remaining fully compatible with SageMath 10.8.

These compatibility adjustments affect only auxiliary implementation details. They do **not** change the mathematical search or certification logic.

The solver supports three certification targets on **primitive sorted triples** `(a,b,c)`:

- `max`: minimize `max(a,b,c)`.
- `sum`: minimize `a+b+c`.
- `canonical`: minimize canonical height on the elliptic curve.

The default criterion is `max`.

## Mathematical inputs

The solver uses Bremner-Macleod's elliptic curve model

```text
E_N: y^2 = x^3 + (4N^2 + 12N - 3)x^2 + 32(N+3)x
```

and the explicit back-map

```text
a:b:c = -x+y+8(N+3) : -x-y+8(N+3) : -2(N+2)x - 8(N+3).
```

The solver uses the following paper-based facts directly.

- **Theorem 4.1** gives the two `x`-intervals on the bounded real component (the egg) corresponding to positive solutions.
- **Theorem 5.1** implies that odd `N` have no positive solutions.
- **Theorem 7.1** gives the lower bound

  ```text
  max(log a, log b) > (3/2) hhat(P) - 6 log N - 10,
  ```

  which certifies both the `max` and `sum` criteria.
- **Lemma 2.1** describes the torsion subgroup. The code simply tests the full torsion list Sage returns, so the exceptional `N = 2` case is handled automatically.

## Search strategy

The solver is **component-aware**.

1. It computes which generators lie on the egg.
2. It uses the component homomorphism to restrict the search to the affine parity coset that can land on the egg.
3. It uses Theorem 4.1 as a cheap `x`-coordinate prefilter.
4. Only then does it map the surviving points back to the cubic exactly.

This is the same structural idea as the old rank-specific scripts. In rank `1`, the solver uses a direct cyclic search in the spirit of the original code. In higher rank, it uses the full Mordell-Weil lattice with LLL reduction and `qfminim`. Since `qfminim(...,2)` already returns one representative from each sign pair `±n`, the solver no longer duplicates those vectors in the higher-rank search. This reduces work without changing the primitive sorted solution that is ultimately certified.

## Heuristic initial shell

When `--initial-height` is omitted, the solver now chooses the first search shell **heuristically** using a default target probability

```text
p = 0.5.
```

This heuristic is not a proof. It is only used to choose the first shell; certification still comes from the exhaustive height search.

The model has two ingredients.

### 1. Egg versus non-egg is deterministic

Whether a point lies on the egg is not treated probabilistically. Once the generators are known, the component character gives an exact parity condition. Asymptotically, the relevant free-part vectors therefore occupy one affine parity coset, i.e. density `1/2` inside the full Mordell-Weil lattice when the egg is reachable.

### 2. Positivity inside the egg is heuristic

The positivity region is the union of the two intervals from Theorem 4.1. The solver computes the **Haar-measure fraction**

```text
delta_N = mu(positive region on egg) / mu(full egg),
```

where `mu` is the natural real elliptic-group measure `|dx/(2y)|`. This matches the paper's discussion that, in rank `1`, a crude estimate gives probability `O(1/N)` for a random point on the egg to land in the positive region.

The solver then models the expected number of egg-coset representatives up to height `B` by

```text
lambda(B) ~ delta_N * sample_density * v_r * B^(r/2) / sqrt(det H),
```

where
- `H` is the canonical-height Gram matrix,
- `v_r` is the volume of the Euclidean unit ball in rank `r`,
- `sample_density = 1/2` for the egg parity coset when the egg is reachable.

No extra sign-density factor is inserted here, because the higher-rank enumerator already keeps one representative from each sign pair `±n`.

The initial shell is then chosen from the heuristic equation

```text
1 - exp(-lambda(B)) ~= p.
```

By default, `p = 0.5`.

## Exact admissibility

The exact positivity test is projective.

A point is mapped back to a rational triple `(a:b:c)`, denominators are cleared, and a common sign change is allowed before checking positivity. This matters because the cubic coordinates are projective: a point with all three coordinates negative still represents the same positive solution after scaling by `-1`.

## Useful command lines

```bash
sage fruits_solver_complete.sage 4
sage fruits_solver_complete.sage 34 --criterion canonical
sage fruits_solver_complete.sage 424 --criterion max
sage fruits_solver_complete.sage 80376 --first-hit-prob 0.9
```

You can force a specific initial search radius with

```bash
sage fruits_solver_complete.sage 424 --initial-height 120
```

You can override the positivity fraction used in the heuristic with

```bash
sage fruits_solver_complete.sage 424 --positivity-fraction 0.01
```

This only changes the first shell. It does **not** affect the final proof of minimality.

## Files

- `fruits_solver_complete.sage`: current single-file solver.
- `fruits_solver_note.tex`: mathematical note describing the certification logic and the heuristic initial-shell model.
- `fruits_solver_note.pdf`: compiled PDF of the note.

## Current status

The current solver combines the strengths of the old scripts and the new certified search:

- rank `1` uses a direct cyclic search,
- higher rank uses a component-coset lattice search,
- the initial shell is chosen by a Haar-measure heuristic on the egg,
- exact projective positivity is handled correctly,
- and certification is available for `max`, `sum`, and `canonical`.


## Version note

The code path described above has been exercised successfully under SageMath 10.8 and under SageMath 10.7 after the compatibility fixes described above. In particular, the 10.7 support update keeps the heuristic quadrature purely in `mpmath`, while the 10.8-compatible PARI conversion fallback remains in place for the lattice enumeration backend.
