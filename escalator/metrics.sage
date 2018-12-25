# horizontal length of escalator in meters
L = 10

# depth of step in meters
d = 0.40

# walking speed in meters per second
w = 84/60

# horizontal escalator speed in meters per second
s = 42/60

# deterministic service time in seconds
D = s/d

# Average people per second
y = 1/2

# arrival in units of fixed service time
b = y*D

# M/D/2

# servers
c = 2
p = b/c

u = -1/p*lambert_w(-p/exp(p))
v = -1/p*lambert_w(p/exp(p))
#print(u.n(),v.n())

m = min(u.n(),v.n())

# expected queue waiting time
W = 1/(1-m) + 1/2*(c*p+1/(1-p)-c)
t = W/y-D
print("M/D/2 expected waiting time = %s" %(t))
print("M/D/2 expected system time = %s" %(t+L/s))

# People per second
ps_2 = 1/(1/y+t)

print("M/D/2 people per second = %s" %(ps_2))
print

# fast/slow splits

f_f = 0.20
f_s = 1-f_f

y_f = f_f*y
y_s = f_s*y

p_f = y_f*D
p_s = y_s*D

t_f = p_f/2*D/(1-p_f)
t_s = p_s/2*D/(1-p_s)

q_t = f_f*t_f+f_s*t_s
print("Split queue expected waiting time = %s" %(q_t))

s_t = f_f*(t_f+L/(s+w)) + f_s*(t_s+L/s)

print("Split queue expected system time = %s" %(s_t))

# People per second
ps_s = 1/(1/y_f+t_f) + 1/(1/y_s+t_s)

print("Split queue people per second = %s" %(ps_s))

print
print("Ratio of M/D/2 pps to split queue pps = %s" %(ps_2/ps_s))
