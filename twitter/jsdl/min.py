import numpy as np
from scipy.optimize import minimize
from scipy.stats import poisson
from statistics import mean,stdev
from math import log

def kl_loss(mu):
    y = np.array(sample)*log(mu)
    return mean(mu-y)

def js_loss(mu):
    l = 2.0
    for k in keys:
        d = dist[k]
        p = poisson.pmf(k,mu)
        l += d*log(d,2) + p*log(p,2) - (d+p)*log(d+p,2)
    return l/2.0

sample = [1, 2]
keys = set(sample)
dist = {}
n = float(len(sample))
for k in keys:
    dist[k] = float(sample.count(k))/n

kl_p = minimize(kl_loss, 1)
js_p = minimize(js_loss, 1)
print(kl_p.x[0], js_p.x[0])

kl_list = []
js_list = []

for i in range(0,100):

    sample = list(np.random.poisson(4, 10))
    keys = set(sample)
    dist = {}
    n = float(len(sample))
    for k in keys:
        dist[k] = float(sample.count(k))/n

    kl_p = minimize(kl_loss, 1)
    js_p = minimize(js_loss, 1)
    kl_list += [kl_p.x[0]]
    js_list += [js_p.x[0]]

#print(kl_list)
#print(js_list)

print(mean(kl_list),stdev(kl_list))
print(mean(js_list),stdev(js_list))
