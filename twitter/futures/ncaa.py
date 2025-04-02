from scipy.optimize import minimize
import numpy as np
import time

# maximize p_1 * log(1 + x - f_2-f_3-f_4)
# + p_2 * log(1 + f_2 * b_2-f_3-f_4)
# + p_3 * np.log(1 + f_3 * b_3-f_2-f_4)
# + p_4 * np.log(1 + f_4 * b_4-f_2-f_3)

# where 0 <= p_1, p_2, p_3, p_4
# p_1+p_2+p_3+p_4 = 1
# 0 <= f_2, f_3, f_4
# f_2+f_3+f_4 <= 1
# x >= 0

# Payout normalized to bankroll

x = 8.0/10.0

# Futures

auburn = 6.810
duke = 2.010
florida = 3.830
houston = 5.650

b_auburn = auburn-1
b_duke = duke-1
b_florida = florida-1
b_houston = houston-1

s = 1/auburn + 1/duke + 1/florida + 1/houston

p_auburn = 1/auburn / s
p_duke = 1/duke / s
p_florida = 1/florida / s
p_houston = 1/houston / s

obj = lambda f: -(p_florida*np.log(1+x+b_florida*f[3]-f[0]-f[1]-f[2]) + p_auburn*np.log(1+f[0]*b_auburn-f[1]-f[2]-f[3]) + p_duke*np.log(1+f[1]*b_duke-f[0]-f[2]-f[3]) + p_houston*np.log(1+f[2]*b_houston-f[0]-f[1]-f[3]))

# Jacobian
obj_Jac = lambda f: Jacobian(lambda f: obj(f))(f).ravel()

# constraints

# >= 0

constraints = ({'type': 'ineq', 'fun': lambda f: 1-(f[3]+f[0]+f[1]+f[2])}
               )

# bounds

# 0 <= f[i] <= 1

bounds = ((0,1),
          (0,1),
          (0,1),
          (0,1)
          )

f0 = (0,0,0,0)

start_time = time.time()*1000
result = minimize(obj, f0, method='SLSQP', bounds=bounds, constraints=constraints)
end_time = time.time()*1000
print('\n',result)
print("optimal value p*", result.fun)
print("optimal var: auburn = ", result.x[0], " duke = ", result.x[1], " houston = ", result.x[2])
# Should generally be 0
print("optimal var: florida = ", result.x[3])
print("exec time (ms): ", end_time - start_time)
