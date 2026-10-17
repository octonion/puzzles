# Is Tokyo Right About How To Use Escalators?

Inspired by the article [Tokyo Wants People to Stand on Both Sides of the Escalator](https://www.citylab.com/transportation/2018/12/people-stand-walk-escalator-left-right-save-time-efficient/578479/), let's examine two different ways of using an escalator that can accommodate two people per step.

The first is people always stand, which is what railway officials in Tokyo want people to do. The second is people who want to stand stick to one side, leaving the other side free for those who wish to walk.

We'll look at the average amount of time people wait to board the escalator, the number of people processed per second, and the average amount of time people spend waiting for and actually on the escalator. We assume Poisson arrivals, fixed step intervals, one boarding place per lane per step, and walking at a fixed speed relative to the escalator.

## Files

- [`escalator.ipynb`](escalator.ipynb) — Jupyter notebook containing the analysis and calculations.
- [`escalator.py`](escalator.py) — Standalone Python script with the same calculations.
- [`escalator.txt`](escalator.txt) — Output of the standalone script.

## Running the calculation

Requires Python 3 and SciPy. Install SciPy with `python -m pip install scipy`, then run `python escalator.py`.

## Parameters

```python
# Horizontal length of escalator in meters
L = 10.0

# Depth of step in meters
d = 0.40

# Walking speed relative to the escalator in meters per second
w = 84/60

# Horizontal escalator speed in meters per second
s = 42/60

# Time between steps in seconds
D = d/s

# Average people per second
y = 1/2

# Average arrivals between steps
b = y*D
```

## Standing Only

If people stand on both sides, each arriving step has room for two people. This is a periodic queue with a batch capacity of two, rather than two independent servers. Let $D=d/s$ denote the time between steps and let $\lambda$ be the arrival rate.

If $X_n$ is the number of people waiting immediately before step $n$ arrives, then

$$
X_{n+1}=(X_n-2)^++A_n,\qquad A_n\sim\mathrm{Poisson}(\lambda D).
$$

Write $b=\lambda D$. For $0<b<2$, let $z\in(-1,0)$ be the negative root of

$$
z^2=e^{b(z-1)},\qquad z=-\frac{2}{b}W_0\left(\frac b2e^{-b/2}\right),
$$

where $W_0$ is the principal branch of the Lambert W function. The expected time spent waiting to board is

$$
t_Q=\frac D2+\frac1\lambda\left(\frac1{1-z}+\frac1{2-b}-1-\frac b2\right).
$$

For $\lambda=0$, the mean residual time until the next step is $D/2$.

The expected total time spent waiting and on the escalator is $T_S=t_Q+L/s$. Provided the queue is stable, the long-run number of people processed per second equals $\lambda$. The maximum boarding capacity is $2/D$.

```python
from math import exp
from scipy.special import lambertw

# Standing only: two people can board each step
def standing_wait(rate):
    load = rate*D
    if not 0 <= load < 2:
        raise ValueError("The standing queue is unstable")
    if rate == 0:
        return D/2
    p = load/2
    z = -lambertw(p*exp(-p)).real/p
    return D/2 + (1/(1-z) + 1/(2-load) - 1 - load/2)/rate

t = standing_wait(y)
print(f"Standing only expected waiting time = {t:.6f}")
print(f"Standing only expected total time = {t + L/s:.6f}")
print(f"Standing only people per second = {y:.6f}")
print(f"Standing only capacity = {2/D:.6f}")
```

```text
Standing only expected waiting time = 0.292842
Standing only expected total time = 14.578556
Standing only people per second = 0.500000
Standing only capacity = 3.500000
```

## One Side Walks, One Side Stands

Assuming the fraction of people who choose to walk or stand is fixed and their choices are independent, the Poisson arrival process splits into two independent Poisson processes. Each lane has room for one person on every step.

For a lane with arrival rate $\lambda_i$, the expected waiting time to board is

$$
t_{Q,i}=\frac{D}{2(1-\lambda_i D)},\qquad \lambda_i D<1.
$$

The time spent waiting and on the escalator is $T_E=t_{Q,i}+L/s$ for those standing and $T_E=t_{Q,i}+L/(s+w)$ for those walking, where $w$ is the horizontal walking speed relative to the escalator.

The overall average waiting and total times are the weighted averages of the two queues. If both lanes are stable, the number of people processed per second is the arrival rate $\lambda$. With a walker fraction $f$, the maximum sustainable arrival rate is

$$
\lambda_{\max}=\frac1{D\max(f,1-f)}.
$$

```python
from scipy.optimize import brentq

# Walk/stand splits
f_w = 0.20
f_s = 1-f_w

y_w = f_w*y
y_s = f_s*y

def lane_wait(rate):
    load = rate*D
    if not 0 <= load < 1:
        raise ValueError("The lane is unstable")
    return D/(2*(1-load))

t_w = lane_wait(y_w)
t_s = lane_wait(y_s)

q_t = f_w*t_w + f_s*t_s
print(f"Split queue expected waiting time = {q_t:.6f}")

s_t = f_w*(t_w + L/(s+w)) + f_s*(t_s + L/s)
print(f"Split queue expected total time = {s_t:.6f}")

cap_s = 1/(D*max(f_w, f_s))
print(f"Split queue people per second = {y:.6f}")
print(f"Split queue capacity = {cap_s:.6f}")
print(f"Standing only minus split total time = {t + L/s - s_t:.6f}")

def time_difference(rate):
    standing = standing_wait(rate) + L/s
    split = (f_w*(lane_wait(f_w*rate) + L/(s+w))
             + f_s*(lane_wait(f_s*rate) + L/s))
    return standing - split

if 0 < f_w < 1 and time_difference(0) * time_difference(0.999999*cap_s) < 0:
    crossover = brentq(time_difference, 0, 0.999999*cap_s)
    print(f"Total time crossover = {crossover:.6f} people per second")
```

```text
Split queue expected waiting time = 0.356902
Split queue expected total time = 12.737855
Split queue people per second = 0.500000
Split queue capacity = 2.187500
Standing only minus split total time = 1.840702
Total time crossover = 1.965752 people per second
```

## Conclusion

Standing on both sides minimizes the average time spent waiting to board, since passengers share the two available places on every step. In a stable system, both arrangements process the same number of people per second, although standing on both sides can accommodate a higher arrival rate when the walking and standing fractions are unequal.

With these parameters, allowing some people to walk reduces the average total time spent waiting and riding. At sufficiently high arrival rates, however, congestion in the standing lane can reverse that advantage. For the 20% walking split above, the total times are equal at approximately 1.965752 people per second. Safety, available space and actual boarding behavior may also affect the choice of policy.
