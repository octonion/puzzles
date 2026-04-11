"""
fruits_solver_complete.sage
==========================

Certified SageMath solver for positive integer solutions of

    a/(b+c) + b/(a+c) + c/(a+b) = N.

This implementation follows Bremner--Macleod, *An unusual cubic representation
problem* (Ann. Math. Inform. 43 (2014), 29--41), together with the older
rank-specific search scripts in the repository.  The Mordell--Weil lattice search
strategy was suggested by Noam Elkies (personal communication).

Compatibility note
------------------
The solver is intended to run under both SageMath 10.7 and 10.8.  Two small
implementation details are version-sensitive in practice:
* PARI output from ``gp(...)`` may arrive as different Python wrapper types, so
  the code first tries ``raw.sage()`` and then falls back to ``gen_to_sage``.
* The Haar-measure quadrature used only for the heuristic first shell is kept in
  pure ``mpmath`` types to avoid mixed Sage/mpmath coercion failures that can
  occur in SageMath 10.7.

Design goals
------------
* exact elliptic-curve model and exact back-map to the cubic;
* all torsion translates tested by default;
* real-component-aware search, so only the affine parity coset that can hit the
  egg is searched;
* a fast direct rank-1 path, mirroring the old scripts for cases such as N=4;
* a default heuristic first shell based on the Haar-measure fraction of the egg
  corresponding to positive solutions, with default target probability p = 1/2;
* rigorous certification for the criteria
      - canonical height,
      - max(a,b,c) on primitive sorted triples,
      - a+b+c on primitive sorted triples.

Paper-based ingredients used explicitly
--------------------------------------
* Section 2: the model
      E_N: y^2 = x^3 + (4N^2 + 12N - 3)x^2 + 32(N+3)x,
  and the map
      a:b:c = -x+y+8(N+3) : -x-y+8(N+3) : -2(N+2)x - 8(N+3).
* Theorem 4.1: positivity intervals in the x-coordinate.  These are used as a
  cheap prefilter and to compute the Haar-measure fraction of the egg occupied
  by positive solutions.
* Theorem 5.1: odd N have no positive solutions.
* Lemma 2.1: torsion is cyclic of order 6 except at N=2, where it is
  Z/2Z x Z/6Z.  We simply test the full torsion list Sage returns.
* Theorem 7.1: if P corresponds to a positive solution then
      max(log a, log b) > (3/2) hhat(P) - 6 log N - 10,
  which certifies both the 'max' and 'sum' criteria.
"""

from sage.all import *
from sage.libs.pari.convert_sage import gen_to_sage
import mpmath as mp


# ---------------------------------------------------------------------------
# Utility classes
# ---------------------------------------------------------------------------

class SizeHeightLowerBound(object):
    """Affine lower bound used to certify size-based criteria."""

    def __init__(self, alpha=QQ(3) / QQ(2), beta_logN=QQ(6), beta_const=QQ(10)):
        self.alpha = RR(alpha)
        self.beta_logN = RR(beta_logN)
        self.beta_const = RR(beta_const)

    def beta(self, N):
        N = ZZ(N)
        if N <= 0:
            raise ValueError("N must be positive.")
        return self.beta_logN * log(RR(N)) + self.beta_const

    def certifies(self, N, best_size, searched_height_upper_bound):
        lhs = self.alpha * RR(searched_height_upper_bound) - self.beta(N)
        rhs = log(RR(best_size))
        return lhs > rhs

    def threshold_height(self, N, best_size):
        return (log(RR(best_size)) + self.beta(N)) / self.alpha


class Candidate(object):
    """An admissible rational point together with its primitive sorted triple."""

    def __init__(self, point, triple, height_value):
        self.point = point
        self.triple = tuple(ZZ(x) for x in triple)
        self.a, self.b, self.c = self.triple
        self.max_size = max(self.triple)
        self.sum_size = sum(self.triple)
        self.height = RR(height_value)

    def primary_key(self, criterion):
        if criterion == "canonical":
            return (self.height, self.triple)
        if criterion == "max":
            return (self.max_size, self.triple)
        if criterion == "sum":
            return (self.sum_size, self.triple)
        raise ValueError("Unknown criterion %r" % (criterion,))

    def summary_lines(self):
        return [
            "triple       = %s" % (self.triple,),
            "max(a,b,c)   = %s" % self.max_size,
            "a+b+c        = %s" % self.sum_size,
            "canonical h  = %.30f" % self.height,
        ]


# ---------------------------------------------------------------------------
# Fruits curve model and exact admissibility
# ---------------------------------------------------------------------------

class FruitsCurve(object):
    r"""
    Encapsulates the projective cubic and the chosen elliptic-curve model.

    We use the Bremner--Macleod model
        E_N: y^2 = x^3 + (4N^2 + 12N - 3)x^2 + 32(N+3)x
    and the explicit back-map
        a:b:c = -x+y+8(N+3) : -x-y+8(N+3) : -2(N+2)x - 8(N+3).

    Exact admissibility proceeds projectively: after clearing denominators, a
    common global sign is irrelevant.  Hence a point is accepted if its
    projective triple can be scaled to a primitive positive triple satisfying the
    original equation exactly.
    """

    def __init__(self, N, real_precision=212):
        self.N = ZZ(N)
        if self.N <= 0:
            raise ValueError("N must be a positive integer.")

        self.real_precision = int(real_precision)
        self.RR = RealField(self.real_precision)
        self.AA = AA

        R = PolynomialRing(QQ, names=("a", "b", "c"))
        a, b, c = R.gens()
        self.coordinate_ring = R
        self.cubic = (
            a * (a + b) * (a + c)
            + b * (a + b) * (b + c)
            + c * (a + c) * (b + c)
            - self.N * (a + b) * (a + c) * (b + c)
        )

        self.E = EllipticCurve_from_cubic(self.cubic, morphism=False)
        self.toE = EllipticCurve_from_cubic(self.cubic, morphism=True)
        self.fromE = self.toE.inverse()
        self.ES = self.E.short_weierstrass_model()
        self.F = self.ES.change_weierstrass_model([3, 12 * self.N**2 + 36 * self.N - 9, 0, 0])
        self.E_to_F = self.E.isomorphism_to(self.F)
        self.F_to_E = self.F.isomorphism_to(self.E)
        self.F_to_ES = self.F.isomorphism_to(self.ES)

        RRf = self.RR
        Nf = RRf(self.N)
        if self.N >= 2:
            disc = sqrt(4 * Nf**2 + 4 * Nf - 15)
            root = sqrt(Nf**2 - 4)
            self.prefilter_intervals = [
                ((RRf(3) - 12 * Nf - 4 * Nf**2 - (2 * Nf + 5) * disc) / 2,
                 -2 * (Nf + 3) * (Nf + root)),
                (-2 * (Nf + 3) * (Nf - root),
                 -4 * (Nf + 3) / (Nf + 2)),
            ]
        else:
            self.prefilter_intervals = []

        gpoly, hpoly = self.ES.hyperelliptic_polynomials()
        roots = list(gpoly.roots(self.AA, multiplicities=False))
        roots.sort()
        self.real_roots = roots
        self.has_two_real_components = (len(roots) == 3)
        self.identity_component_x_threshold = roots[-1] if roots else None
        self.egg_component_label = 1 if self.has_two_real_components else 0

        x = polygen(QQ, 'x')
        self.F_cubic_polynomial = x**3 + (4 * self.N**2 + 12 * self.N - 3) * x**2 + 32 * (self.N + 3) * x
        F_roots = list(self.F_cubic_polynomial.roots(self.AA, multiplicities=False))
        F_roots.sort()
        self.F_real_roots = [self.RR(r) for r in F_roots]
        if len(self.F_real_roots) == 3:
            self.egg_x_interval = (self.F_real_roots[0], self.F_real_roots[1])
            self.identity_component_x_threshold_F = self.F_real_roots[2]
        else:
            self.egg_x_interval = None
            self.identity_component_x_threshold_F = None
        self._positivity_fraction_cache = None

    def point_to_projective_rationals(self, P):
        if P.is_zero():
            raise ValueError("The identity point does not map to a finite projective triple.")
        x = QQ(P[0])
        y = QQ(P[1])
        N = QQ(self.N)
        a = -x + y + 8 * (N + 3)
        b = -x - y + 8 * (N + 3)
        c = -2 * (N + 2) * x - 8 * (N + 3)
        return (a, b, c)

    def primitive_sorted_triple(self, P):
        a, b, c = self.point_to_projective_rationals(P)
        den = lcm([QQ(a).denominator(), QQ(b).denominator(), QQ(c).denominator()])
        A = ZZ(a * den)
        B = ZZ(b * den)
        C = ZZ(c * den)

        # Projective triples are defined only up to a common sign.
        if A < 0 and B < 0 and C < 0:
            A, B, C = -A, -B, -C

        if not (A > 0 and B > 0 and C > 0):
            raise ValueError("Mapped projective triple cannot be scaled to all-positive coordinates.")

        g = gcd([abs(A), abs(B), abs(C)])
        A //= g
        B //= g
        C //= g
        triple = tuple(sorted((A, B, C)))

        if not self.verify_triple(triple):
            raise ValueError("Mapped triple does not satisfy the fruits equation exactly.")
        return triple

    def verify_triple(self, triple):
        A, B, C = map(QQ, triple)
        lhs = A / (B + C) + B / (A + C) + C / (A + B)
        return lhs == self.N

    def prefilter_by_x(self, P, edge_margin_bits=40):
        if P.is_zero():
            return False
        if not self.prefilter_intervals:
            return None
        try:
            x = self.RR(P[0])
        except Exception:
            return None

        eps = self.RR(2) ** (-max(10, self.real_precision - edge_margin_bits))
        near = False
        for lo, hi in self.prefilter_intervals:
            if x > lo + eps and x < hi - eps:
                return True
            if abs(x - lo) <= eps or abs(x - hi) <= eps:
                near = True
        return None if near else False

    def component_label(self, P):
        if not self.has_two_real_components:
            return 0
        if P.is_zero():
            return 0
        Q = self.F_to_ES(P)
        x = self.AA(Q[0])
        return 0 if x >= self.identity_component_x_threshold else 1

    def positivity_fraction_on_egg(self, dps=None):
        r"""
        Heuristic Haar-measure fraction of the egg corresponding to positive
        solutions.

        Theorem 4.1 gives the positivity region as two x-intervals on the egg in
        the model F.  Uniform distribution on the real elliptic component is with
        respect to the real elliptic logarithm, equivalently the invariant measure
        |dx/(2y)|.  On the bounded component y^2=(x-r_1)(r_2-x)(r_3-x) with
        r_1 < r_2 < r_3, the substitution
            x = (r_1+r_2)/2 + (r_2-r_1) sin(t)/2
        converts the egg measure to
            dt / sqrt(r_3 - x(t)).
        The returned value is therefore a numerical approximation to
            delta_N = mu(positive region on egg) / mu(full egg).
        It is used only for the initial-shell heuristic, not for certification.
        """
        if self._positivity_fraction_cache is not None and dps is None:
            return self._positivity_fraction_cache
        if not self.prefilter_intervals or self.egg_x_interval is None:
            result = self.RR(0)
            if dps is None:
                self._positivity_fraction_cache = result
            return result

        work_dps = int(dps or max(50, int(self.real_precision * 0.35) + 15))
        old_dps = mp.mp.dps
        mp.mp.dps = work_dps
        try:
            # Keep the quadrature entirely in mpmath types.  This avoids mixed
            # Sage/mpmath coercion issues observed in SageMath 10.7, while also
            # remaining perfectly fine under SageMath 10.8.
            one = mp.mpf('1')
            half = mp.mpf('0.5')
            neg_one = mp.mpf('-1')
            pos_one = mp.mpf('1')

            r1 = mp.mpf(str(self.egg_x_interval[0]))
            r2 = mp.mpf(str(self.egg_x_interval[1]))
            r3 = mp.mpf(str(self.identity_component_x_threshold_F))
            mid = half * (r1 + r2)
            span = half * (r2 - r1)

            def x_of_t(t):
                return mid + span * mp.sin(t)

            def density_t(t):
                return one / mp.sqrt(r3 - x_of_t(t))

            def t_of_x(x):
                z = (mp.mpf(str(x)) - mid) / span
                if z < neg_one:
                    z = neg_one
                elif z > pos_one:
                    z = pos_one
                return mp.asin(z)

            half_pi = half * mp.pi
            denom = mp.quad(density_t, [-half_pi, half_pi])
            num = mp.mpf('0')
            for lo, hi in self.prefilter_intervals:
                a = max(mp.mpf(str(lo)), r1)
                b = min(mp.mpf(str(hi)), r2)
                if a >= b:
                    continue
                ta = t_of_x(a)
                tb = t_of_x(b)
                num += mp.quad(density_t, [ta, tb])
            frac = num / denom if denom != mp.mpf('0') else mp.mpf('0')
            if frac < 0:
                frac = mp.mpf('0')
            if frac > 1:
                frac = mp.mpf('1')
            result = self.RR(str(frac))
        finally:
            mp.mp.dps = old_dps

        if dps is None:
            self._positivity_fraction_cache = result
        return result


# ---------------------------------------------------------------------------
# Mordell--Weil data and lattice enumeration
# ---------------------------------------------------------------------------

class MWData(object):
    """Certified Mordell--Weil data for the chosen curve F/Q."""

    def __init__(self, F, precision=212, proof=True, algorithm=None, use_lll=True):
        self.F = F
        self.precision = int(precision)
        self.RR = RealField(self.precision)
        self.proof = bool(proof)
        self.algorithm = algorithm
        self.use_lll = bool(use_lll)

        self.generators = self._compute_generators()
        self.rank = len(self.generators)
        self.generators_certain = self._gens_certain()
        self.torsion = list(F.torsion_points())
        self.torsion_order = ZZ(F.torsion_order())

        self.height_matrix = self._height_pairing_matrix()
        self.reduction_transform, self.reduced_height_matrix = self._reduce_gram_matrix()
        self.generator_heights = [self._point_height(P) for P in self.generators]

    def _compute_generators(self):
        kwargs = {"proof": self.proof}
        if self.algorithm is not None:
            kwargs["algorithm"] = self.algorithm
        try:
            return list(self.F.gens(**kwargs))
        except TypeError:
            try:
                return list(self.F.gens(proof=self.proof))
            except TypeError:
                return list(self.F.gens())

    def _gens_certain(self):
        try:
            return bool(self.F.gens_certain())
        except Exception:
            return None

    def _point_height(self, P):
        try:
            return self.RR(P.height(precision=self.precision, algorithm='pari'))
        except TypeError:
            try:
                return self.RR(P.height(precision=self.precision))
            except TypeError:
                return self.RR(P.height())

    def _height_pairing_matrix(self):
        r = len(self.generators)
        H = matrix(self.RR, r, r)
        if r == 0:
            return H
        hdiag = [self._point_height(P) for P in self.generators]
        for i in range(r):
            H[i, i] = hdiag[i]
        for i in range(r):
            for j in range(i):
                hij = self._point_height(self.generators[i] + self.generators[j])
                H[i, j] = H[j, i] = (hij - hdiag[i] - hdiag[j]) / 2
        return H

    def _reduce_gram_matrix(self):
        r = self.rank
        if r == 0:
            I = matrix(ZZ, 0, 0, [])
            return I, self.height_matrix
        if not self.use_lll or r == 1:
            U = identity_matrix(ZZ, r)
            return U, self.height_matrix
        try:
            U = self.height_matrix.LLL_gram()
            RH = U.transpose() * self.height_matrix * U
            return U.change_ring(ZZ), RH
        except Exception:
            U = identity_matrix(ZZ, r)
            return U, self.height_matrix

    def lattice_quadratic_value(self, n):
        if self.rank == 0:
            return self.RR(0)
        v = vector(self.RR, list(n))
        return v * self.height_matrix * v


class LatticeEnumerator(object):
    r"""
    Enumerate free-part lattice vectors with n^T H n <= B.

    We work in the LLL-reduced basis when available.  PARI's qfminim returns one
    representative for each pair ±m.  Since P and -P correspond to the same
    primitive sorted triple up to swapping a and b, we keep only that single
    representative and transform it back to the original coordinates.
    """

    def __init__(self, mw_data, shell_slack=None, max_pairs=None):
        self.mw = mw_data
        self.rank = mw_data.rank
        self.U = mw_data.reduction_transform
        self.Hred = mw_data.reduced_height_matrix
        self.shell_slack = RR(shell_slack) if shell_slack is not None else RR(2) ** (-40)
        self.max_pairs = max_pairs
        self._seen = set()

    def _convert_gp(self, raw):
        # SageMath 10.7 and 10.8 can expose PARI results through slightly
        # different wrapper types here.  Prefer the native .sage() conversion and
        # fall back to gen_to_sage for older/newer interface variants.
        try:
            return raw.sage()
        except Exception:
            return gen_to_sage(raw)

    def _gp_qfminim_matrix(self, bound):
        if self.rank == 0:
            return matrix(ZZ, 0, 0, [])
        PM = pari(self.Hred)
        B = pari(RR(bound) + self.shell_slack)
        if self.max_pairs is None:
            cmd = "qfminim(%s,%s,,2)" % (PM, B)
        else:
            cmd = "qfminim(%s,%s,%s,2)" % (PM, B, int(self.max_pairs))
        raw = gp(cmd)
        conv = self._convert_gp(raw)

        if hasattr(conv, "nrows") and hasattr(conv, "ncols"):
            return conv
        if isinstance(conv, (list, tuple)):
            for entry in reversed(conv):
                if hasattr(entry, "nrows") and hasattr(entry, "ncols"):
                    return entry
                if isinstance(entry, (list, tuple)) and len(entry) == 0:
                    return matrix(ZZ, self.rank, 0, [])
        if isinstance(conv, (list, tuple)) and len(conv) == 0:
            return matrix(ZZ, self.rank, 0, [])
        raise RuntimeError("Could not parse qfminim output.")

    def new_vectors_up_to(self, bound):
        if self.rank == 0:
            if () in self._seen:
                return []
            self._seen.add(())
            return [vector(ZZ, [])]

        V = self._gp_qfminim_matrix(bound)
        candidates = []
        zero = tuple([0] * self.rank)
        if zero not in self._seen:
            self._seen.add(zero)
            candidates.append(vector(ZZ, zero))

        for j in range(V.ncols()):
            m = vector(ZZ, [ZZ(V[i, j]) for i in range(V.nrows())])
            n = self.U * m
            key = tuple(ZZ(x) for x in n)
            if key in self._seen:
                continue
            qval = self.mw.lattice_quadratic_value(n)
            if qval <= RR(bound) + self.shell_slack:
                self._seen.add(key)
                candidates.append(vector(ZZ, key))

        candidates.sort(key=lambda v: (self.mw.lattice_quadratic_value(v), tuple(v)))
        return candidates


# ---------------------------------------------------------------------------
# Solver
# ---------------------------------------------------------------------------

class FruitsSolver(object):
    """Main search and certification driver."""

    def __init__(self,
                 N,
                 criterion="max",
                 precision=212,
                 proof=True,
                 algorithm=None,
                 use_lll=True,
                 use_x_prefilter=True,
                 shell_slack=None,
                 max_pairs=None,
                 lower_bound=None,
                 verbose=True):

        if criterion not in ("max", "sum", "canonical"):
            raise ValueError("criterion must be one of 'max', 'sum', 'canonical'.")

        self.curve = FruitsCurve(N, real_precision=precision)
        self.mw = MWData(self.curve.F,
                         precision=precision,
                         proof=proof,
                         algorithm=algorithm,
                         use_lll=use_lll)
        self.enumerator = LatticeEnumerator(self.mw,
                                            shell_slack=shell_slack,
                                            max_pairs=max_pairs)

        self.criterion = criterion
        self.verbose = bool(verbose)
        self.use_x_prefilter = bool(use_x_prefilter)
        self.lower_bound = lower_bound or SizeHeightLowerBound()

        self.best = None
        self.seen_triples = set()
        self.total_vectors_processed = 0
        self.total_points_tested = 0
        self.total_exact_admissibility_tests = 0
        self.total_hits = 0
        self.searched_height_bound = RR(0)
        self.rank1_seen_m = set()

        self.generator_component_bits = [self.curve.component_label(P) for P in self.mw.generators]
        self.torsion_component_bits = [self.curve.component_label(T) for T in self.mw.torsion]
        self.egg_label = self.curve.egg_component_label

        # Heuristic first-shell constants.  The egg/non-egg split is exact via the
        # component character; if some generator lies on the egg then the relevant
        # free-part vectors form one affine parity coset, hence asymptotic density
        # 1/2 in the full free lattice.  The higher-rank enumerator keeps one
        # representative from each sign pair ±n, so no further sign-density factor
        # is inserted here.
        if self.mw.rank > 0 and any(bit == self.egg_label for bit in self.generator_component_bits):
            self.egg_coset_density = RR(1) / RR(2)
        else:
            self.egg_coset_density = RR(1)
        self.heuristic_sample_density = self.egg_coset_density
        self.last_heuristic_info = None

        self.theorem_impossible_reason = None
        if ZZ(N) % 2 == 1:
            self.theorem_impossible_reason = (
                "By Bremner--Macleod Theorem 5.1, odd N admit no positive solution."
            )
        elif self.mw.rank > 0 and all(bit == 0 for bit in self.generator_component_bits):
            # Then every free-part combination stays on the identity component.
            if all(bit != self.egg_label for bit in self.torsion_component_bits):
                self.theorem_impossible_reason = (
                    "All free generators and all torsion points lie on the identity component, "
                    "so the egg component is unreachable."
                )

    def log(self, msg=""):
        if self.verbose:
            print(msg)

    def _point_height(self, P):
        try:
            return RR(P.height(precision=self.mw.precision, algorithm='pari'))
        except TypeError:
            try:
                return RR(P.height(precision=self.mw.precision))
            except TypeError:
                return RR(P.height())

    def candidate_from_point(self, P, height_value=None):
        triple = self.curve.primitive_sorted_triple(P)
        hval = self._point_height(P) if height_value is None else RR(height_value)
        return Candidate(P, triple, hval)

    def _maybe_record(self, cand):
        if cand.triple in self.seen_triples:
            return
        self.total_hits += 1
        self.seen_triples.add(cand.triple)
        if self.best is None or cand.primary_key(self.criterion) < self.best.primary_key(self.criterion):
            self.best = cand
            self.log("New best candidate:")
            for line in cand.summary_lines():
                self.log("  " + line)
            self.log("")

    def _eligible_torsion_indices(self, free_component_bit):
        target = (self.egg_label - free_component_bit) % 2
        return [i for i, bit in enumerate(self.torsion_component_bits) if bit == target]

    def _test_point(self, P, height_value=None):
        self.total_points_tested += 1

        if self.use_x_prefilter:
            quick = self.curve.prefilter_by_x(P)
            if quick is False:
                return

        self.total_exact_admissibility_tests += 1
        try:
            cand = self.candidate_from_point(P, height_value=height_value)
        except Exception:
            return
        self._maybe_record(cand)

    def _process_rank1_bound(self, bound):
        g = self.mw.generators[0]
        h = self.mw.generator_heights[0]
        g_bit = self.generator_component_bits[0]
        if h == 0:
            return 0

        m_max = ZZ(floor(sqrt(RR(bound) / h)))
        new_count = 0
        for m in range(0, int(m_max) + 1):
            if m in self.rank1_seen_m:
                continue
            self.rank1_seen_m.add(m)
            new_count += 1
            self.total_vectors_processed += 1

            free_bit = (m * g_bit) % 2
            eligible = self._eligible_torsion_indices(free_bit)
            if not eligible:
                continue

            free_part = ZZ(m) * g
            qval = RR(m * m) * h
            for idx in eligible:
                self._test_point(free_part + self.mw.torsion[idx], height_value=qval)
        self.searched_height_bound = RR(bound)
        return new_count

    def process_bound(self, bound):
        bound = RR(bound)
        if bound < self.searched_height_bound:
            raise ValueError("Cannot decrease the searched height bound.")

        self.log("Searching all free-part vectors with canonical height <= %.12f" % bound)

        if self.mw.rank == 1:
            new_count = self._process_rank1_bound(bound)
            self.log("  new lattice vectors: %s" % new_count)
            return

        new_vectors = self.enumerator.new_vectors_up_to(bound)
        self.log("  new lattice vectors: %s" % len(new_vectors))

        O = self.curve.F(0)
        for n in new_vectors:
            self.total_vectors_processed += 1
            free_bit = sum(ZZ(n[i]) * self.generator_component_bits[i] for i in range(self.mw.rank)) % 2
            eligible = self._eligible_torsion_indices(free_bit)
            if not eligible:
                continue

            free_part = O
            for coeff, gen in zip(n, self.mw.generators):
                if coeff:
                    free_part += ZZ(coeff) * gen
            qval = self.mw.lattice_quadratic_value(n)
            for idx in eligible:
                self._test_point(free_part + self.mw.torsion[idx], height_value=qval)

        self.searched_height_bound = bound

    def is_certified(self):
        if self.best is None:
            return False
        if self.enumerator.max_pairs is not None:
            return False
        if self.mw.rank > 0 and self.mw.generators_certain is not True:
            return False
        if self.criterion == "canonical":
            return self.searched_height_bound >= self.best.height
        if self.criterion == "max":
            return self.lower_bound.certifies(self.curve.N,
                                              self.best.max_size,
                                              self.searched_height_bound)
        if self.criterion == "sum":
            return self.lower_bound.certifies(self.curve.N,
                                              self.best.sum_size,
                                              self.searched_height_bound)
        return False

    def certification_target_bound(self):
        if self.best is None:
            return None
        if self.criterion == "canonical":
            return self.best.height
        if self.criterion == "max":
            return self.lower_bound.threshold_height(self.curve.N, self.best.max_size)
        if self.criterion == "sum":
            return self.lower_bound.threshold_height(self.curve.N, self.best.sum_size)
        return None

    def heuristic_initial_height(self, first_hit_prob=0.5, positivity_fraction=None):
        if self.mw.rank == 0:
            self.last_heuristic_info = {
                "p": RR(first_hit_prob),
                "delta": RR(0),
                "sample_density": RR(0),
                "unit_ball": RR(0),
                "detH": RR(1),
                "lambda": RR(0),
            }
            return RR(1)

        p = RR(first_hit_prob)
        if not (0 < p < 1):
            raise ValueError("first_hit_prob must lie strictly between 0 and 1.")
        r = self.mw.rank
        delta = self.curve.positivity_fraction_on_egg() if positivity_fraction is None else RR(positivity_fraction)
        if delta <= 0:
            raise ValueError("positivity_fraction must be positive for the heuristic initial shell.")

        detH = RR(self.mw.height_matrix.det()) if r > 0 else RR(1)
        unit_ball = pi ** (RR(r) / 2) / gamma(RR(r) / 2 + 1)
        lam = -log(RR(1) - p)

        # Expected number of egg-coset representatives up to height B:
        #     lambda(B) ~ delta_N * sample_density * vol(B) / sqrt(det H),
        # where delta_N is the Haar-measure fraction of the egg occupied by the
        # positive region, sample_density = 1/2 for the egg parity coset when the
        # egg is reachable, and
        #     vol(B) = v_r B^{r/2}
        # for the ellipsoid n^T H n <= B.
        #
        # Since the higher-rank enumerator already keeps one representative from
        # each sign pair ±n, no extra projective sign factor is inserted here.
        coeff = delta * self.heuristic_sample_density * unit_ball / sqrt(detH)
        B = (lam / coeff) ** (RR(2) / RR(r))
        B = max(B, RR(20))
        self.last_heuristic_info = {
            "p": p,
            "delta": delta,
            "sample_density": self.heuristic_sample_density,
            "unit_ball": RR(unit_ball),
            "detH": detH,
            "lambda": lam,
        }
        return B

    def automatic_search(self,
                         initial_height=None,
                         growth_factor=RR(2),
                         max_height=None,
                         first_hit_prob=None,
                         positivity_fraction=None,
                         report_every_shell=True):
        if self.theorem_impossible_reason is not None:
            return None

        if initial_height is None:
            if first_hit_prob is None:
                first_hit_prob = RR(1) / RR(2)
            B = self.heuristic_initial_height(first_hit_prob=first_hit_prob,
                                              positivity_fraction=positivity_fraction)
            info = self.last_heuristic_info or {}
            self.log(
                "Heuristic initial canonical-height bound from p=%.6f: %.12f" % (RR(first_hit_prob), B)
            )
            if info:
                self.log(
                    "  heuristic uses delta_egg=%.12f and effective sample density %.12f" %
                    (info.get("delta", RR(0)), info.get("sample_density", RR(0)))
                )
        else:
            B = RR(initial_height)

        if B <= 0:
            raise ValueError("initial_height must be positive.")
        if growth_factor <= 1:
            raise ValueError("growth_factor must exceed 1.")
        if max_height is not None:
            max_height = RR(max_height)

        while True:
            if max_height is not None and B > max_height:
                B = max_height

            if B > self.searched_height_bound:
                self.process_bound(B)
                if report_every_shell:
                    self.log("  total torsion translates tested = %s" % self.total_points_tested)
                    self.log("  exact admissibility tests      = %s" % self.total_exact_admissibility_tests)
                    self.log("  admissible hits found          = %s" % self.total_hits)
                    self.log("")

            if self.mw.rank == 0:
                break
            if self.best is not None and self.is_certified():
                break
            if max_height is not None and B >= max_height:
                break

            target = self.certification_target_bound()
            if self.best is None or target is None:
                B = B * growth_factor
            else:
                B = max(B * growth_factor, target + RR(1))

        return self.best

    def status_report(self):
        lines = []
        lines.append("N = %s" % self.curve.N)
        lines.append("Elliptic curve F = %s" % self.curve.F)
        lines.append("rank = %s" % self.mw.rank)
        lines.append("torsion order = %s" % self.mw.torsion_order)
        lines.append("torsion points = %s" % len(self.mw.torsion))
        lines.append("generator certification proved = %s" % self.mw.generators_certain)
        lines.append("enumeration pair cap = %s" % self.enumerator.max_pairs)
        if self.theorem_impossible_reason is not None:
            lines.append("theorem-based obstruction = %s" % self.theorem_impossible_reason)
        if self.mw.rank:
            lines.append("generator component bits (0=identity,1=egg) = %s" % self.generator_component_bits)
            lines.append("torsion component bits   (0=identity,1=egg) = %s" % self.torsion_component_bits)
            try:
                delta = self.curve.positivity_fraction_on_egg()
                lines.append("heuristic Haar fraction delta_egg = %.12f" % delta)
                lines.append("heuristic effective sample density = %.12f" % self.heuristic_sample_density)
            except Exception:
                pass
            lines.append("height-pairing matrix =")
            lines.append(str(self.mw.height_matrix))
            if self.mw.reduction_transform.nrows() > 0:
                lines.append("LLL transform U =")
                lines.append(str(self.mw.reduction_transform))
                lines.append("reduced Gram matrix U^T H U =")
                lines.append(str(self.mw.reduced_height_matrix))
        return "\n".join(lines)

    def final_report(self):
        lines = []
        lines.append("searched canonical height <= %.12f" % self.searched_height_bound)
        lines.append("free-part lattice vectors processed = %s" % self.total_vectors_processed)
        lines.append("torsion translates tested = %s" % self.total_points_tested)
        lines.append("exact admissibility tests = %s" % self.total_exact_admissibility_tests)
        lines.append("admissible hits found = %s" % self.total_hits)
        lines.append("")

        if self.best is None:
            if self.theorem_impossible_reason is not None:
                lines.append(self.theorem_impossible_reason)
            elif self.mw.rank == 0:
                lines.append("No positive solution exists: rank 0 and no admissible torsion point.")
            else:
                lines.append("No admissible solution found up to the searched height bound.")
            return "\n".join(lines)

        lines.append("Best solution for criterion '%s':" % self.criterion)
        for line in self.best.summary_lines():
            lines.append("  " + line)
        lines.append("")

        if self.criterion in ("max", "sum"):
            threshold = self.certification_target_bound()
            size_value = self.best.max_size if self.criterion == "max" else self.best.sum_size
            lines.append("size-height certification threshold (via Theorem 7.1) = %.12f" % threshold)
            lines.append("current best size = %s" % size_value)

        lines.append("Certified minimal for criterion '%s': %s" % (self.criterion, self.is_certified()))
        return "\n".join(lines)


# ---------------------------------------------------------------------------
# Command-line interface
# ---------------------------------------------------------------------------


def parse_args():
    import argparse

    p = argparse.ArgumentParser(
        description="Certified Mordell--Weil lattice solver for the fruits equation."
    )
    p.add_argument("N", type=int, help="target integer N in a/(b+c)+b/(a+c)+c/(a+b)=N")
    p.add_argument("--criterion", choices=["max", "sum", "canonical"], default="max",
                   help="minimality criterion on primitive sorted triples")
    p.add_argument("--precision", type=int, default=212,
                   help="working precision in bits for heights and real prefilters")
    p.add_argument("--proof", dest="proof", action="store_true", default=True,
                   help="ask Sage for proved generators (default)")
    p.add_argument("--no-proof", dest="proof", action="store_false",
                   help="allow unproved generators for speed")
    p.add_argument("--algorithm", default=None,
                   help="optional Sage gens() algorithm parameter, e.g. pari")
    p.add_argument("--no-lll", dest="use_lll", action="store_false", default=True,
                   help="disable LLL reduction of the height pairing matrix")
    p.add_argument("--no-x-prefilter", dest="use_x_prefilter", action="store_false", default=True,
                   help="disable the cheap x-interval prefilter")
    p.add_argument("--initial-height", type=float, default=None,
                   help="initial canonical-height bound for automatic search; overrides the heuristic default")
    p.add_argument("--first-hit-prob", type=float, default=None,
                   help="heuristic first-shell target probability p; default is 0.5 when --initial-height is omitted")
    p.add_argument("--positivity-fraction", type=float, default=None,
                   help="override the Haar-measure fraction delta_N of the egg occupied by positive solutions")
    p.add_argument("--rho-guess", dest="positivity_fraction", type=float, default=None,
                   help=argparse.SUPPRESS)
    p.add_argument("--growth-factor", type=float, default=2.0,
                   help="height-bound multiplier between search shells")
    p.add_argument("--max-height", type=float, default=None,
                   help="stop automatic search after this canonical-height bound")
    p.add_argument("--shell-slack", type=float, default=2.0**(-40),
                   help="extra slack added to qfminim bound before exact recheck")
    p.add_argument("--max-pairs", type=int, default=None,
                   help="optional qfminim pair cap; omit for certified exhaustive shells")
    p.add_argument("--size-alpha", type=float, default=1.5,
                   help="alpha in the size-height lower bound; default 3/2 from Theorem 7.1")
    p.add_argument("--size-beta-logN", type=float, default=6.0,
                   help="beta_logN in beta(N)=beta_logN*log(N)+beta_const; default 6")
    p.add_argument("--size-beta-const", type=float, default=10.0,
                   help="beta_const in beta(N)=beta_logN*log(N)+beta_const; default 10")
    p.add_argument("--quiet", action="store_true", default=False,
                   help="suppress shell-by-shell progress messages")
    return p.parse_args()


def main():
    args = parse_args()
    lb = SizeHeightLowerBound(alpha=args.size_alpha,
                              beta_logN=args.size_beta_logN,
                              beta_const=args.size_beta_const)

    solver = FruitsSolver(
        args.N,
        criterion=args.criterion,
        precision=args.precision,
        proof=args.proof,
        algorithm=args.algorithm,
        use_lll=args.use_lll,
        use_x_prefilter=args.use_x_prefilter,
        shell_slack=args.shell_slack,
        max_pairs=args.max_pairs,
        lower_bound=lb,
        verbose=(not args.quiet),
    )

    if not args.quiet:
        print(solver.status_report())
        print("")

    solver.automatic_search(
        initial_height=args.initial_height,
        growth_factor=args.growth_factor,
        max_height=args.max_height,
        first_hit_prob=args.first_hit_prob,
        positivity_fraction=args.positivity_fraction,
        report_every_shell=(not args.quiet),
    )

    print(solver.final_report())


if __name__ == "__main__":
    main()
