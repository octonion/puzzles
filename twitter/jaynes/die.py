from scipy.stats import poisson
from scipy.stats import skellam
from scipy.optimize import minimize
from math import floor, ceil
import numpy as np
from math import log

def js(pd):
    qd = np.array([1/6]*6)
    md = np.array(pd+qd)/2
    jsd = 0.0
    for i in range(0,6):
        jsd += pd[i]*log(pd[i]/md[i])
    for i in range(0,6):
        jsd += qd[i]*log(qd[i]/md[i])

    return(jsd/2)

def kl(pd):
    qd = np.array([1/6]*6)
    kld = 0.0
    for i in range(0,6):
        kld += pd[i]*log(pd[i]/qd[i])

    return(kld)

p0 = (1/18,1/18,1/18,5/18,5/18,5/18)
f = lambda p: kl((p[0],p[1],p[2],p[3],p[4],p[5]))

bnds = [(0.001,0.999),(0.001,0.999),(0.001,0.999),(0.001,0.999),(0.001,0.999),(0.001,0.999)]
cons = ({'type': 'ineq', 'fun': lambda p: p[0]},
	{'type': 'ineq', 'fun': lambda p: 1-p[0]},
	{'type': 'ineq', 'fun': lambda p: p[1]},
	{'type': 'ineq', 'fun': lambda p: 1-p[1]},
        {'type': 'ineq', 'fun': lambda p: p[2]},
	{'type': 'ineq', 'fun': lambda p: 1-p[2]},
        {'type': 'ineq', 'fun': lambda p: p[3]},
	{'type': 'ineq', 'fun': lambda p: 1-p[3]},
        {'type': 'ineq', 'fun': lambda p: p[4]},
	{'type': 'ineq', 'fun': lambda p: 1-p[4]},
        {'type': 'ineq', 'fun': lambda p: p[5]},
	{'type': 'ineq', 'fun': lambda p: 1-p[5]},
	{'type': 'eq', 'fun': lambda p: p[0]+p[1]+p[2]+p[3]+p[4]+p[5] - 1},
	{'type': 'eq', 'fun': lambda p: 1*p[0]+2*p[1]+3*p[2]+4*p[3]+5*p[4]+6*p[5]-4.5})
	    
solution = minimize(f, p0, bounds=bnds, constraints=cons)
#, tol=1e-10)

print(solution)
x = solution['x']

print(x)

p0 = (1/18,1/18,1/18,5/18,5/18,5/18)
f = lambda p: js((p[0],p[1],p[2],p[3],p[4],p[5]))

bnds = [(0.001,0.999),(0.001,0.999),(0.001,0.999),(0.001,0.999),(0.001,0.999),(0.001,0.999)]
cons = ({'type': 'ineq', 'fun': lambda p: p[0]},
	{'type': 'ineq', 'fun': lambda p: 1-p[0]},
	{'type': 'ineq', 'fun': lambda p: p[1]},
	{'type': 'ineq', 'fun': lambda p: 1-p[1]},
        {'type': 'ineq', 'fun': lambda p: p[2]},
	{'type': 'ineq', 'fun': lambda p: 1-p[2]},
        {'type': 'ineq', 'fun': lambda p: p[3]},
	{'type': 'ineq', 'fun': lambda p: 1-p[3]},
        {'type': 'ineq', 'fun': lambda p: p[4]},
	{'type': 'ineq', 'fun': lambda p: 1-p[4]},
        {'type': 'ineq', 'fun': lambda p: p[5]},
	{'type': 'ineq', 'fun': lambda p: 1-p[5]},
	{'type': 'eq', 'fun': lambda p: p[0]+p[1]+p[2]+p[3]+p[4]+p[5] - 1},
	{'type': 'eq', 'fun': lambda p: 1*p[0]+2*p[1]+3*p[2]+4*p[3]+5*p[4]+6*p[5]-4.5})
	    
solution = minimize(f, p0, bounds=bnds, constraints=cons)
#, tol=1e-10)

print(solution)
x = solution['x']

print(x)
