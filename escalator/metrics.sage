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

from sage.all import exp, lambert_w, find_root

# Standing only: two people can board each step
def standing_wait(rate):
    load = rate*D
    if not 0 <= load < 2:
        raise ValueError("The standing queue is unstable")
    if rate == 0:
        return D/2
    p = load/2
    z = -float(lambert_w(p*exp(-p)))/p
    return D/2 + (1/(1-z) + 1/(2-load) - 1 - load/2)/rate

t = standing_wait(y)
print(f"Standing only expected waiting time = {t:.6f}")
print(f"Standing only expected total time = {t + L/s:.6f}")
print(f"Standing only people per second = {y:.6f}")
print(f"Standing only capacity = {2/D:.6f}")

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
    crossover = find_root(time_difference, 0, 0.999999*cap_s)
    print(f"Total time crossover = {crossover:.6f} people per second")
